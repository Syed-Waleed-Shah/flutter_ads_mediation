import 'dart:io';

import 'package:flutter_ads_mediation/global/data/path_data.dart';
import 'package:flutter_ads_mediation/global/utils/file_utils.dart';

class AndroidRenameSteps {
  final String newPackageName;
  String? oldPackageName;

  AndroidRenameSteps(this.newPackageName);

  Future<void> process() async {
    if (!await File(PATH_APP_LEVEL_GRADLE).exists()) {
      print(
          'ERROR:: build.gradle file not found, Check if you have a correct android directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents = await readFileAsString(PATH_APP_LEVEL_GRADLE);

    RegExp reg =
        RegExp('applicationId "(.*)"', caseSensitive: true, multiLine: false);

    String? name = reg.firstMatch(contents!)!.group(1);
    oldPackageName = name;

    print("Old Package Name: $oldPackageName");

    print('Updating build.gradle File');
    await _replace(PATH_APP_LEVEL_GRADLE);

    print('Updating Main Manifest file');
    await _replace(PATH_MANIFEST);

    print('Updating Debug Manifest file');
    await _replace(PATH_MANIFEST_DEBUG);

    print('Updating Profile Manifest file');
    await _replace(PATH_MANIFEST_PROFILE);

    await updateMainActivity();
  }

  Future<void> updateMainActivity() async {
    String _oldPackagePath = oldPackageName!.replaceAll('.', '/');
    String _newPackagePath = newPackageName.replaceAll('.', '/');

    String _javaPath =
        PATH_ACTIVITY + 'java/$_oldPackagePath/MainActivity.java';
    String _newJavaPath =
        PATH_ACTIVITY + 'java/$_newPackagePath/MainActivity.java';

    String _kotlinPath =
        PATH_ACTIVITY + 'kotlin/$_oldPackagePath/MainActivity.kt';
    String _newKotlinPath =
        PATH_ACTIVITY + 'kotlin/$_newPackagePath/MainActivity.kt';

    if (await File(_javaPath).exists()) {
      print('Project is using Java');
      print('Updating MainActivity.java');
      await _replace(_javaPath);

      print('Creating New Directory Structure');
      await Directory(PATH_ACTIVITY + 'java/$_newPackagePath')
          .create(recursive: true);
      await File(_javaPath).rename(_newJavaPath);

      print('Deleting old directories');
      await deleteOldDirectories('java', oldPackageName!, PATH_ACTIVITY);
    } else if (await File(_kotlinPath).exists()) {
      print('Project is using kotlin');
      print('Updating MainActivity.kt');
      await _replace(_kotlinPath);

      print('Creating New Directory Structure');
      await Directory(PATH_ACTIVITY + 'kotlin/$_newPackagePath')
          .create(recursive: true);
      await File(_kotlinPath).rename(_newKotlinPath);

      print('Deleting old directories');
      await deleteOldDirectories('kotlin', oldPackageName!, PATH_ACTIVITY);
    } else {
      print(
          'ERROR:: Unknown Directory structure, both java & kotlin files not found.');
    }
  }

  Future<void> _replace(String path) async {
    await replaceInFile(path, oldPackageName, newPackageName);
  }
}
