import 'dart:convert';
import 'package:http/http.dart' as http;

class CotizacionRepository {
  final String apiKey;

  CotizacionRepository({required this.apiKey});

  Future<List<Map<String, dynamic>>> generarCotizacion(Map<String, dynamic> parametros) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final body = {
      "model": "gpt-4",
      "messages": [
        {
          "role": "system",
          "content": "Eres un asistente turístico que genera planes de viaje personalizados."
        },
        {
          "role": "user",
          "content": _crearPrompt(parametros),
        }
      ],
      "temperature": 0.7,
      "max_tokens": 1000,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    };

    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _procesarRespuestaGPT(data['choices'][0]['message']['content']);
    } else {
      throw Exception('Error al generar cotización: ${response.body}');
    }
  }

  String _crearPrompt(Map<String, dynamic> parametros) {
  return """
    Basándome en los siguientes datos ingresados por el usuario:
    - Tiempo de viaje: ${parametros['tiempo']} días
    - Número de personas: ${parametros['personas']}
    - Motivo del viaje: ${parametros['motivo']}
    - Presupuesto disponible: S/ ${parametros['presupuesto']}

    Genera una lista JSON con 3 planes de viaje, cada uno con:
    - Nombre del plan.
    - Itinerario detallado (día por día).
    - Costos desglosados (alojamiento, comida, actividades).
    - Total del gasto.

    Devuelve únicamente el JSON como una lista sin ningún texto adicional.
    """;
}


  List<Map<String, dynamic>> _procesarRespuestaGPT(String respuesta) {
  try {
    final decoded = jsonDecode(respuesta);

    // Verifica si la respuesta es un objeto o una lista
    if (decoded is Map<String, dynamic>) {
      return [decoded]; // Convierte el objeto en una lista con un solo elemento
    } else if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      throw Exception('El formato de la respuesta no es válido.');
    }
  } catch (e) {
    throw Exception('Error al procesar la respuesta: $e');
  }
}

}
