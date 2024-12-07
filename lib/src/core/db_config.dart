import 'package:mysql1/mysql1.dart';

ConnectionSettings getDatabaseSettings() {
  return ConnectionSettings(
    host: 'dbplataforma.culxhlgwqx6q.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    password: 'jeanvalverde',
    db: 'plataformaBD',
  );
}
