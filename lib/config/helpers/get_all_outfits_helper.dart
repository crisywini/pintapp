import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';

class GetAllOutfitsHelper {
  final _dio = Dio();

  Future<dynamic> getAllOutfits() async {
    try {
      final response = await _dio.get(
        "${APIConstants.baseUrl}${APIConstants.outfitsServiceUrl}",
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return {'success': false, 'message': 'Failed to fetch outfits'};
    } on DioException catch (e) {
      print('Dio Exception: ${e.message}');
      return {'success': false, 'message': 'Network error: ${e.message}'};
    } catch (e) {
      print('Unexpected error: $e');
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }

  Future<dynamic> getAllOutfitsByCategory(String category) async {
    try {
      final response = await _dio.get(
        "${APIConstants.baseUrl}${APIConstants.outfitsServiceUrl}?category=$category",
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return {'success': false, 'message': 'No outfits found for category: $category'};
    } on DioException catch (e) {
      print('Dio Exception: ${e.message}');
      return {'success': false, 'message': 'Network error: ${e.message}'};
    } catch (e) {
      print('Unexpected error: $e');
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }
}