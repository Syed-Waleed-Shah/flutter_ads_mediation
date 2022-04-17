const String MAIN_CODE = """\nWidgetsFlutterBinding.ensureInitialized();
  // Initialize the SDK before making an ad request.
  // You can check each adapter's initialization status in the callback.
  MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for \$key: \${value.description}');
    });
  });""";

const String GOOGLE_MOBILE_AD_IMPORT_CODE =
    "import 'package:google_mobile_ads/google_mobile_ads.dart';\n";

const String AD_UNIT_CALSS_CODE = """import 'dart:io';

class AdUnitId {
  static String banner = Platform.isAndroid ? '' : '';
  static String adManagerBanner = Platform.isAndroid ? '' : '';
  static String interstitial = Platform.isAndroid ? '' : '';
  static String rewarded = Platform.isAndroid ? '' : '';
}

""";
