import 'package:flutter/material.dart';
import '../../core/network/DatabaseService.dart';

class RegistroNegocio extends StatefulWidget {
  final int idDueno;
  final Map<String, dynamic>? negocio;

  const RegistroNegocio({super.key, required this.idDueno, this.negocio});

  @override
  State<RegistroNegocio> createState() => _RegistroNegocioState();
}

class _RegistroNegocioState extends State<RegistroNegocio> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.negocio != null) {
      _nombreController.text = widget.negocio!['nombre'];
      _direccionController.text = widget.negocio!['direccion'];
    }
  }

  void _guardarNegocio() async {
    if (!_formKey.currentState!.validate()) return;

    final negocio = {
      'nombre': _nombreController.text,
      'direccion': _direccionController.text,
      'id_dueno': widget.idDueno,
    };

    // try {
    //   if (widget.negocio == null) {
    //     await _databaseService.insert('Negocios', negocio);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Negocio registrado con éxito')),
    //     );
    //   } else {
    //     await _databaseService.update(
    //       'Negocios',
    //       negocio,
    //       'id_negocio = ?',
    //       [widget.negocio!['id_negocio']],
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Negocio actualizado con éxito')),
    //     );
    //   }
    //   Navigator.pop(context);
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error: $e')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.negocio == null ? 'Registrar Negocio' : 'Editar Negocio'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Negocio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La dirección es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarNegocio,
                child: Text(widget.negocio == null ? 'Registrar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
