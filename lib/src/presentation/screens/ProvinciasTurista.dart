import 'package:flutter/material.dart';

class ProvinciasTurista extends StatelessWidget {
  const ProvinciasTurista({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> provincias = [
      'Tacna',
      'Moquegua',
      'Arequipa',
      'Cusco'
    ]; // Ejemplo de provincias

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provincias'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: ListView.builder(
        itemCount: provincias.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(provincias[index]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Redirige a una vista que liste los negocios y atractivos de la provincia seleccionada
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ListaPorProvincia(provincia: provincias[index]),
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

class ListaPorProvincia extends StatelessWidget {
  final String provincia;

  const ListaPorProvincia({super.key, required this.provincia});

  @override
  Widget build(BuildContext context) {
    final List<String> atractivos = [
      'Atractivo 1',
      'Atractivo 2',
      'Atractivo 3'
    ]; // Ejemplo de atractivos turísticos

    return Scaffold(
      appBar: AppBar(
        title: Text('Atractivos y Negocios en $provincia'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: ListView.builder(
        itemCount: atractivos.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(atractivos[index]),
              subtitle: const Text('Descripción del atractivo'),
            ),
          );
        },
      ),
    );
  }
}
