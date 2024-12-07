import 'package:flutter/material.dart';
import '../../data/repositories/NegocioRepository.dart';
import '../../core/db_config.dart';

class NegocioDetalle extends StatefulWidget {
  final int idNegocio;

  const NegocioDetalle({super.key, required this.idNegocio});

  @override
  State<NegocioDetalle> createState() => _NegocioDetalleState();
}

class _NegocioDetalleState extends State<NegocioDetalle> {
  final NegocioRepository _repository =
      NegocioRepository(settings: getDatabaseSettings());
  late Future<Map<String, dynamic>> _negocio;

  final TextEditingController _comentarioController = TextEditingController();
  int _calificacion = 0;

  @override
  void initState() {
    super.initState();
    _negocio = _repository.getNegocioDetalle(widget.idNegocio);
  }

  void _enviarFeedback() async {
    try {
      await _repository.agregarFeedback(widget.idNegocio, {
        'calificacion': _calificacion,
        'comentario': _comentarioController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gracias por tu feedback!')),
      );
      _comentarioController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Negocio'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _negocio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final negocio = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  negocio['nombre'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Dirección: ${negocio['direccion']}'),
                Text('Tipo: ${negocio['tipo_servicio']}'),
                const SizedBox(height: 20),
                const Text('Deja tu feedback:'),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        _calificacion > index
                            ? Icons.star
                            : Icons.star_border,
                      ),
                      onPressed: () {
                        setState(() {
                          _calificacion = index + 1;
                        });
                      },
                    );
                  }),
                ),
                TextField(
                  controller: _comentarioController,
                  decoration: const InputDecoration(
                    labelText: 'Comentario',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _enviarFeedback,
                  child: const Text('Enviar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
