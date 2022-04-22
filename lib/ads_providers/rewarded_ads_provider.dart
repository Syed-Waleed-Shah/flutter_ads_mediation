import 'package:flutter/foundation.dart';
import 'package:flutter_ads_mediation/ads_providers/test_ad_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdsProvider {
  RewardedAd? _ad;
  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  final String rewardedAdId;
  int retries = 0;
  bool _loaded = false;
  final List<String>? keywords;
  final String? contentUrl;
  final List<String>? neighboringContentUrls;
  final bool? nonPersonalizedAds;
  final int? httpTimeoutMillis;
  final LocationParams? location;
  final String? mediationExtrasIdentifier;
  final Map<String, String>? extras;
  final void Function(AdWithoutView, RewardItem)? onUserEarnedReward;

  get available {
    return _loaded == true && _ad != null;
  }

  RewardedAdsProvider({
    required this.rewardedAdId,
    this.keywords,
    this.contentUrl,
    this.neighboringContentUrls,
    this.nonPersonalizedAds,
    this.httpTimeoutMillis,
    this.location,
    this.mediationExtrasIdentifier,
    this.extras,
    this.onUserEarnedReward,
  }) {
    _initialize();
  }

  void _initialize() {
    _createRewardedAd();
  }

  Future<void> show() async {
    if (_ad == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );
    _ad!.show(onUserEarnedReward: onUserEarnedReward ?? (ad, reward) {});
    _ad = null;
  }

  void _createRewardedAd() {
    if (rewardedAdId.isEmpty) {
      print('RewardedAdId: $rewardedAdId');
    }
    _loaded = false;
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

    RewardedAd.load(
      adUnitId: rewardedAdId.isEmpty
          ? TestAdsIds.testAdUnitIdRewarded
          : kReleaseMode
              ? rewardedAdId
              : TestAdsIds.testAdUnitIdRewarded,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _loaded = true;
          _ad = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          var adId = rewardedAdId.isEmpty
              ? TestAdsIds.testAdUnitIdRewarded
              : rewardedAdId;
          print('RewardedAd failed to load: $error');
          print('RewardedAd Id: $adId');
          print('RewardedAd attempts : $_numRewardedLoadAttempts');
          _ad = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        },
      ),
    );
  }

  void retry() {
    retries++;
    _initialize();
  }

  void dispose() {
    _ad?.dispose();
  }
}
