import 'package:mysql1/mysql1.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Para utf8.encode

class DatabaseService {
  final ConnectionSettings _settings = ConnectionSettings(
    host: 'dbplataforma.culxhlgwqx6q.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    password: 'jeanvalverde',
    db: 'plataformabd',
  );

  /// Conectar a la base de datos
  Future<MySqlConnection> connect() async {
    return await MySqlConnection.connect(_settings);
  }

  /// Método para hashear contraseñas
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Método genérico para insertar datos
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final conn = await connect();
    try {
      final keys = data.keys.join(',');
      final values = List.generate(data.length, (_) => '?').join(',');
      final result = await conn.query(
        'INSERT INTO $table ($keys) VALUES ($values)',
        data.values.toList(),
      );
      return result.insertId ?? 0;
    } finally {
      await conn.close();
    }
  }

  /// Método para autenticar usuarios
  Future<Map<String, dynamic>?> authenticateUser(
      String table, String identifierField, String identifierValue, String password) async {
    final conn = await connect();
    try {
      final query = '''
        SELECT * FROM $table 
        WHERE $identifierField = ?
      ''';
      final results = await conn.query(query, [identifierValue]);

      if (results.isNotEmpty) {
        final user = results.first.fields;
        final hashedPassword = hashPassword(password);

        if (user['contrasena'] == hashedPassword) {
          return user;
        }
      }
      return null;
    } finally {
      await conn.close();
    }
  }

  /// Método para autenticar dueños (RUC o correo)
  Future<Map<String, dynamic>?> authenticateDueno(String identifierValue, String password) async {
    final conn = await connect();
    try {
      final query = '''
        SELECT * FROM Duenos 
        WHERE ruc = ? OR correo = ?
      ''';
      final results = await conn.query(query, [identifierValue, identifierValue]);

      if (results.isNotEmpty) {
        final dueno = results.first.fields;
        final hashedPassword = hashPassword(password);

        if (dueno['contrasena'] == hashedPassword) {
          return dueno;
        }
      }
      return null;
    } finally {
      await conn.close();
    }
  }

  /// Método para registrar un usuario con contraseña hasheada
  Future<int> registerUser(Map<String, dynamic> userData) async {
    userData['contrasena'] = hashPassword(userData['contrasena']);
    return await insert('Usuarios', userData);
  }

  /// Método para registrar un dueño con contraseña hasheada
  Future<int> registerDueno(Map<String, dynamic> duenoData) async {
    duenoData['contrasena'] = hashPassword(duenoData['contrasena']);
    return await insert('Duenos', duenoData);
  }

  /// Obtener negocios de un dueño por ID
  Future<List<Map<String, dynamic>>> getNegociosPorDueno(int idDueno) async {
    final conn = await connect();
    try {
      final results = await conn.query(
        '''
        SELECT id_servicio AS id, nombre_servicio AS nombre, descripcion, 
        JSON_UNQUOTE(JSON_EXTRACT(ubicacion, '.direccion')) AS direccion
        FROM Servicios WHERE id_dueno = ?
        ''',
        [idDueno],
      );
      return results
          .map((row) => {
                'id': row['id'],
                'nombre': row['nombre'],
                'descripcion': row['descripcion'],
                'direccion': row['direccion'],
              })
          .toList();
    } finally {
      await conn.close();
    }
  }

  /// Obtener negocios por tipo
  Future<List<Map<String, dynamic>>> getNegociosPorTipo(String tipoServicio) async {
    final conn = await connect();
    try {
      final results = await conn.query(
        '''
        SELECT id_servicio AS id, nombre_servicio AS nombre, descripcion, 
        JSON_UNQUOTE(ubicacion->".direccion") AS direccion
        FROM Servicios WHERE JSON_UNQUOTE(ubicacion->".tipo") = ?
        ''',
        [tipoServicio],
      );
      return results
          .map((row) => {
                'id': row['id'],
                'nombre': row['nombre'],
                'descripcion': row['descripcion'],
                'direccion': row['direccion'],
              })
          .toList();
    } finally {
      await conn.close();
    }
  }

  /// Obtener detalles de un negocio
  Future<Map<String, dynamic>> getNegocioDetalle(int idNegocio) async {
    final conn = await connect();
    try {
      final results = await conn.query(
        '''
        SELECT id_servicio AS id, nombre_servicio AS nombre, descripcion, 
        JSON_UNQUOTE(ubicacion->".direccion") AS direccion
        FROM Servicios WHERE id_servicio = ?
        ''',
        [idNegocio],
      );
      if (results.isEmpty) {
        throw Exception('Negocio no encontrado');
      }
      final row = results.first;
      return {
        'id': row['id'],
        'nombre': row['nombre'],
        'descripcion': row['descripcion'],
        'direccion': row['direccion'],
      };
    } finally {
      await conn.close();
    }
  }

  /// Insertar cotización
  Future<int> insertarCotizacion(Map<String, dynamic> cotizacion) async {
    final conn = await connect();
    try {
      final result = await conn.query(
        '''
        INSERT INTO Cotizaciones (id_usuario, tiempo_viaje, cantidad_personas, motivo_viaje, presupuesto, resultados) 
        VALUES (?, ?, ?, ?, ?, ?)
        ''',
        [
          cotizacion['id_usuario'],
          cotizacion['tiempo_viaje'],
          cotizacion['cantidad_personas'],
          cotizacion['motivo_viaje'],
          cotizacion['presupuesto'],
          cotizacion['resultados'],
        ],
      );
      return result.insertId ?? 0;
    } finally {
      await conn.close();
    }
  }

  /// Obtener cotizaciones por usuario
  Future<List<Map<String, dynamic>>> getCotizacionesPorUsuario(int idUsuario) async {
    final conn = await connect();
    try {
      final results = await conn.query(
        '''
        SELECT id_cotizacion, tiempo_viaje, cantidad_personas, motivo_viaje, presupuesto, resultados, fecha_cotizacion 
        FROM Cotizaciones WHERE id_usuario = ?
        ''',
        [idUsuario],
      );
      return results.map((row) => row.fields).toList();
    } finally {
      await conn.close();
    }
  }

  /// Agregar feedback para un negocio
  Future<void> agregarFeedback(int idNegocio, Map<String, dynamic> feedback) async {
    final conn = await connect();
    try {
      await conn.query(
        'INSERT INTO Feedback (id_servicio, calificacion, comentario) VALUES (?, ?, ?)',
        [idNegocio, feedback['calificacion'], feedback['comentario']],
      );
    } finally {
      await conn.close();
    }
  }
}
