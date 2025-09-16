import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';
import 'package:pintapp/infrastructure/models/add_item_request.dart';

class AddItemHelper {
  final _dio = Dio();

  Future<Map<String, dynamic>?> postAddItem(AddItemRequest request) async {
    try {
      final response = await _dio.post(
        '${EnvironmentConfig.baseUrl}items',
        data: request.toJson(),
      );

      if (response.statusCode! != 200) {
        return response.data as Map<String, dynamic>?;
      } else {
        throw Exception('Error getting the response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Unnexpected error ${e.message}');
    }
  }
}
