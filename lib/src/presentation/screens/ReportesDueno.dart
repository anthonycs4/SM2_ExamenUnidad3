import 'package:flutter/material.dart';
import '../../core/network/ApiService.dart';
import '../../core/network/DatabaseService.dart';

class RegistroDueno extends StatefulWidget {
  const RegistroDueno({super.key});

  @override
  State<RegistroDueno> createState() => _RegistroDuenoState();
}

class _RegistroDuenoState extends State<RegistroDueno> {
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();

  void _consultarRUC() async {
    if (_rucController.text.isEmpty || _rucController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un RUC válido.')),
      );
      return;
    }

    try {
      final data = await _apiService.fetchRUC(_rucController.text);
      setState(() {
        _nombresController.text = data['razon_social'] ?? '';
        _apellidosController.text = data['representante_legal'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al consultar RUC: $e')),
      );
    }
  }

  void _registrarDueno() async {
    if (_rucController.text.isEmpty ||
        _nombresController.text.isEmpty ||
        _apellidosController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios.')),
      );
      return;
    }

    if (_telefonoController.text.length != 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El número de teléfono debe tener 9 dígitos.')),
      );
      return;
    }

    if (!_correoController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un correo válido.')),
      );
      return;
    }

    final dueno = {
      'ruc': _rucController.text,
      'nombres': _nombresController.text,
      'apellidos': _apellidosController.text,
      'correo': _correoController.text,
      'numero_celular': _telefonoController.text,
      'origen_datos': 'APIsPeruDev',
      'contrasena': _databaseService.hashPassword(_passwordController.text),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  ..._buildTextFields(),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _registrarDueno,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.yellow],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      child: const Text(
                        "Registrar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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

  List<Widget> _buildTextFields() {
    return [
      _buildTextField(
        controller: _rucController,
        label: 'RUC',
        icon: Icons.business,
        suffixIcon: Icons.search,
        onPressedSuffix: _consultarRUC,
        keyboardType: TextInputType.number,
      ),
      _buildTextField(controller: _nombresController, label: 'Nombres', icon: Icons.person),
      _buildTextField(controller: _apellidosController, label: 'Apellidos', icon: Icons.person_outline),
      _buildTextField(controller: _correoController, label: 'Correo Electrónico', icon: Icons.email),
      _buildTextField(controller: _telefonoController, label: 'Teléfono', icon: Icons.phone, keyboardType: TextInputType.number),
      _buildTextField(controller: _passwordController, label: 'Contraseña', icon: Icons.lock, obscureText: true),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onPressedSuffix,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFFFC107),
          labelStyle: const TextStyle(
            color: Color(0xFF8B0000),
            fontWeight: FontWeight.bold,
          ),
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon, color: Colors.red),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: Colors.red),
                  onPressed: onPressedSuffix,
                )
              : null,
        ),
        style: const TextStyle(color: Color(0xFFB22222)),
      ),
    );
  }
}
