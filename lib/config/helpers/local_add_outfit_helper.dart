import '../../services/service_locator.dart';

class LocalAddOutfitHelper {
  final _outfitService = ServiceLocator().outfitService;

  Future<Map<String, dynamic>?> postAddOutfit({
    required String name,
    required String category,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      print('Saving outfit locally');

      final result = await _outfitService.saveOutfit(
        name: name,
        category: category,
        items: items,
      );

      print('Local outfit save completed');
      print('Success: ${result?['success']}');

      if (result != null && result['success'] == true) {
        return result;
      } else {
        throw Exception(result?['message'] ?? 'Failed to save outfit locally');
      }
    } catch (e) {
      print('Local outfit save error: $e');
      rethrow;
    }
  }
}