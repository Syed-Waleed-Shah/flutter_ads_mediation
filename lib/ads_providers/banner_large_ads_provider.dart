import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerBannerProvider {
  AdManagerBannerAd? _ad;
  bool _loaded = false;
  final AdSize adSize;
  final String adManagerBannerAdId;
  int retries = 0;

  final List<String>? keywords;
  final String? contentUrl;
  final List<String>? neighboringContentUrls;
  final Map<String, String>? customTargeting;
  final Map<String, List<String>>? customTargetingLists;
  final bool? nonPersonalizedAds;
  final int? httpTimeoutMillis;
  final String? publisherProvidedId;
  final LocationParams? location;
  final String? mediationExtrasIdentifier;
  final Map<String, String>? extras;
  void Function(Ad)? onAdLoaded;
  dynamic Function(Ad, LoadAdError)? onAdFailedToLoad;
  void Function(Ad)? onAdOpened;
  void Function(Ad)? onAdClosed;

  get available {
    return _loaded == true && _ad != null;
  }

  AdManagerBannerAd? get ad => _ad;

  AdManagerBannerProvider({
    required this.adSize,
    required this.adManagerBannerAdId,
    this.keywords,
    this.contentUrl,
    this.neighboringContentUrls,
    this.customTargeting,
    this.customTargetingLists,
    this.nonPersonalizedAds,
    this.httpTimeoutMillis,
    this.publisherProvidedId,
    this.location,
    this.mediationExtrasIdentifier,
    this.extras,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdClosed,
    this.onAdOpened,
  }) {
    _initialize();
  }

  void _initialize() {
    AdManagerAdRequest request = AdManagerAdRequest(
      contentUrl: contentUrl,
      customTargeting: customTargeting,
      customTargetingLists: customTargetingLists,
      extras: extras,
      httpTimeoutMillis: httpTimeoutMillis,
      keywords: keywords,
      location: location,
      mediationExtrasIdentifier: mediationExtrasIdentifier,
      neighboringContentUrls: neighboringContentUrls,
      nonPersonalizedAds: nonPersonalizedAds,
      publisherProvidedId: publisherProvidedId,
    );
    _loaded = false;
    _ad = AdManagerBannerAd(
      adUnitId: adManagerBannerAdId.isEmpty
          ? '/6499/example/banner'
          : kReleaseMode
              ? adManagerBannerAdId
              : '/6499/example/banner',
      request: request,
      sizes: <AdSize>[adSize],
      listener: AdManagerBannerAdListener(
        onAdLoaded: onAdLoaded ??
            (Ad ad) {
              print('$AdManagerBannerAd loaded.');
              _loaded = true;
            },
        onAdFailedToLoad: onAdFailedToLoad ??
            (Ad ad, LoadAdError error) {
              print('$AdManagerBannerAd failedToLoad: $error');
              ad.dispose();
            },
        onAdOpened:
            onAdOpened ?? (Ad ad) => print('$AdManagerBannerAd onAdOpened.'),
        onAdClosed:
            onAdClosed ?? (Ad ad) => print('$AdManagerBannerAd onAdClosed.'),
      ),
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
