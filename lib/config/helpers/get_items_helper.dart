import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';

class GetItemsHelper {
  final _dio = Dio();

  Future<Map<String, dynamic>> getAllItems() async {
    try {
      final response = await _dio.get(
        "${APIConstants.baseUrl}${APIConstants.itemServiceUrl}",
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return {'success': false, 'message': 'Failed to fetch items'};
    } on DioException catch (e) {
      print('Dio Exception: ${e.message}');
      return {'success': false, 'message': 'Network error: ${e.message}'};
    } catch (e) {
      print('Unexpected error: $e');
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }

  Future<dynamic> getItemsByCategory(String category) async {
    try {
      final response = await _dio.get(
        "${APIConstants.baseUrl}${APIConstants.itemsCategoryServiceUrl}$category",
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return {'success': false, 'message': 'No items found for category: $category'};
    } on DioException catch (e) {
      print('Dio Exception: ${e.message}');
      return {'success': false, 'message': 'Network error: ${e.message}'};
    } catch (e) {
      print('Unexpected error: $e');
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }
}
