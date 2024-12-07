import 'package:flutter/material.dart';
import '../../core/network/DatabaseService.dart';
import 'RegistroNegocio.dart';

class VistaPrincipalDueno extends StatefulWidget {
  final int idDueno;

  const VistaPrincipalDueno({super.key, required this.idDueno});

  @override
  State<VistaPrincipalDueno> createState() => _VistaPrincipalDuenoState();
}

class _VistaPrincipalDuenoState extends State<VistaPrincipalDueno> {
  late Future<List<Map<String, dynamic>>> _negocios;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _negocios = _databaseService.getNegociosPorDueno(widget.idDueno);
  }

  /*void _eliminarNegocio(int idNegocio) async {
    await _databaseService.eliminarNegocio(idNegocio);
    setState(() {
      _negocios = _databaseService.getNegociosPorDueno(widget.idDueno);
    });
  }*/

  void _registrarNegocio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroNegocio(idDueno: widget.idDueno),
      ),
    ).then((_) {
      setState(() {
        _negocios = _databaseService.getNegociosPorDueno(widget.idDueno);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Negocios'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _negocios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final negocios = snapshot.data ?? [];
          return negocios.isEmpty
              ? const Center(child: Text('No tienes negocios registrados.'))
              : ListView.builder(
                  itemCount: negocios.length,
                  itemBuilder: (context, index) {
                    final negocio = negocios[index];
                    return Card(
                      child: ListTile(
                        title: Text(negocio['nombre']),
                        subtitle: Text(negocio['direccion']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistroNegocio(
                                      negocio: negocio,
                                      idDueno: widget.idDueno,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _negocios = _databaseService.getNegociosPorDueno(widget.idDueno);
                                  });
                                });
                              },
                            ),
                            /*IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarNegocio(negocio['id_negocio']),
                            ),*/
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: _registrarNegocio,
        child: const Icon(Icons.add),
      ),
    );
  }
}
