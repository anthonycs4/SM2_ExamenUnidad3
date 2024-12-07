import 'package:flutter/material.dart';
import '../../data/repositories/EstadisticasRepository.dart';
import '../../core/db_config.dart';

class EstadisticasNegocio extends StatelessWidget {
  final int idNegocio;

  const EstadisticasNegocio({super.key, required this.idNegocio});

  @override
  Widget build(BuildContext context) {
    final EstadisticasRepository repository =
        EstadisticasRepository(settings: getDatabaseSettings());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas del Negocio'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: repository.obtenerEstadisticasNegocio(idNegocio),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stats = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Visitas Totales: ${stats['visitas_totales']}'),
                Text('Visitas Día: ${stats['visitas_dia']}'),
                Text('Visitas Noche: ${stats['visitas_noche']}'),
                Text('Contactos: ${stats['contactos']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
