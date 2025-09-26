import '../domain/models/outfit.dart';
import '../domain/models/item.dart';
import '../domain/repositories/outfit_repository.dart';
import '../domain/repositories/item_repository.dart';

class LocalOutfitService {
  final OutfitRepository _outfitRepository;
  final ItemRepository _itemRepository;

  LocalOutfitService(this._outfitRepository, this._itemRepository);

  Future<dynamic> getAllOutfits() async {
    try {
      final outfits = await _outfitRepository.getAllOutfits();
      return {
        'success': true,
        'outfits': outfits.map((outfit) => _outfitToBackendFormat(outfit)).toList(),
      };
    } catch (e) {
      print('Error fetching outfits: $e');
      return {
        'success': false,
        'message': 'Failed to fetch outfits: $e',
      };
    }
  }

  Future<Map<String, dynamic>?> saveOutfit({
    required String name,
    required String category,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final outfitItems = <Item>[];

      for (final itemMap in items) {
        final itemId = itemMap['id'] ?? itemMap['_id'];
        if (itemId != null) {
          final item = await _itemRepository.getItemById(itemId);
          if (item != null) {
            outfitItems.add(item);
          }
        }
      }

      if (outfitItems.isEmpty) {
        return {
          'success': false,
          'message': 'No valid items found for outfit',
        };
      }

      final outfit = Outfit(
        id: '',
        name: name,
        category: category,
        items: outfitItems,
        createdAt: DateTime.now(),
      );

      final savedOutfit = await _outfitRepository.saveOutfit(outfit);
      return {
        'success': true,
        'outfit': _outfitToBackendFormat(savedOutfit),
      };
    } catch (e) {
      print('Error saving outfit: $e');
      return {
        'success': false,
        'message': 'Failed to save outfit: $e',
      };
    }
  }

  Future<void> deleteOutfit(String id) async {
    await _outfitRepository.deleteOutfit(id);
  }

  Map<String, dynamic> _outfitToBackendFormat(Outfit outfit) {
    return {
      'id': outfit.id,
      '_id': outfit.id,
      'name': outfit.name,
      'category': outfit.category,
      'items': outfit.items.map((item) => {
        'id': item.id,
        '_id': item.id,
        'name': item.name,
        'category': item.category,
        'color': item.color,
        'style': item.style,
        'brand': item.brand,
        'season': item.season,
        'imagePath': item.imagePath,
        'image_url': item.imagePath,
      }).toList(),
      'image_url': outfit.compositeImagePath ?? '',
      'createdAt': outfit.createdAt.toIso8601String(),
    };
  }
}