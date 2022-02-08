1) Platform specific setup : https://developers.google.com/admob/flutter/quick-start#platform_specific_setup
android) Update AndroidManifest.xml
<manifest>
    <application>
        <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    <application>
<manifest>

ios) Update your Info.plist
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-################~##########</string>


2) Initialize the Mobile Ads SDK : https://developers.google.com/admob/flutter/quick-start#initialize_the_mobile_ads_sdk


