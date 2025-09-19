import 'package:dio/dio.dart';
import 'package:pintapp/config/constants.dart';

class AddOutfitHelper {
  final _dio = Dio();

  Future<Map<String, dynamic>?> postAddOutfit({
    required String name,
    required String category,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final body = {'name': name, 'category': category, 'items': items};

      final response = await _dio.post(
        '${APIConstants.baseUrl}${APIConstants.outfitsServiceUrl}',
        data: body,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Outfit save call made to backend');
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
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
}
