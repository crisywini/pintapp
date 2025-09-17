import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';

class GetItemsHelper {
  final _dio = Dio();

  Future<Map<String, dynamic>?> getItemsByCategory(String category) async {
    try {
      final response = await _dio.get(
        "${APIConstants.itemsCategoryServiceUrl}$category",
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>?;
      }
    } on DioException catch (e) {
      print('Dio Exception: ${e.message}');
      rethrow;
    }
  }
}
