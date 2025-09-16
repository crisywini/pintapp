import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';
import 'dart:convert';

import 'package:pintapp/infrastructure/models/add_item_request.dart';

class AddItemHelper {
  final _dio = Dio();

  Future<Map<String, dynamic>?> postAddItem(AddItemRequest request) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          request.imagePath,
          filename: request.imagePath.split('/').last,
          contentType: DioMediaType('image', 'jpeg'), // o 'png', 'webp', etc.
        ),
        'item': jsonEncode(request.toJson()),
      });

      final response = await _dio.post(
        '${EnvironmentConfig.baseUrl}items',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      print('Call made for the backend');
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>?;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
