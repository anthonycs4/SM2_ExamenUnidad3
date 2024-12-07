// import 'package:dio/dio.dart';
// import '../../models/dni_model.dart';

// class RemoteApi {
//   final Dio _dio = Dio(BaseOptions(baseUrl: 'https://apiperu.dev/api'));

//   RemoteApi() {
//     _dio.options.headers = {
//       'Authorization': 'Bearer 2bcd4774abe032396d27217c9bc7a4b27245a5eb905b82860d81db395a6e8243',
//       'Content-Type': 'application/json',
//     };
//   }

//   Future<DniModel> fetchDni(String dni) async {
//     final response = await _dio.post('/dni', data: {'dni': dni});
//     return DniModel.fromJson(response.data);
//   }
// }
