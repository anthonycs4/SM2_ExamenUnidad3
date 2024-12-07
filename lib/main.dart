import 'package:flutter/material.dart';
import 'src/presentation/screens/LoginHome.dart';
import 'src/presentation/screens/VistaPrincipalTurista.dart';
import 'src/presentation/screens/VistaPrincipalDueno.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina la etiqueta de depuración
      title: 'Plataforma Turística',
      theme: ThemeData(
        primarySwatch: Colors.red, // Color principal
        scaffoldBackgroundColor: Colors.white, // Fondo blanco
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B0000), // Color guinda para el AppBar
          foregroundColor: Colors.white, // Color del texto en el AppBar
        ),
      ),
      initialRoute: '/loginHome', // Ruta inicial
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/loginHome':
            return MaterialPageRoute(builder: (context) => const LoginHome());
          case '/vistaTurista':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => VistaPrincipalTurista(userId: args['userId']),
            );
          case '/vistaDueno':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => VistaPrincipalDueno(idDueno: args['idDueno']),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginHome(),
            );
        }
      },
    );
  }
}
