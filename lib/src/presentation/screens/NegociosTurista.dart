import 'package:flutter/material.dart';
import '../../core/network/DatabaseService.dart';

class NegociosTurista extends StatefulWidget {
  const NegociosTurista({Key? key}) : super(key: key);

  @override
  State<NegociosTurista> createState() => _NegociosTuristaState();
}

class _NegociosTuristaState extends State<NegociosTurista> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<Map<String, dynamic>>> _negociosFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa la lista de negocios desde la base de datos
    _negociosFuture = _databaseService.getNegociosPorTipo('Hoteles');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tiposServicios = [
      'Hoteles',
      'Restaurantes',
      'Juguerías',
      'Tours',
      'Cafeterías'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Negocios'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: ListView.builder(
        itemCount: tiposServicios.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(tiposServicios[index]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navega a la lista de negocios según el tipo seleccionado
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ListaNegociosPorTipo(tipoServicio: tiposServicios[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ListaNegociosPorTipo extends StatelessWidget {
  final String tipoServicio;

  const ListaNegociosPorTipo({Key? key, required this.tipoServicio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Negocios de $tipoServicio'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseService.getNegociosPorTipo(tipoServicio),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los negocios: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay negocios disponibles.'));
          }

          final negocios = snapshot.data!;
          return ListView.builder(
            itemCount: negocios.length,
            itemBuilder: (context, index) {
              final negocio = negocios[index];
              return Card(
                child: ListTile(
                  title: Text(negocio['nombre']),
                  subtitle: Text(negocio['direccion']),
                  onTap: () {
                    // Puedes agregar detalles al negocio aquí
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
