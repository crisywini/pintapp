import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';
import 'package:pintapp/infrastructure/models/add_item_request.dart';

class AddItemHelper {
  final _dio = Dio();

  Future<void> postAddItem(AddItemRequest request) async {
    try {
      final response = await _dio.post(
        EnvironmentConfig.baseUrl,
        data: request.toJson(),
      );

      if (response.statusCode! != 200) {}
    } catch (e) {}
  }
}
