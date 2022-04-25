import 'dart:io';

class AdUnitId {
  static String banner = Platform.isAndroid ? '' : '';
  static String adManagerBanner = Platform.isAndroid ? '' : '';
  static String interstitial = Platform.isAndroid ? '' : '';
  static String rewarded = Platform.isAndroid ? '' : '';
}
