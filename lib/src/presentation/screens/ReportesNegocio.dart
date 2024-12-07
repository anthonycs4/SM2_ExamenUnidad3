import 'package:flutter/material.dart';
import '../../data/repositories/ReportesRepository.dart';
import '../../core/db_config.dart';

class ReportesNegocio extends StatefulWidget {
  final int idNegocio;

  const ReportesNegocio({super.key, required this.idNegocio});

  @override
  State<ReportesNegocio> createState() => _ReportesNegocioState();
}

class _ReportesNegocioState extends State<ReportesNegocio> {
  late Future<List<Map<String, dynamic>>> _reportes;
  final ReportesRepository _repository =
      ReportesRepository(settings: getDatabaseSettings());

  @override
  void initState() {
    super.initState();
    _reportes = _repository.obtenerReportes(widget.idNegocio);
  }

  void _generarReporte() async {
    try {
      await _repository.generarReporte(widget.idNegocio);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte generado con éxito.')),
      );
      setState(() {
        _reportes = _repository.obtenerReportes(widget.idNegocio);
      });
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
        title: const Text('Reportes del Negocio'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reportes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reportes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: reportes.length,
            itemBuilder: (context, index) {
              final reporte = reportes[index];
              return ListTile(
                title: Text('Reporte generado el ${reporte['fecha']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: _generarReporte,
        child: const Icon(Icons.add),
      ),
    );
  }
}
