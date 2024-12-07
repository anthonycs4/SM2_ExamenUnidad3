import 'package:mysql1/mysql1.dart';

class EstadisticasRepository {
  final ConnectionSettings _settings;

  EstadisticasRepository({required ConnectionSettings settings})
      : _settings = settings;

  Future<Map<String, dynamic>> obtenerEstadisticasNegocio(int idNegocio) async {
    final conn = await MySqlConnection.connect(_settings);

    try {
      final result = await conn.query(
          'SELECT visitas_totales, contactos, visitas_dia, visitas_noche FROM estadisticas WHERE id_negocio = ?',
          [idNegocio]);

      if (result.isEmpty) {
        throw Exception('No se encontraron estadísticas para este negocio.');
      }

      final row = result.first;
      return {
        'visitas_totales': row['visitas_totales'],
        'contactos': row['contactos'],
        'visitas_dia': row['visitas_dia'],
        'visitas_noche': row['visitas_noche'],
      };
    } finally {
      await conn.close();
    }
  }
}
