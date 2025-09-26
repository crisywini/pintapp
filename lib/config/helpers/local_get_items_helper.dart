import '../../services/service_locator.dart';

class LocalGetItemsHelper {
  final _itemService = ServiceLocator().itemService;

  Future<Map<String, dynamic>> getAllItems() async {
    try {
      final result = await _itemService.getAllItems();
      if (result['success'] == true) {
        return result;
      }
      return {'success': false, 'message': result['message'] ?? 'Failed to fetch items'};
    } catch (e) {
      print('Local fetch error: $e');
      return {'success': false, 'message': 'Local error: $e'};
    }
  }

  Future<dynamic> getItemsByCategory(String category) async {
    try {
      final result = await _itemService.getItemsByCategory(category);
      if (result['success'] == true) {
        return result;
      }
      return {'success': false, 'message': result['message'] ?? 'No items found for category: $category'};
    } catch (e) {
      print('Local fetch error: $e');
      return {'success': false, 'message': 'Local error: $e'};
    }
  }
}