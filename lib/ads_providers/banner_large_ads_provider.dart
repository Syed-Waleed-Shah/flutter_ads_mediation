import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerBannerProvider {
  AdManagerBannerAd? _adManagerBannerAd;
  bool _adManagerBannerAdIsLoaded = false;
  final AdSize adSize;
  final String adManagerBannerAdId;

  get available {
    return _adManagerBannerAdIsLoaded == true && _adManagerBannerAd != null;
  }

  AdManagerBannerAd? get ad => _adManagerBannerAd;

  AdManagerBannerProvider(
      {required this.adSize, required this.adManagerBannerAdId}) {
    _initialize();
  }

  void _initialize() {
    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: adManagerBannerAdId.isEmpty
          ? '/6499/example/banner'
          : kReleaseMode
              ? adManagerBannerAdId
              : '/6499/example/banner',
      request: AdManagerAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[adSize],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$AdManagerBannerAd loaded.');
          _adManagerBannerAdIsLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$AdManagerBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$AdManagerBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$AdManagerBannerAd onAdClosed.'),
      ),
    )..load();
  }

  void dispose() {
    _adManagerBannerAd?.dispose();
  }
}
