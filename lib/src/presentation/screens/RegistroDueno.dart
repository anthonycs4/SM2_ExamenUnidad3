import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../core/network/ApiService.dart';
import '../../core/network/DatabaseService.dart';

class RegistroDueno extends StatefulWidget {
  const RegistroDueno({super.key});

  @override
  State<RegistroDueno> createState() => _RegistroDuenoState();
}

class _RegistroDuenoState extends State<RegistroDueno> {
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingRUC = false;
  bool _isFieldsEnabled = false;

  void _consultarRUC() async {
    if (_rucController.text.isEmpty || _rucController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un RUC válido.')),
      );
      return;
    }

    setState(() {
      _isLoadingRUC = true;
      _isFieldsEnabled = false;
    });

    try {
      final data = await _apiService.fetchRUC(_rucController.text);
      final estado = data['estado'] ?? 'Desconocido';
      final nombres = data['razonSocial'] ?? '';
      final apellidos = data['representante'] ?? ''; // Si aplica el dato

      setState(() {
        _estadoController.text = estado;
        _nombresController.text = nombres;
        _apellidosController.text = apellidos;

        if (estado.toUpperCase() == 'ACTIVO') {
          _isFieldsEnabled = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El RUC no está ACTIVO.')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al consultar RUC: $e')),
      );
    } finally {
      setState(() {
        _isLoadingRUC = false;
      });
    }
  }

  void _registrarDueno() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dueno = {
      'nombres': _nombresController.text,
      'apellidos': _apellidosController.text,
      'correo': _correoController.text,
      'numero_celular': _telefonoController.text,
      'ruc': _rucController.text,
      'estado': _estadoController.text,
      'origen_datos': 'APIsPeruDev',
      'contrasena': _databaseService.hashPassword(_contrasenaController.text),
    };

    try {
      await _databaseService.registerDueno(dueno);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dueño registrado con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar dueño: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Dueño'),
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
                    _buildTextField(
                      controller: _rucController,
                      label: 'RUC',
                      icon: Icons.business,
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.search,
                      onPressedSuffix: _consultarRUC,
                      enabled: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El RUC es obligatorio.';
                        }
                        if (value.length != 11) {
                          return 'El RUC debe tener 11 dígitos.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _estadoController,
                      label: 'Estado',
                      icon: Icons.info,
                      enabled: false,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _nombresController,
                      label: 'Nombres',
                      icon: Icons.person,
                      enabled: _isFieldsEnabled,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _apellidosController,
                      label: 'Apellidos',
                      icon: Icons.person_outline,
                      enabled: _isFieldsEnabled,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _correoController,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      enabled: _isFieldsEnabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo electrónico es obligatorio.';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Ingrese un correo electrónico válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _telefonoController,
                      label: 'Teléfono',
                      icon: Icons.phone,
                      keyboardType: TextInputType.number,
                      enabled: _isFieldsEnabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono es obligatorio.';
                        }
                        if (value.length != 9) {
                          return 'El teléfono debe tener 9 dígitos.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _contrasenaController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                      enabled: _isFieldsEnabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es obligatoria.';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isFieldsEnabled ? _registrarDueno : null,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onPressedSuffix,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFC107),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: Colors.red),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.red),
                onPressed: onPressedSuffix,
              )
            : null,
      ),
      validator: validator,
    );
  }
}
