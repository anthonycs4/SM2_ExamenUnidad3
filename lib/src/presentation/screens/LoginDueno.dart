import 'package:flutter/material.dart';
import '../../core/network/DatabaseService.dart';
import 'VistaPrincipalDueno.dart';
import 'RegistroDueno.dart';

class LoginDueno extends StatefulWidget {
  const LoginDueno({super.key});

  @override
  State<LoginDueno> createState() => _LoginDuenoState();
}

class _LoginDuenoState extends State<LoginDueno> {
  final TextEditingController _rucOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  void _loginDueno() async {
    if (_rucOrEmailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RUC/Correo y contraseña son obligatorios.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dueno = await _databaseService.authenticateUser(
        'Duenos',
        _rucOrEmailController.text.contains('@') ? 'correo' : 'ruc',
        _rucOrEmailController.text,
        _passwordController.text,
      );

      if (dueno == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas.')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VistaPrincipalDueno(idDueno: dueno['id_dueno']),
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
                    'Iniciar Sesión - Dueño',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _rucOrEmailController,
                    decoration: InputDecoration(
                      labelText: 'RUC o Correo Electrónico',
                      prefixIcon: const Icon(Icons.business),
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
                          onPressed: _loginDueno,
                          child: const Text('Iniciar Sesión'),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroDueno(),
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
