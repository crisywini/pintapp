import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../../domain/models/item.dart';
import '../../domain/services/image_composition_service.dart';
import '../../domain/services/storage_service.dart';
import 'local_storage_service.dart';

class LocalImageCompositionService implements ImageCompositionService {
  final StorageService _storageService;
  final Uuid _uuid = const Uuid();

  LocalImageCompositionService(this._storageService);

  @override
  Future<String> createOutfitComposition(
    List<Item> items,
    String outfitName,
  ) async {
    if (items.isEmpty) {
      throw ArgumentError('Cannot create outfit composition from empty items list');
    }

    final images = <img.Image>[];

    for (final item in items) {
      final file = File(item.imagePath);
      print('Checking image file: ${item.imagePath}');
      if (await file.exists()) {
        try {
          final bytes = await file.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            images.add(image);
            print('Successfully loaded image: ${item.imagePath}');
          } else {
            print('Failed to decode image: ${item.imagePath}');
          }
        } catch (e) {
          print('Error reading image file ${item.imagePath}: $e');
        }
      } else {
        print('Image file does not exist: ${item.imagePath}');
      }
    }

    if (images.isEmpty) {
      throw StateError('No valid images found for outfit composition. Checked ${items.length} items.');
    }

    final compositeImage = _createComposition(images, outfitName);

    final fileName = '${_uuid.v4()}_outfit_${DateTime.now().millisecondsSinceEpoch}.png';

    final outfitsDir = await _getOutfitsDirectory();
    final outputPath = path.join(outfitsDir, fileName);

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodePng(compositeImage));

    return outputPath;
  }

  img.Image _createComposition(List<img.Image> images, String outfitName) {
    final width = images.map((img) => img.width).reduce((a, b) => a > b ? a : b);
    final height = images.map((img) => img.height).reduce((a, b) => a + b);

    final composite = img.Image(
      width: width,
      height: height,
    );

    int yOffset = 0;
    for (final image in images) {
      img.compositeImage(
        composite,
        image,
        dstX: 0,
        dstY: yOffset,
      );
      yOffset += image.height;
    }

    return composite;
  }


  Future<String> _getOutfitsDirectory() async {
    if (_storageService is LocalStorageService) {
      return await _storageService.getOutfitsDirectory();
    }
    return await _storageService.getImagesDirectory();
  }
}