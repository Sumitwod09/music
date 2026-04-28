import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<int> getStorageSize() async {
    try {
      final path = await _localPath;
      final directory = Directory(path);
      if (!await directory.exists()) return 0;
      int totalSize = 0;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  Future<void> clearCache() async {
    try {
      final path = await _localPath;
      final cacheDir = Directory('$path/cache');
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
      await cacheDir.create();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
}
