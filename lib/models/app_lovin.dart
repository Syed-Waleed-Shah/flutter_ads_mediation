class AppLovin {
  late bool doSetup;
  late String sdkVersion;
  late String sdkKey;
  final String sdk = 'com.google.ads.mediation:applovin:';

  AppLovin(
      {required this.doSetup, required this.sdkVersion, required this.sdkKey});

  AppLovin.fromJson(Map<String, dynamic> json) {
    this.doSetup = json['doSetup'];
    this.sdkVersion = json['sdk_version'];
    this.sdkKey = json['sdk_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doSetup'] = this.doSetup;
    data['sdk_version'] = this.sdkVersion;
    data['sdk_key'] = this.sdkKey;
    return data;
  }
}
