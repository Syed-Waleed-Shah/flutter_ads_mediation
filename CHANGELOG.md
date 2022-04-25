## [1.1.0+2] - (February 19, 2022)

* Published flutter ads mediation package for flutter apps

## [1.2.0] - (April 03, 2022)

* Added example project 
* ensured file access security (package will not throw error when IOS setup is not available)

## [1.3.0] - (April 23, 2022)

* Added AdRequest parameters in all ads providers to give flexibility to users to configure AdRequest as per requirement before loading ad.
* Added retry() function in all ads providers which retries to load ad when ad fails to load.
* Added retires property in all ads providers which keep track of num of times retry() called.
* Added available property in all ads providers which returns true if ad is loaded and ready to serve. 
* Added onAdLoaded, onAdFailedToLoad, onAdOpened and onAdClosed callbacks in all ads providers.
* Added new example project.
  
## [1.3.1] - (April 25, 2022)

* Added missing onAdLoaded callback in BannerAdsProvider
* Added missing callbacks onAdLoaded & onAdFailedToLoad in InterstitialAdsProvider 