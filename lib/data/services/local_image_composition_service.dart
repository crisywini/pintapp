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

    final itemsWithImages = <(Item, img.Image)>[];

    for (final item in items) {
      final file = File(item.imagePath);
      print('Checking image file: ${item.imagePath}');
      if (await file.exists()) {
        try {
          final bytes = await file.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            itemsWithImages.add((item, image));
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

    if (itemsWithImages.isEmpty) {
      throw StateError('No valid images found for outfit composition. Checked ${items.length} items.');
    }

    final compositeImage = _createComposition(itemsWithImages, outfitName);

    final fileName = '${_uuid.v4()}_outfit_${DateTime.now().millisecondsSinceEpoch}.png';

    final outfitsDir = await _getOutfitsDirectory();
    final outputPath = path.join(outfitsDir, fileName);

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodePng(compositeImage));

    return outputPath;
  }

  img.Image _createComposition(List<(Item, img.Image)> itemsWithImages, String outfitName) {
    // Sort items in order: shirts, pants, shoes for proper layering
    final sortedItems = List<(Item, img.Image)>.from(itemsWithImages);
    sortedItems.sort((a, b) {
      final categoryOrder = {'shirts': 0, 'pants': 1, 'shoes': 2};
      final aOrder = categoryOrder[a.$1.category] ?? 3;
      final bOrder = categoryOrder[b.$1.category] ?? 3;
      return aOrder.compareTo(bOrder);
    });

    // Define scale factors for different categories
    final scaleFactors = {
      'shirts': 1.2,    // Make shirts bigger
      'pants': 1.3,     // Make pants bigger
      'shoes': 0.7,     // Make shoes smaller
    };

    // Calculate scaled dimensions
    final scaledImages = <img.Image>[];
    int maxWidth = 0;
    int totalHeight = 0;

    for (final (item, image) in sortedItems) {
      final scaleFactor = scaleFactors[item.category] ?? 1.0;
      final scaledWidth = (image.width * scaleFactor).round();
      final scaledHeight = (image.height * scaleFactor).round();

      final scaledImage = img.copyResize(
        image,
        width: scaledWidth,
        height: scaledHeight,
        interpolation: img.Interpolation.linear,
      );

      scaledImages.add(scaledImage);
      maxWidth = maxWidth > scaledWidth ? maxWidth : scaledWidth;
      totalHeight += scaledHeight;
    }

    // Create composite image
    final composite = img.Image(
      width: maxWidth,
      height: totalHeight,
    );

    // Fill with white background
    img.fill(composite, color: img.ColorRgb8(255, 255, 255));

    // Composite scaled images vertically, centered horizontally
    int yOffset = 0;
    for (final scaledImage in scaledImages) {
      final xOffset = (maxWidth - scaledImage.width) ~/ 2; // Center horizontally
      img.compositeImage(
        composite,
        scaledImage,
        dstX: xOffset,
        dstY: yOffset,
      );
      yOffset += scaledImage.height;
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