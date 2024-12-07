// import '../sources/remote/remote_api.dart';
// import '../models/dni_model.dart';

// class DniRepository {
//   final RemoteApi _api = RemoteApi();

//   Future<DniModel> getDni(String dni) async {
//     if (!RegExp(r'^[0-9]{8}$').hasMatch(dni)) {
//       throw Exception('DNI no válido');
//     }
//     return await _api.fetchDni(dni);
//   }
// }
