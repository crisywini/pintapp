import 'package:uuid/uuid.dart';
import '../../domain/models/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../../domain/services/storage_service.dart';
import '../database/database_helper.dart';

class LocalItemRepository implements ItemRepository {
  final DatabaseHelper _databaseHelper;

  final StorageService _storageService;
  final Uuid _uuid = const Uuid();

  LocalItemRepository(this._databaseHelper, this._storageService);

  @override
  Future<List<Item>> getAllItems() async {
    return await _databaseHelper.getAllItems();
  }

  @override
  Future<List<Item>> getItemsByCategory(String category) async {
    return await _databaseHelper.getItemsByCategory(category);
  }

  @override
  Future<Item> saveItem(Item item) async {
    final id = item.id.isEmpty ? _uuid.v4() : item.id;
    final fileName = '${id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedImagePath = await _storageService.saveImage(
      item.imagePath,
      fileName,
    );

    final itemToSave = Item(
      id: id,
      name: item.name,
      category: item.category,
      imagePath: savedImagePath,
      createdAt: item.createdAt,
      color: item.color,
      style: item.style,
      brand: item.brand,
      season: item.season,
    );

    await _databaseHelper.insertItem(itemToSave);
    return itemToSave;
  }

  @override
  Future<void> deleteItem(String id) async {
    final item = await getItemById(id);
    if (item != null) {
      await _storageService.deleteImage(item.imagePath);
      await _databaseHelper.deleteItem(id);
    }
  }

  @override
  Future<Item?> getItemById(String id) async {
    return await _databaseHelper.getItemById(id);
  }
}
