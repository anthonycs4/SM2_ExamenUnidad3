import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKeyDNI = '2bcd4774abe032396d27217c9bc7a4b27245a5eb905b82860d81db395a6e8243';
  final String apiKeyRUC = 'apis-token-11816.sfENSZlJa8p6QmUfDS01tufR4wkqMgPm';

  /// Consulta DNI y devuelve nombres y apellidos
  Future<Map<String, dynamic>> fetchDNI(String dni) async {
    final url = Uri.parse('https://apiperu.dev/api/dni');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKeyDNI',
      },
      body: jsonEncode({'dni': dni}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return {
          'nombres': data['data']['nombres'] ?? '',
          'apellido_paterno': data['data']['apellido_paterno'] ?? '',
          'apellido_materno': data['data']['apellido_materno'] ?? '',
        };
      } else {
        throw Exception('Error en la consulta DNI: ${data['message']}');
      }
    } else {
      throw Exception('Error al consultar DNI: ${response.reasonPhrase}');
    }
  }

  /// Consulta RUC extendido y devuelve el estado
  Future<Map<String, dynamic>> fetchRUC(String ruc) async {
    final url = Uri.parse('https://api.apis.net.pe/v2/sunat/ruc/full?numero=$ruc');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKeyRUC',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['estado'] != null) {
        return {
          'estado': data['estado'],
          'razonSocial': data['razonSocial'],
        };
      } else {
        throw Exception('No se encontró información para este RUC.');
      }
    } else {
      throw Exception('Error al consultar RUC: ${response.reasonPhrase}');
    }
  }
}
