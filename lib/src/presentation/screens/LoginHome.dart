import 'package:flutter/material.dart';
import 'LoginTurista.dart'; // Importa la vista LoginTurista
import 'LoginDueno.dart'; // Importa la vista LoginDueno

class LoginHome extends StatefulWidget {
  const LoginHome({super.key});

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool isPressedTurista = false;
  bool isPressedSocio = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'), // Ruta de la imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centrar el contenido
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // Para centrar correctamente

                // Texto de bienvenida
                const Text(
                  "Bienvenido !!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40), // Espacio entre el texto y botones

                // Botón "Hola Turista"
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isPressedTurista = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isPressedTurista = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginTurista()),
                    );
                  },
                  child: AnimatedScale(
                    scale: isPressedTurista
                        ? 0.95
                        : 1.0, // Efecto de escala al tocar el botón
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.yellow,
                            Colors.orange
                          ], // Degradado amarillo y naranja
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      child: const Text(
                        "Hola Turista",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre los botones

                // Botón "Hola Socio"
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isPressedSocio = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isPressedSocio = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginDueno()), // Aquí rediriges a LoginDueno
                    );
                  },
                  child: AnimatedScale(
                    scale: isPressedSocio
                        ? 0.95
                        : 1.0, // Efecto de escala al tocar el botón
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.yellow
                          ], // Degradado entre rojo y amarillo
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      child: const Text(
                        "Hola Socio",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}