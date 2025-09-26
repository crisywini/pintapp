import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../domain/services/storage_service.dart';

class LocalStorageService implements StorageService {
  static const String _imagesFolder = 'pintapp_images';
  static const String _outfitsFolder = 'pintapp_outfits';

  @override
  Future<String> saveImage(String sourcePath, String fileName) async {
    final directory = await getImagesDirectory();
    final targetPath = path.join(directory, fileName);

    final sourceFile = File(sourcePath);
    await sourceFile.copy(targetPath);

    return targetPath;
  }

  @override
  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<String> getImagesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(appDir.path, _imagesFolder));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir.path;
  }

  Future<String> getOutfitsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final outfitsDir = Directory(path.join(appDir.path, _outfitsFolder));

    if (!await outfitsDir.exists()) {
      await outfitsDir.create(recursive: true);
    }

    return outfitsDir.path;
  }

  @override
  Future<bool> imageExists(String imagePath) async {
    final file = File(imagePath);
    return await file.exists();
  }
}