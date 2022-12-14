import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CustomDeviceDirectory {
  Future<Directory> getEpisodesDownloadsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    Directory newDirectory = Directory('${appDir.path}/episodesDownloads');

    if (await newDirectory.exists() == false) {
      return newDirectory.create(recursive: true);
    }

    return newDirectory;
  }

  Future<File?> getFile({required String path}) async {
    File file = File(path);

    // Return the file if it exists.
    if (await file.exists()) {
      return file;
    }

    // return null if the file does not exists.
    return null;
  }
}
