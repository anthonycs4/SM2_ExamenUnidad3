import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../core/network/ApiService.dart';
import '../../core/network/DatabaseService.dart';

class RegistroTurista extends StatefulWidget {
  const RegistroTurista({super.key});

  @override
  State<RegistroTurista> createState() => _RegistroTuristaState();
}

class _RegistroTuristaState extends State<RegistroTurista> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  // Estado para mostrar indicador de carga mientras se consulta el DNI
  bool _isLoadingDNI = false;

  void _consultarDNI() async {
    if (_dniController.text.isEmpty || _dniController.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un DNI válido.')),
      );
      return;
    }

    setState(() {
      _isLoadingDNI = true;
    });

    try {
      final data = await _apiService.fetchDNI(_dniController.text);
      if (data.isNotEmpty) {
        setState(() {
          _nombresController.text = data['nombres'] ?? '';
          _apellidosController.text =
              "${data['apellido_paterno']} ${data['apellido_materno']}";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró información para este DNI.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al consultar DNI: $e')),
      );
    } finally {
      setState(() {
        _isLoadingDNI = false;
      });
    }
  }

  void _registrarTurista() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final turista = {
      'dni': _dniController.text,
      'nombres': _nombresController.text,
      'apellidos': _apellidosController.text,
      'correo': _correoController.text,
      'numero_celular': _telefonoController.text,
      'pais': _paisController.text,
      'contrasena': _contrasenaController.text,
    };

    try {
      await _databaseService.registerUser(turista);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Turista registrado con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar turista: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Turista'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/registro.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 150),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dniController,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      decoration: InputDecoration(
                        labelText: 'DNI',
                        filled: true,
                        fillColor: const Color(0xFFFFC107),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.badge, color: Colors.blue),
                        suffixIcon: _isLoadingDNI
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.search, color: Colors.blue),
                                onPressed: _consultarDNI,
                              ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El DNI es obligatorio';
                        }
                        if (value.length != 8) {
                          return 'El DNI debe tener 8 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nombresController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Nombres',
                        filled: true,
                        fillColor: Color(0xFFFFC107),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _apellidosController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Apellidos',
                        filled: true,
                        fillColor: Color(0xFFFFC107),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline,
                            color: Colors.orange),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        filled: true,
                        fillColor: Color(0xFFFFC107),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.purple),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es obligatorio';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        filled: true,
                        fillColor: Color(0xFFFFC107),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono es obligatorio';
                        }
                        if (value.length != 9) {
                          return 'El teléfono debe tener 9 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _paisController,
                      decoration: const InputDecoration(
                        labelText: 'País',
                        filled: true,
                        fillColor: Color(0xFFFFC107),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.public, color: Colors.teal),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _contrasenaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        filled: true,
                        fillColor: Color(0xFFFFC107),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es obligatoria';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registrarTurista,
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
