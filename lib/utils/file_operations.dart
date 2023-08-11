import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileOperations {
  static Future<String> saveImagePermanently(String temporaryPath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/${DateTime.now()}.png';
    final File newImage = await File(temporaryPath).copy(newPath);
    return newImage.path;
  }

  static Future<void> deleteFile(String path) async {
    final File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<String> readFile(String path) async {
    final File file = File(path);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }

  static Future<List<FileSystemEntity>> listFiles() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.listSync();
  }

  static Future<int> getFileSize(String path) async {
    final File file = File(path);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }
}
