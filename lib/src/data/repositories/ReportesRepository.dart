import 'package:mysql1/mysql1.dart';

class ReportesRepository {
  final ConnectionSettings _settings;

  ReportesRepository({required ConnectionSettings settings})
      : _settings = settings;

  Future<List<Map<String, dynamic>>> obtenerReportes(int idDueno) async {
    final conn = await MySqlConnection.connect(_settings);

    try {
      final result = await conn.query(
          'SELECT id, nombre_negocio, fecha_creacion FROM reportes WHERE id_dueno = ?',
          [idDueno]);

      return result
          .map((row) => {
                'id': row['id'],
                'nombre_negocio': row['nombre_negocio'],
                'fecha_creacion': row['fecha_creacion'],
              })
          .toList();
    } finally {
      await conn.close();
    }
  }

  Future<void> generarReporte(int idNegocio) async {
    final conn = await MySqlConnection.connect(_settings);

    try {
      await conn.query(
        'INSERT INTO reportes (id_negocio, fecha_creacion) VALUES (?, NOW())',
        [idNegocio],
      );
    } finally {
      await conn.close();
    }
  }
}
