import 'package:uuid/uuid.dart';
import '../../domain/models/outfit.dart';
import '../../domain/repositories/outfit_repository.dart';
import '../../domain/services/storage_service.dart';
import '../../domain/services/image_composition_service.dart';
import '../database/database_helper.dart';

class LocalOutfitRepository implements OutfitRepository {
  final DatabaseHelper _databaseHelper;
  final StorageService _storageService;
  final ImageCompositionService _imageCompositionService;
  final Uuid _uuid = const Uuid();

  LocalOutfitRepository(
    this._databaseHelper,
    this._storageService,
    this._imageCompositionService,
  );

  @override
  Future<List<Outfit>> getAllOutfits() async {
    return await _databaseHelper.getAllOutfits();
  }

  @override
  Future<Outfit> saveOutfit(Outfit outfit) async {
    final id = outfit.id.isEmpty ? _uuid.v4() : outfit.id;

    String? compositeImagePath;
    if (outfit.items.isNotEmpty) {
      try {
        compositeImagePath = await _imageCompositionService.createOutfitComposition(
          outfit.items,
          outfit.name,
        );
      } catch (e) {
        print('Warning: Failed to create composite image for outfit "${outfit.name}": $e');
        // Continue without composite image - outfit can still be saved
        compositeImagePath = null;
      }
    }

    final outfitToSave = Outfit(
      id: id,
      name: outfit.name,
      category: outfit.category,
      items: outfit.items,
      compositeImagePath: compositeImagePath,
      createdAt: outfit.createdAt,
    );

    await _databaseHelper.insertOutfit(outfitToSave);
    return outfitToSave;
  }

  @override
  Future<void> deleteOutfit(String id) async {
    // Get the outfit to delete
    final outfit = await getOutfitById(id);
    if (outfit == null) {
      throw Exception('Outfit with id $id not found');
    }

    print('Deleting outfit: ${outfit.name} (id: $id)');

    // Delete the composite image if it exists
    if (outfit.compositeImagePath != null && outfit.compositeImagePath!.isNotEmpty) {
      try {
        final imageExists = await _storageService.imageExists(outfit.compositeImagePath!);
        if (imageExists) {
          await _storageService.deleteImage(outfit.compositeImagePath!);
          print('Deleted composite image: ${outfit.compositeImagePath}');
        } else {
          print('Composite image not found: ${outfit.compositeImagePath}');
        }
      } catch (e) {
        print('Warning: Failed to delete composite image: $e');
        // Continue with deletion even if image deletion fails
      }
    }

    // Delete from database (this also deletes outfit_items relationships via transaction)
    await _databaseHelper.deleteOutfit(id);
    print('Deleted outfit from database: $id');
  }

  @override
  Future<Outfit?> getOutfitById(String id) async {
    return await _databaseHelper.getOutfitById(id);
  }
}