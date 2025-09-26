import '../../infrastructure/models/add_item_request.dart';
import '../../services/service_locator.dart';

class LocalAddItemHelper {
  final _itemService = ServiceLocator().itemService;

  Future<Map<String, dynamic>?> postAddItem(AddItemRequest request) async {
    try {
      print('Saving item locally');

      final result = await _itemService.saveItem(
        name: request.name ?? 'Unnamed Item',
        category: request.category,
        imagePath: request.imagePath,
        color: request.color,
        style: request.style,
        brand: request.brand,
        season: request.season,
      );

      print('Local save completed');
      print('Success: ${result?['success']}');

      if (result != null && result['success'] == true) {
        return result;
      } else {
        throw Exception(result?['message'] ?? 'Failed to save item locally');
      }
    } catch (e) {
      print('Local save error: $e');
      rethrow;
    }
  }
}