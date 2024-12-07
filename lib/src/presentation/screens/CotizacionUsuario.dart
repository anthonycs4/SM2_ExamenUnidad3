import 'package:flutter/material.dart';
import '../../data/repositories/CotizacionRepository.dart';

class CotizacionUsuario extends StatefulWidget {
  const CotizacionUsuario({super.key});

  @override
  State<CotizacionUsuario> createState() => _CotizacionUsuarioState();
}

class _CotizacionUsuarioState extends State<CotizacionUsuario> {
  final TextEditingController _tiempoController = TextEditingController();
  final TextEditingController _personasController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _presupuestoController = TextEditingController();
  final CotizacionRepository _repository = CotizacionRepository();
  Future<List<Map<String, dynamic>>>? _resultados;

  void _generarCotizacion() {
    final parametros = {
      'tiempo': int.parse(_tiempoController.text),
      'personas': int.parse(_personasController.text),
      'motivo': _motivoController.text,
      'presupuesto': double.parse(_presupuestoController.text),
    };

    setState(() {
      _resultados = _repository.generarCotizacion(parametros);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotización'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _tiempoController, decoration: const InputDecoration(labelText: 'Tiempo (días)')),
            TextField(controller: _personasController, decoration: const InputDecoration(labelText: 'Personas')),
            TextField(controller: _motivoController, decoration: const InputDecoration(labelText: 'Motivo')),
            TextField(controller: _presupuestoController, decoration: const InputDecoration(labelText: 'Presupuesto')),
            ElevatedButton(onPressed: _generarCotizacion, child: const Text('Generar')),
           Expanded(
  child: FutureBuilder<List<Map<String, dynamic>>>(
    future: _resultados,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      final planes = snapshot.data ?? [];
      return ListView.builder(
        itemCount: planes.length,
        itemBuilder: (context, index) {
          final plan = planes[index];
          final nombrePlan = plan['plan'] ?? 'Sin nombre';
          final costoTotal = plan['costo_total'] ?? 0.0;

          return Card(
            child: ListTile(
              title: Text(nombrePlan.toString()),
              subtitle: Text('Costo total: S/${costoTotal.toString()}'),
            ),
          );
        },
      );
    },
  ),
)

          ],
        ),
      ),
    );
  }
}
