import 'package:mysql1/mysql1.dart';

class DuenoRepository {
  final ConnectionSettings settings;

  DuenoRepository({required this.settings});

  // Método para el login del dueño
  Future<int?> loginDueno(String ruc, String password) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'SELECT id FROM Dueno WHERE ruc = ? AND password = ?',
        [ruc, password],
      );

      if (result.isEmpty) {
        return null; // Login fallido
      }

      return result.first['id'] as int; // Retorna el ID del dueño
    } finally {
      await conn.close();
    }
  }

  // Método para eliminar un negocio
  Future<void> eliminarNegocio(int idNegocio) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      await conn.query(
        'DELETE FROM Negocios WHERE id = ?',
        [idNegocio],
      );
    } finally {
      await conn.close();
    }
  }

  // Método para crear un negocio
  Future<void> crearNegocio(Map<String, dynamic> negocio) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      await conn.query(
        '''
        INSERT INTO Negocios (nombre, direccion, tipo_servicio, descripcion, id_dueno)
        VALUES (?, ?, ?, ?, ?)
        ''',
        [
          negocio['nombre'],
          negocio['direccion'],
          negocio['tipo_servicio'],
          negocio['descripcion'],
          negocio['id_dueno'],
        ],
      );
    } finally {
      await conn.close();
    }
  }

  // Método para editar un negocio
  Future<void> editarNegocio(int idNegocio, Map<String, dynamic> negocio) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      await conn.query(
        '''
        UPDATE Negocios
        SET nombre = ?, direccion = ?, tipo_servicio = ?, descripcion = ?
        WHERE id = ?
        ''',
        [
          negocio['nombre'],
          negocio['direccion'],
          negocio['tipo_servicio'],
          negocio['descripcion'],
          idNegocio,
        ],
      );
    } finally {
      await conn.close();
    }
  }

  // Método para obtener negocios de un dueño
  Future<List<Map<String, dynamic>>> getNegocios(int idDueno) async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final result = await conn.query(
        'SELECT id, nombre, direccion, tipo_servicio, descripcion FROM Negocios WHERE id_dueno = ?',
        [idDueno],
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
}
