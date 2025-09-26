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
    final outfit = await getOutfitById(id);
    if (outfit != null && outfit.compositeImagePath != null) {
      await _storageService.deleteImage(outfit.compositeImagePath!);
      await _databaseHelper.deleteOutfit(id);
    }
  }

  @override
  Future<Outfit?> getOutfitById(String id) async {
    return await _databaseHelper.getOutfitById(id);
  }
}