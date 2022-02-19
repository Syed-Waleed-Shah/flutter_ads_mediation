import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_ads_mediation/models/ad_colony.dart';
import 'package:flutter_ads_mediation/models/app_lovin.dart';
import 'package:flutter_ads_mediation/models/facebook.dart';
import 'package:flutter_ads_mediation/models/google.dart';
import 'package:xml/xml.dart';

import 'file_utils.dart';

class AndroidSetup {
  final String PATH_MANIFEST = 'android/app/src/main/AndroidManifest.xml';
  final String APP_LEVEL_GRADLE = 'android/app/build.gradle';
  final String PLIST_PATH = 'ios/Runner/Info.plist';
  final String PODFILE_PATH = 'ios/Podfile';
  final String AD_UNIT_ID_PATH = 'lib/ad_unit_ids/ad_unit_id.dart';
  final String MAIN_PATH = 'lib/main.dart';
  final String GRADLE_PROPERTIES_PATH = 'android/gradle.properties';

  final String jsonFilePath;
  late AppLovin _appLovin;
  late Google _google;
  late Facebook _facebook;
  late AdColony _adColony;

  final String APPLICATION_ID = """\n        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="APPLICATION_ID_HERE"/>""";
  final String APPLOVIN_SDK_KEY = """<meta-data
            android:name="applovin.sdk.key"
            android:value="APPLOVIN_SDK_KEY_HERE" />""";

  final String PODFILE_GOOGLE_IMPORT = """pod 'Google-Mobile-Ads-SDK'""";
  final String PODFILE_APPLOVIN_IMPORT =
      """pod 'GoogleMobileAdsMediationAppLovin'""";

  final String PODFILE_FACEBOOK_IMPORT =
      """pod 'GoogleMobileAdsMediationFacebook'""";

  final String PODFILE_ADCOLONY_IMPORT =
      """pod 'GoogleMobileAdsMediationAdColony'""";

  AndroidSetup(this.jsonFilePath);
  Future<void> process() async {
    if (await fileExists(jsonFilePath)) {
      _loadObjects(jsonFilePath);
      _platformSpecificSetup();
      _getMainCode();
    } else {
      print('The json file you provided doesnt exists!');
    }
  }

  _nativeCodeGeneration() {}

  _platformSpecificSetup() async {
    Future.delayed(Duration(seconds: 2)).then((value) {
      _androidManifestUpdate();
      _buildGradleUpdate();
      _iosInfoPlistUpdate();
      _iosPodfileUpdate();

      if (_adColony.doSetup) {
        _gradlePropertiesSetup();
      }
    });
  }

  // This is the setup just for AdColony mediation
  // Further info : https://developers.google.com/admob/android/mediation/adcolony
  _gradlePropertiesSetup() async {
    // making code AndroidX compatible which is required by AdColony mediation
    String str1 = 'android.useAndroidX=true';
    String str2 = 'android.enableJetifier=true';
    String data = '';
    if (await File(GRADLE_PROPERTIES_PATH).exists()) {
      data = await File(GRADLE_PROPERTIES_PATH).readAsString();
    } else {
      File(AD_UNIT_ID_PATH).create(recursive: true);
    }

    // Replaceing useAndroidX = true
    data.replaceAll(str1, '');
    // Replacing useAndroidX = false
    data.replaceAll(str1.replaceAll('true', 'false'), '');
    // Replaceing enableJetifier = true

    data.replaceAll(str2, '');
    // Replaceing enableJetifier = false
    data.replaceAll(str2.replaceAll('true', 'false'), '');

    data += '\n$str1';
    data += '\n$str2';

    _saveFile(GRADLE_PROPERTIES_PATH, data);
  }

  // IOS : Function to update the Podfile file (add sdk dependencies)
  _iosPodfileUpdate() async {
    // Reading Podfile contents from file
    String plistData = await File(PODFILE_PATH).readAsString();

    // Reg expression match to find dependency import for google ads
    RegExp google = RegExp(r"(pod)\s*'Google-Mobile-Ads-SDK'");
    String? googleImport = google.firstMatch(plistData)?.group(0);

    // Reg expression match to find dependency import for appLovin ads
    RegExp appLovin = RegExp(r"(pod)\s*'GoogleMobileAdsMediationAppLovin'");
    String? appLovinImport = appLovin.firstMatch(plistData)?.group(0);

    // Reg expression match to find dependency import for Facebook ads
    RegExp facebook = RegExp(r"(pod)\s*'GoogleMobileAdsMediationFacebook'");
    String? facebookImport = facebook.firstMatch(plistData)?.group(0);

    // Reg expression match to find dependency import for AdColony ads
    RegExp adColony = RegExp(r"(pod)\s*'GoogleMobileAdsMediationAdColony'");
    String? adColonyImport = adColony.firstMatch(plistData)?.group(0);

    // Adding google ads dependency import when dependency import doesnt exists for google ads
    if (googleImport == null) {
      plistData += '\n$PODFILE_GOOGLE_IMPORT';
    }
    // Adding appLovin ads dependency import when dependency import doesnt exists for appLovin ads
    if (_appLovin.doSetup && appLovinImport == null) {
      plistData += '\n$PODFILE_APPLOVIN_IMPORT';
    }

    // Adding facebook ads dependency import when dependency import doesnt exists for facebook ads
    if (_facebook.doSetup && facebookImport == null) {
      plistData += '\n$PODFILE_FACEBOOK_IMPORT';
    }

    // Adding adColony ads dependency import when dependency import doesnt exists for AdColony ads
    if (_adColony.doSetup && adColonyImport == null) {
      plistData += '\n$PODFILE_ADCOLONY_IMPORT';
    }
    // Saving the updated Podfile
    await _saveFile(PODFILE_PATH, plistData);
  }

  // IOS : Function to update the info.plist file (adding mediation setup)
  _iosInfoPlistUpdate() async {
    // Reading Info.plist contents from file
    String plistData = await File(PLIST_PATH).readAsString();
    // Creating xml object
    final document = XmlDocument.parse(plistData);
    // Extracting the keys from the Info.plist file which is at <plist><dict>(all keys are here)</dict></plist>
    var keys = document
        .findElements('plist')
        .first
        .findElements('dict')
        .first
        .children;
    // Removing xml elements which are generated due to line breaks (this xml parser is creating xml element as 'XmlText' for line breaks)
    keys.removeWhere((element) => element is XmlText);

    // Flags to know whether the configuration of any of the following already exists in Info.plist
    bool _googleConfigured = false;
    bool _appLovinConfigured = false;

    for (int i = 0; i < keys.length; i++) {
      // Will be true if google is already configured
      if (keys[i].innerText == 'GADApplicationIdentifier') {
        var value = XmlElement(XmlName('string'));
        value.innerText = _google.appIdIOS;
        keys.removeAt(i + 1);
        keys.insert(i + 1, value);
        _googleConfigured = true;
      }
      // Will be true if appLovin is already configured
      if (_appLovin.doSetup && keys[i].innerText == 'AppLovinSdkKey') {
        var value = XmlElement(XmlName('string'));
        value.innerText = _appLovin.sdkKey;
        keys.removeAt(i + 1);
        keys.insert(i + 1, value);
        _appLovinConfigured = true;
      }
    }

    // Will be true when google is not already configured
    if (!_googleConfigured) {
      var key = XmlElement(XmlName('key'));
      key.innerText = 'GADApplicationIdentifier';
      var value = XmlElement(XmlName('string'));
      value.innerText = _google.appIdIOS;
      keys.insert(0, value);
      keys.insert(0, key);
    }
    // Will be true when appLovin is not already configured
    if (_appLovin.doSetup && !_appLovinConfigured) {
      var key = XmlElement(XmlName('key'));
      key.innerText = 'AppLovinSdkKey';

      var value = XmlElement(XmlName('string'));
      value.innerText = _appLovin.sdkKey;
      keys.insert(0, value);
      keys.insert(0, key);
    }

    if (_facebook.doSetup) {
      // Configuring facebook setup keys in info.plist
      var array = XmlElement(XmlName('array'));
      var dict1 = XmlElement(XmlName('dict'));
      var key1 = XmlElement(XmlName('key'));
      var value1 = XmlElement(XmlName('string'));
      value1.innerText = 'v9wttpbfk9.skadnetwork';
      key1.innerText = 'SKAdNetworkIdentifier';
      dict1.children.add(key1);
      dict1.children.add(value1);

      var dict2 = XmlElement(XmlName('dict'));
      var key2 = XmlElement(XmlName('key'));
      var value2 = XmlElement(XmlName('string'));
      value2.innerText = 'n38lu8286q.skadnetwork';
      key2.innerText = 'SKAdNetworkIdentifier';
      dict2.children.add(key2);
      dict2.children.add(value2);

      array.children.add(dict1);
      array.children.add(dict2);

      keys.add(array);
    }

    // Prettifying (formatting) updated Info.plist data
    String updatedPlistData = document.toXmlString(pretty: true, indent: '\t');
    // Saving the updated Info.plist data
    await _saveFile(PLIST_PATH, updatedPlistData);
  }

  // Android : Function to update the AndroidManifest.xml file (adding mediation setup)
  _androidManifestUpdate() async {
    String manifestData = await File(PATH_MANIFEST).readAsString();
    final document = XmlDocument.parse(manifestData);
    List<XmlElement> metadatas = document.children.first
        .findAllElements('application')
        .first
        .findElements('meta-data')
        .toList();
    var application =
        document.children.first.findAllElements('application').first.children;

    bool _googleConfigured = false;
    bool _appLovinConfigured = false;

    metadatas.forEach((element) {
      if (element.attributes[0].value ==
          'com.google.android.gms.ads.APPLICATION_ID') {
        application.remove(element);
        element.attributes[1].value = _google.appIdAndroid;
        application.insert(0, element);
        _googleConfigured = true;
      }
      if (_appLovin.doSetup &&
          element.attributes[0].value == 'applovin.sdk.key') {
        element.attributes[1].value = _appLovin.sdkKey;
        application.remove(element);
        application.insert(0, element);
        _appLovinConfigured = true;
      }
    });

    if (!_googleConfigured) {
      var nameAttr = XmlAttribute(
          XmlName('android:name'), 'com.google.android.gms.ads.APPLICATION_ID');
      var valueAttr =
          XmlAttribute(XmlName('android:value'), '${_google.appIdAndroid}');
      application.insert(
          0, XmlElement(XmlName('meta-data'), [nameAttr, valueAttr]));
    }

    if (_appLovin.doSetup && !_appLovinConfigured) {
      var nameAttr = XmlAttribute(XmlName('android:name'), 'applovin.sdk.key');
      var valueAttr =
          XmlAttribute(XmlName('android:value'), '${_appLovin.sdkKey}');
      application.insert(
          0, XmlElement(XmlName('meta-data'), [nameAttr, valueAttr]));
    }

    String updatedManifestData =
        document.toXmlString(pretty: true, indent: '\t');
    await _saveFile(PATH_MANIFEST, updatedManifestData);
  }

  // Android : Function to update the app level build.gradle file (add sdk dependencies)
  _buildGradleUpdate() async {
    String gradleData = await File(APP_LEVEL_GRADLE).readAsString();
    String dependenciesBlock =
        RegExp(r'(dependencies)\s*.*{').firstMatch(gradleData)!.group(0)!;

    int stack = 0;
    int startIndex = gradleData.indexOf(dependenciesBlock);
    int mainDataLength = gradleData.length;
    int endIndex = -1;
    for (int i = startIndex; i < mainDataLength; i++) {
      if (gradleData[i] == '{') {
        stack++;
      } else if (gradleData[i] == '}') {
        stack--;
        if (stack == 0) {
          endIndex = i + 1;
          break;
        }
      }
    }

    String dependenciesBlockData = gradleData.substring(startIndex, endIndex);

    List<String> dependencies = dependenciesBlockData
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll('dependencies', '')
        .split('\n');
    dependencies.removeWhere((element) => element.trim() == '');
    dependencies =
        _addDependency(dependencies, _google.sdk, _google.sdkVersion);

    if (_appLovin.doSetup) {
      dependencies =
          _addDependency(dependencies, _appLovin.sdk, _appLovin.sdkVersion);
    }
    if (_facebook.doSetup) {
      dependencies =
          _addDependency(dependencies, _facebook.sdk, _facebook.sdkVersion);
    }

    if (_adColony.doSetup) {
      dependencies =
          _addDependency(dependencies, _adColony.sdk, _adColony.sdkVersion);
    }

    var str = dependencies.join('\n');
    String updatedDependenciesBlock = "dependencies {\n$str\n}";

    gradleData =
        gradleData.replaceAll(dependenciesBlockData, updatedDependenciesBlock);
    await File(APP_LEVEL_GRADLE).writeAsString(gradleData);
  }

  // Function to add sdk implementation in build.gradle file
  _addDependency(List<String> dependencies, String depPath, String depVersion) {
    List<String> result = [];
    bool alreadyExists = false;
    dependencies.forEach((dependency) {
      String toAdd = '';
      if (dependency.contains(depPath)) {
        toAdd = "implementation \"$depPath$depVersion\"";
        alreadyExists = true;
      } else {
        toAdd = dependency.trim();
      }
      result.add(toAdd);
    });
    if (!alreadyExists) {
      result.add("implementation \"$depPath$depVersion\"");
    }

    return result;
  }

  _loadObjects(String filePath) async {
    String jsonAsString = await File(filePath).readAsString();
    var decodedJsonFile = json.decode(jsonAsString) as Map<String, dynamic>;
    _appLovin = AppLovin.fromJson(decodedJsonFile['AppLovin']);
    _google = Google.fromJson(decodedJsonFile['Google']);
    _facebook = Facebook.fromJson(decodedJsonFile['Facebook']);
    _adColony = AdColony.fromJson(decodedJsonFile['AdColony']);

    print(_appLovin.toJson());
    print(_google.toJson());
    print(_facebook.toJson());

    // Generating code file for ad unit ids in users lib/ad_unit_ids
    String adUnitIdClass = """import 'dart:io';

class AdUnitId {
  static String banner = Platform.isAndroid ? '' : '';
  static String adManagerBanner = Platform.isAndroid ? '' : '';
  static String interstitial = Platform.isAndroid ? '' : '';
  static String rewarded = Platform.isAndroid ? '' : '';
}

""";

    // Adding banner ad id

    String? exp = RegExp(r'(static)\s*(String)\s*banner\s*=(\s*).*[\;]')
        .firstMatch(adUnitIdClass)
        ?.group(0);
    if (exp != null)
      adUnitIdClass = adUnitIdClass.replaceAll(exp,
          "static String banner = Platform.isAndroid ? '${_google.bannerAndroid}' : '${_google.bannerIOS}';");

    // Adding ad manager banner ad id
    exp = RegExp(r'(static)\s*(String)\s*adManagerBanner\s*=(\s*).*[\;]')
        .firstMatch(adUnitIdClass)
        ?.group(0);
    if (exp != null)
      adUnitIdClass = adUnitIdClass.replaceAll(exp,
          "static String adManagerBanner = Platform.isAndroid ? '${_google.adManagerBannerAndroid}' : '${_google.adManagerBannerIOS}';");

    // Adding interstitial ad id
    exp = RegExp(r'(static)\s*(String)\s*interstitial\s*=(\s*).*[\;]')
        .firstMatch(adUnitIdClass)
        ?.group(0);
    if (exp != null)
      adUnitIdClass = adUnitIdClass.replaceAll(exp,
          "static String interstitial = Platform.isAndroid ? '${_google.interstitialAndroid}' : '${_google.interstitialIOS}';");
    // Adding rewarded ad id

    exp = RegExp(r'(static)\s*(String)\s*rewarded\s*=(\s*).*[\;]')
        .firstMatch(adUnitIdClass)
        ?.group(0);
    if (exp != null)
      adUnitIdClass = adUnitIdClass.replaceAll(exp,
          "static String rewarded = Platform.isAndroid ? '${_google.rewardedAndroid}' : '${_google.rewardedIOS}';");

    File(AD_UNIT_ID_PATH).create(recursive: true);
    await Future.delayed(Duration(seconds: 5)).then((value) {
      _saveFile(AD_UNIT_ID_PATH, adUnitIdClass);
    });
  }

  Future<File> _saveManifestFile(String fileData) async {
    return await File(PATH_MANIFEST).writeAsString(fileData);
  }

  Future<File> _saveFile(String filePath, String data) async {
    return await File(filePath).writeAsString(data);
  }

  _getMainCode() async {
    String mainData = await File(MAIN_PATH).readAsString();

    String mainOpening =
        RegExp(r'(main\(\))\s*.*{').firstMatch(mainData)!.group(0)!;
    int stack = 0;
    int startIndex = mainData.indexOf(mainOpening);
    int mainDataLength = mainData.length;
    int endIndex = -1;
    for (int i = startIndex; i < mainDataLength; i++) {
      if (mainData[i] == '{') {
        stack++;
      } else if (mainData[i] == '}') {
        stack--;
        if (stack == 0) {
          endIndex = i + 1;
          break;
        }
      }
    }
    String mainFunc = mainData.substring(startIndex, endIndex);
    String newMainFunc =
        mainFunc.replaceAll('WidgetsFlutterBinding.ensureInitialized();', '');

    String newMainOpening = mainOpening +
        """\nWidgetsFlutterBinding.ensureInitialized();
  // Initialize the SDK before making an ad request.
  // You can check each adapter's initialization status in the callback.
  MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for \$key: \${value.description}');
    });
  });""";

    newMainFunc = newMainFunc.replaceAll(mainOpening, newMainOpening);
    mainData = mainData.replaceAll(mainFunc, newMainFunc);

    mainData = "import 'package:google_mobile_ads/google_mobile_ads.dart';\n" +
        mainData;
    _saveFile(MAIN_PATH, mainData);
  }
}
