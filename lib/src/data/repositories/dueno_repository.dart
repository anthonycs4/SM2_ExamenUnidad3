import 'package:http/http.dart' as http;
import 'dart:convert';

class DuenoRepository {
  final String baseUrl; // URL base de la API para RUC y backend
  final String rdsBaseUrl; // URL base del backend que interactúa con RDS
  final String token =
      '2bcd4774abe032396d27217c9bc7a4b27245a5eb905b82860d81db395a6e8243'; // Token de ApisPeruDev

  DuenoRepository({required this.baseUrl, required this.rdsBaseUrl});

  // Método para consultar el RUC
  Future<Map<String, dynamic>> consultarRUC(String ruc) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ruc'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ruc': ruc}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Error al consultar RUC: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  // Método para obtener negocios desde la base de datos RDS
  Future<List<Map<String, dynamic>>> getNegocios(int idDueno) async {
    try {
      final response = await http.get(
        Uri.parse('$rdsBaseUrl/negocios?dueno=$idDueno'),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al obtener negocios');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  // Método para eliminar un negocio
  Future<void> eliminarNegocio(int idNegocio) async {
    try {
      final response = await http.delete(
        Uri.parse('$rdsBaseUrl/negocios/$idNegocio'),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar negocio');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  // Método para crear un negocio
  Future<void> crearNegocio(Map<String, dynamic> negocio) async {
    try {
      final response = await http.post(
        Uri.parse('$rdsBaseUrl/negocios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(negocio),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear negocio');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  // Método para editar un negocio
  Future<void> editarNegocio(int idNegocio, Map<String, dynamic> negocio) async {
    try {
      final response = await http.put(
        Uri.parse('$rdsBaseUrl/negocios/$idNegocio'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(negocio),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al editar negocio');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
