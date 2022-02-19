# Ads Mediation Setup Plugin (Flutter)
Performs all ad mediation setup and provide all necessary code to integrate ads in the app

------------



## What It does? 
- [x] Update AndroidManifest.xml files for release, debug & profile
- [x] Update build.gradle file
- [x] Update Info.plist file
- [x] Update Podfile file
- [x] Update main.dart file
- [x] Creates lib/ad_unit_ids/ad_unit_id.dart file

------------


## How To Use
Just run following command on your flutter project
```bash
flutter pub run flutter_ads_mediation:main <path/to/setup.json> 
```

------------



## Prerequisit
**min kotlin version required  1.4.32 (if app is using kotlin)** <br>
goto your android/build.gradle file, within the buildscript block replace the kotlin version with 1.4.32 at ext.kotlin_version.

*file : android/build.gradle*
```groovy
    buildscript {
        ext.kotlin_version = '1.4.32'
    }
```

**multiDexEnabled true and minSdkVersion 19** <br>
goto your android/app/build.gradle file within defaultConfig block add/replace these two lines.

*file : android/app/build.gradle*
```groovy
    android {
        defaultConfig {   
            minSdkVersion 19   
            multiDexEnabled true
        }
    }

```