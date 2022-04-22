import 'package:flutter/foundation.dart';
import 'package:flutter_ads_mediation/google_ads/test_ad_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdsProvider {
  InterstitialAd? _ad;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  final String interstitialAdId;
  int retries = 0;
  bool _loaded = false;
  final bool? nonPersonalized;
  final List<String>? keywords;
  final LocationParams? location;
  final int? httpTimeoutMillis;
  final String? contentUrl;
  Map<String, String>? extras;
  String? mediationExtrasIdentifier;
  List<String>? neighboringContentUrls;

  get available {
    return _loaded == true && _ad != null;
  }

  InterstitialAdsProvider({
    required this.interstitialAdId,
    this.nonPersonalized,
    this.extras,
    this.keywords,
    this.location,
    this.httpTimeoutMillis,
    this.mediationExtrasIdentifier,
    this.neighboringContentUrls,
    this.contentUrl,
  }) {
    _initialize();
  }

  void _initialize() {
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    _loaded = false;
    AdRequest request = AdRequest(
      keywords: keywords,
      contentUrl: contentUrl,
      nonPersonalizedAds: true,
      extras: extras,
      httpTimeoutMillis: httpTimeoutMillis,
      location: location,
      mediationExtrasIdentifier: mediationExtrasIdentifier,
      neighboringContentUrls: neighboringContentUrls,
    );
    InterstitialAd.load(
      adUnitId: interstitialAdId.isEmpty
          ? TestAdsIds.testAdUnitIdInterstitial
          : kReleaseMode
              ? interstitialAdId
              : TestAdsIds.testAdUnitIdInterstitial,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _loaded = true;
          _ad = ad;
          _numInterstitialLoadAttempts = 0;
          _ad!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _ad = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  Future<void> show() async {
    if (_ad == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );

    _ad!.show();
    _ad = null;
  }

  void retry() {
    retries++;
    _initialize();
  }

  void dispose() {
    _ad?.dispose();
  }
}
