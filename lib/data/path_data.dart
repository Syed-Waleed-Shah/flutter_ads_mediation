const String PATH_MANIFEST = 'android/app/src/main/AndroidManifest.xml';
const String PATH_MANIFEST_DEBUG = 'android/app/src/debug/AndroidManifest.xml';
const String PATH_MANIFEST_PROFILE =
    'android/app/src/profile/AndroidManifest.xml';

const String PATH_ACTIVITY = 'android/app/src/main/';

const String APP_LEVEL_GRADLE = 'android/app/build.gradle';
const String PLIST_PATH = 'ios/Runner/Info.plist';
const String PODFILE_PATH = 'ios/Podfile';
const String AD_UNIT_ID_PATH = 'lib/ad_unit_ids/ad_unit_id.dart';
const String MAIN_PATH = 'lib/main.dart';
const String GRADLE_PROPERTIES_PATH = 'android/gradle.properties';

const String APPLICATION_ID = """\n        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="APPLICATION_ID_HERE"/>""";
const String APPLOVIN_SDK_KEY = """<meta-data
            android:name="applovin.sdk.key"
            android:value="APPLOVIN_SDK_KEY_HERE" />""";

const String PODFILE_GOOGLE_IMPORT = """pod 'Google-Mobile-Ads-SDK'""";
const String PODFILE_APPLOVIN_IMPORT =
    """pod 'GoogleMobileAdsMediationAppLovin'""";

const String PODFILE_FACEBOOK_IMPORT =
    """pod 'GoogleMobileAdsMediationFacebook'""";

const String PODFILE_ADCOLONY_IMPORT =
    """pod 'GoogleMobileAdsMediationAdColony'""";
