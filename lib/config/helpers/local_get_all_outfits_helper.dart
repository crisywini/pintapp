import '../../services/service_locator.dart';

class LocalGetAllOutfitsHelper {
  final _outfitService = ServiceLocator().outfitService;

  Future<dynamic> getAllOutfits() async {
    try {
      final result = await _outfitService.getAllOutfits();
      if (result['success'] == true) {
        return result;
      }
      return {'success': false, 'message': result['message'] ?? 'Failed to fetch outfits'};
    } catch (e) {
      print('Local outfits fetch error: $e');
      return {'success': false, 'message': 'Local error: $e'};
    }
  }
}