/* import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://tu-api-url.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _dio.post(endpoint, data: data);
    return response.data;
  }
}*/
