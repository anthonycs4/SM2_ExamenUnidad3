import 'package:mysql1/mysql1.dart';

class ProvinciasRepository {
  final ConnectionSettings settings;

  ProvinciasRepository({required this.settings});

  Future<List<Map<String, dynamic>>> getNegociosPorProvincia(String provincia) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'SELECT id, nombre, direccion, tipo_servicio FROM Negocios WHERE provincia = ?',
        [provincia],
      );

      return result
          .map((row) => {
                'id': row['id'],
                'nombre': row['nombre'],
                'direccion': row['direccion'],
                'tipo_servicio': row['tipo_servicio'],
              })
          .toList();
    } finally {
      await conn.close();
    }
  }
}
