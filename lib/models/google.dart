class Google {
  late String appIdIOS;
  late String bannerIOS;
  late String adManagerBannerIOS;
  late String interstitialIOS;
  late String rewardedIOS;
  late String appIdAndroid;
  late String bannerAndroid;
  late String adManagerBannerAndroid;
  late String interstitialAndroid;
  late String rewardedAndroid;
  final String sdk = 'com.google.android.gms:play-services-ads:';
  late String sdkVersion;

  Google({
    required this.appIdIOS,
    required this.sdkVersion,
    required this.bannerIOS,
    required this.adManagerBannerIOS,
    required this.interstitialIOS,
    required this.rewardedIOS,
    required this.appIdAndroid,
    required this.bannerAndroid,
    required this.adManagerBannerAndroid,
    required this.interstitialAndroid,
    required this.rewardedAndroid,
  });

  Google.fromJson(Map<String, dynamic> json) {
    appIdIOS = json['appIdIOS'];
    bannerIOS = json['bannerIOS'];
    adManagerBannerIOS = json['adManagerBannerIOS'];
    interstitialIOS = json['interstitialIOS'];
    rewardedIOS = json['rewardedIOS'];
    appIdAndroid = json['appIdAndroid'];
    bannerAndroid = json['bannerAndroid'];
    adManagerBannerAndroid = json['adManagerBannerAndroid'];
    interstitialAndroid = json['interstitialAndroid'];
    rewardedAndroid = json['rewardedAndroid'];
    sdkVersion = json['sdkVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appIdIOS'] = this.appIdIOS;
    data['bannerIOS'] = this.bannerIOS;
    data['adManagerBannerIOS'] = this.adManagerBannerIOS;
    data['interstitialIOS'] = this.interstitialIOS;
    data['rewardedIOS'] = this.rewardedIOS;
    data['appIdAndroid'] = this.appIdAndroid;
    data['bannerAndroid'] = this.bannerAndroid;
    data['adManagerBannerAndroid'] = this.adManagerBannerAndroid;
    data['interstitialAndroid'] = this.interstitialAndroid;
    data['rewardedAndroid'] = this.rewardedAndroid;
    data['sdkVersion'] = this.sdkVersion;
    return data;
  }
}
