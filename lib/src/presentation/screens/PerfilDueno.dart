// import 'package:flutter/material.dart';
// import '../../data/repositories/DuenoRepository.dart';
// import '../../core/db_config.dart';

// class PerfilDueno extends StatefulWidget {
//   final int idDueno;

//   const PerfilDueno({super.key, required this.idDueno});

//   @override
//   State<PerfilDueno> createState() => _PerfilDuenoState();
// }

// class _PerfilDuenoState extends State<PerfilDueno> {
//   final DuenoRepository _repository =
//       DuenoRepository(settings: getDatabaseSettings());

//   late Future<Map<String, dynamic>> _perfil;
//   final TextEditingController _nombreController = TextEditingController();
//   final TextEditingController _apellidoController = TextEditingController();
//   final TextEditingController _correoController = TextEditingController();
//   final TextEditingController _telefonoController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _perfil = _repository.obtenerPerfil(widget.idDueno);
//   }

//   void _guardarPerfil() async {
//     await _repository.actualizarPerfil(widget.idDueno, {
//       'nombre': _nombreController.text,
//       'apellido': _apellidoController.text,
//       'correo': _correoController.text,
//       'telefono': _telefonoController.text,
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Perfil actualizado con éxito.')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mi Perfil'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _perfil,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final perfil = snapshot.data!;
//           _nombreController.text = perfil['nombre'];
//           _apellidoController.text = perfil['apellido'];
//           _correoController.text = perfil['correo'];
//           _telefonoController.text = perfil['telefono'];

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _nombreController,
//                   decoration: const InputDecoration(labelText: 'Nombre'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _apellidoController,
//                   decoration: const InputDecoration(labelText: 'Apellido'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _correoController,
//                   decoration: const InputDecoration(labelText: 'Correo'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _telefonoController,
//                   decoration: const InputDecoration(labelText: 'Teléfono'),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _guardarPerfil,
//                   child: const Text('Guardar Cambios'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
