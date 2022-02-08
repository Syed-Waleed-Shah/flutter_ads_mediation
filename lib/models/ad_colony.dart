class AdColony {
  late bool doSetup;
  late String sdkVersion;
  final String sdk = 'com.google.ads.mediation:adcolony:';

  AdColony({required this.doSetup, required this.sdkVersion});

  AdColony.fromJson(Map<String, dynamic> json) {
    this.doSetup = json['doSetup'];
    this.sdkVersion = json['sdk_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doSetup'] = this.doSetup;
    data['sdk_version'] = this.sdkVersion;
    return data;
  }
}
