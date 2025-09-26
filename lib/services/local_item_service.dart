import '../domain/models/item.dart';
import '../domain/repositories/item_repository.dart';

class LocalItemService {
  final ItemRepository _itemRepository;

  LocalItemService(this._itemRepository);

  Future<Map<String, dynamic>> getAllItems() async {
    try {
      final items = await _itemRepository.getAllItems();
      return {
        'success': true,
        'items': items.map((item) => item.toJson()).toList(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to fetch items: $e',
      };
    }
  }

  Future<dynamic> getItemsByCategory(String category) async {
    try {
      final items = await _itemRepository.getItemsByCategory(category);
      return {
        'success': true,
        'items': items.map((item) => item.toJson()).toList(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to fetch items for category $category: $e',
      };
    }
  }

  Future<Map<String, dynamic>?> saveItem({
    required String name,
    required String category,
    required String imagePath,
    String? color,
    String? style,
    String? brand,
    String? season,
  }) async {
    try {
      final item = Item(
        id: '',
        name: name,
        category: category,
        imagePath: imagePath,
        createdAt: DateTime.now(),
        color: color,
        style: style,
        brand: brand,
        season: season,
      );

      final savedItem = await _itemRepository.saveItem(item);
      return {
        'success': true,
        'item': savedItem.toJson(),
      };
    } catch (e) {
      print('Error saving item: $e');
      return {
        'success': false,
        'message': 'Failed to save item: $e',
      };
    }
  }

  Future<void> deleteItem(String id) async {
    await _itemRepository.deleteItem(id);
  }
}