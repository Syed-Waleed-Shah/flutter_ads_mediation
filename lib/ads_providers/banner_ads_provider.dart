import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsProvider {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  String bannerAdId;

  get available {
    return _bannerAdIsLoaded == true && _bannerAd != null;
  }

  BannerAd? get ad => _bannerAd;

  BannerAdsProvider({required this.bannerAdId}) {
    _initialize();
  }

  void _initialize() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerAdId.isEmpty
            ? BannerAd.testAdUnitId
            : kReleaseMode
                ? bannerAdId
                : BannerAd.testAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            _bannerAdIsLoaded = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        ),
        request: AdRequest())
      ..load();
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}
