library ads_mediation_setup;

import './android_rename_steps.dart';
import 'android_setup.dart';

class AdsMediationSetup {
  static void start(List<String> arguments) {
    if (arguments.isEmpty) {
      print('Setup json file path is missing in paraments. please try again.');
    } else if (arguments.length > 1) {
      print(
          'Wrong arguments, this package accepts only setup json file path as parameter');
    } else {
      AndroidSetup(arguments[0]).process();
    }
  }
}
