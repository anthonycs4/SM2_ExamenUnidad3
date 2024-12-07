import 'package:flutter/material.dart';
import '../../core/network/DatabaseService.dart';
import 'VistaPrincipalTurista.dart';
import 'RegistroTurista.dart';

class LoginTurista extends StatefulWidget {
  const LoginTurista({super.key});

  @override
  State<LoginTurista> createState() => _LoginTuristaState();
}

class _LoginTuristaState extends State<LoginTurista> {
  final TextEditingController _dniOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  void _loginTurista() async {
    if (_dniOrEmailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DNI/Correo y contraseña son obligatorios.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _databaseService.authenticateUser(
        'Usuarios',
        _dniOrEmailController.text.contains('@') ? 'correo' : 'dni',
        _dniOrEmailController.text,
        _passwordController.text,
      );

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas.')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VistaPrincipalTurista(userId: user['id_usuario']),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Iniciar Sesión - Turista',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _dniOrEmailController,
                    decoration: InputDecoration(
                      labelText: 'DNI o Correo Electrónico',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          onPressed: _loginTurista,
                          child: const Text('Iniciar Sesión'),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroTurista(),
                        ),
                      );
                    },
                    child: const Text(
                      "Crear cuenta",
                      style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
