import 'package:example/ad_unit_ids/ad_unit_id.dart';
import 'package:flutter_ads_mediation/ads_providers/banner_ads_provider.dart';
import 'package:flutter_ads_mediation/ads_providers/interstitial_ads_provider.dart';
import 'package:flutter_ads_mediation/ads_providers/rewarded_ads_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the SDK before making an ad request.
  // You can check each adapter's initialization status in the callback.
  MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ads Mediation Example App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Ads Mediation Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Defining interstitial ad
  late InterstitialAdsProvider interstitial;

  // Defining rewarded ad
  late RewardedAdsProvider rewarded;

  // Defining banner ad
  late BannerAdsProvider banner;

  @override
  void initState() {
    super.initState();
    // Creating and loading interstitial ad
    interstitial =
        InterstitialAdsProvider(interstitialAdId: AdUnitId.interstitial);

    // Creating and loading rewarded ad
    rewarded = RewardedAdsProvider(rewardedAdId: AdUnitId.rewarded);

    // Creating and loading banner ad
    banner = BannerAdsProvider(bannerAdId: AdUnitId.banner);
  }

  // Method to show interstitial ad
  void showInterstitialAd() {
    if (interstitial.available) {
      interstitial.show();
    }
  }

  // Method to show rewarded ad
  void showRewardedAd() {
    if (rewarded.available) {
      rewarded.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          String item = (index++).toString();
          if (index == 6) {
            return SizedBox(
              height: banner.ad?.size.height.toDouble(),
              width: banner.ad?.size.width.toDouble(),
              child: AdWidget(
                ad: banner.ad!,
              ),
            );
          }
          return ListTile(
            leading: CircleAvatar(child: Text(item)),
            title: Text('List Item $item'),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showInterstitialAd();
            },
            child: const Text('Show Interstitial'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              showRewardedAd();
            },
            child: const Text('Show Rewarded'),
          ),
        ],
      ),
    );
  }
}
