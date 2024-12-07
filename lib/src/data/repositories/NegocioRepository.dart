import 'package:mysql1/mysql1.dart';

class NegocioRepository {
  final ConnectionSettings settings;

  NegocioRepository({required this.settings});

  Future<List<Map<String, dynamic>>> getNegocios() async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'SELECT id, nombre, direccion, tipo_servicio, descripcion FROM Negocios',
      );

      return result
          .map((row) => {
                'id': row['id'],
                'nombre': row['nombre'],
                'direccion': row['direccion'],
                'tipo_servicio': row['tipo_servicio'],
                'descripcion': row['descripcion'],
              })
          .toList();
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>> getNegocioDetalle(int idNegocio) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'SELECT id, nombre, direccion, tipo_servicio, descripcion FROM Negocios WHERE id = ?',
        [idNegocio],
      );

      if (result.isEmpty) {
        throw Exception('Negocio no encontrado');
      }

      final row = result.first;
      return {
        'id': row['id'],
        'nombre': row['nombre'],
        'direccion': row['direccion'],
        'tipo_servicio': row['tipo_servicio'],
        'descripcion': row['descripcion'],
      };
    } finally {
      await conn.close();
    }
  }

  Future<void> agregarFeedback(int idNegocio, Map<String, dynamic> feedback) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      await conn.query(
        'INSERT INTO Feedback (id_negocio, calificacion, comentario) VALUES (?, ?, ?)',
        [idNegocio, feedback['calificacion'], feedback['comentario']],
      );
    } finally {
      await conn.close();
    }
  }
}
