const String BANNER_AD_REGEX_STRING =
    r'(static)\s*(String)\s*banner\s*=(\s*).*[\;]';
const String AD_MANAGER_BANNER_ID_REGEX_STRING =
    r'(static)\s*(String)\s*adManagerBanner\s*=(\s*).*[\;]';
const String INTERSTITIAL_AD_REGEX_STRING =
    r'(static)\s*(String)\s*interstitial\s*=(\s*).*[\;]';
const String REWARDED_AD_REGEX_STRING =
    r'(static)\s*(String)\s*rewarded\s*=(\s*).*[\;]';

//Finding imports
const String CHECK_GOOGLE_MOBILE_AD_SDK_REGEX_STRING =
    r"(pod)\s*'Google-Mobile-Ads-SDK'";
const String CHECK_APPLOVIN_SDK_REGEX_STRING =
    r"(pod)\s*'GoogleMobileAdsMediationAppLovin'";
const String CHECK_FACEBOOK_SDK_REGEX_STRING =
    r"(pod)\s*'GoogleMobileAdsMediationFacebook'";
const String CHECK_ADCOLONY_SDK_REGEX_STRING =
    r"(pod)\s*'GoogleMobileAdsMediationAdColony'";
