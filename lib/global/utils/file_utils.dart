import 'dart:io';

Future<void> replaceInFile(String path, oldPackage, newPackage) async {
  String? contents = await readFileAsString(path);
  if (contents == null) {
    print('ERROR:: file at $path not found');
    return;
  }
  contents = contents.replaceAll(oldPackage, newPackage);
  await saveFile(path, contents);
}

Future<String?> readFileAsString(String path) async {
  var file = File(path);
  String? contents;

  if (await file.exists()) {
    contents = await file.readAsString();
  }
  return contents;
}

Future<void> deleteOldDirectories(
    String lang, String oldPackage, String basePath) async {
  var dirList = oldPackage.split('.');
  var reversed = dirList.reversed.toList();

  for (int i = 0; i < reversed.length; i++) {
    String path = '$basePath$lang/' + dirList.join('/');

    if (Directory(path).listSync().toList().isEmpty) {
      Directory(path).deleteSync();
    }
    dirList.removeLast();
  }
}

Future<File> saveFile(String filePath, String data) async {
  return await File(filePath).writeAsString(data);
}

Future<bool> fileExists(String path) async {
  if (!await File(path).exists()) {
    print('ERROR > File Does not exist : ' + path);
    return false;
  }
  return true;
}
