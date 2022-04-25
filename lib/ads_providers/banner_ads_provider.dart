import 'package:flutter/foundation.dart';
import 'package:flutter_ads_mediation/ads_providers/test_ad_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsProvider {
  BannerAd? _ad;
  bool _loaded = false;
  String bannerAdId;

  int retries = 0;

  final List<String>? keywords;
  final String? contentUrl;
  final List<String>? neighboringContentUrls;
  final bool? nonPersonalizedAds;
  final int? httpTimeoutMillis;
  final LocationParams? location;
  final String? mediationExtrasIdentifier;
  final Map<String, String>? extras;
  void Function(Ad)? onAdLoaded;
  void Function(Ad, LoadAdError)? onAdFailedToLoad;
  void Function(Ad)? onAdOpened;
  void Function(Ad)? onAdClosed;

  get available {
    return _loaded == true && _ad != null;
  }

  BannerAd? get ad => _ad;

  BannerAdsProvider({
    required this.bannerAdId,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdClosed,
    this.onAdOpened,
    this.keywords,
    this.contentUrl,
    this.neighboringContentUrls,
    this.nonPersonalizedAds = true,
    this.httpTimeoutMillis,
    this.location,
    this.mediationExtrasIdentifier,
    this.extras,
  }) {
    _initialize();
  }

  void _initialize() {
    AdRequest request = AdRequest(
      keywords: keywords,
      contentUrl: contentUrl,
      nonPersonalizedAds: nonPersonalizedAds,
      extras: extras,
      httpTimeoutMillis: httpTimeoutMillis,
      location: location,
      mediationExtrasIdentifier: mediationExtrasIdentifier,
      neighboringContentUrls: neighboringContentUrls,
    );
    _loaded = false;
    _ad = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdId.isEmpty
          ? TestAdsIds.testAdUnitIdBanner
          : kReleaseMode
              ? bannerAdId
              : TestAdsIds.testAdUnitIdBanner,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded ??
            (Ad ad) {
              print('$BannerAd loaded.');
              _loaded = true;
            },
        onAdFailedToLoad: onAdFailedToLoad ??
            (Ad ad, LoadAdError error) {
              print('$BannerAd failedToLoad: $error');
              ad.dispose();
            },
        onAdOpened: onAdOpened ?? (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: onAdClosed ?? (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
      request: request,
    )..load();
  }

  void retry() {
    retries++;
    _initialize();
  }

  void dispose() {
    _ad?.dispose();
  }
}
