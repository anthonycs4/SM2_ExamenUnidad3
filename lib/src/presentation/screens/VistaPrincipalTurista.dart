import 'package:flutter/material.dart';
import 'CotizacionUsuario.dart';
import 'ProvinciasTurista.dart';
import 'NegociosTurista.dart';

class VistaPrincipalTurista extends StatefulWidget {
  final int userId;

  const VistaPrincipalTurista({super.key, required this.userId});

  @override
  State<VistaPrincipalTurista> createState() => _VistaPrincipalTuristaState();
}

class _VistaPrincipalTuristaState extends State<VistaPrincipalTurista> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Text('Inicio: Bienvenido Usuario ID ${widget.userId}'),
      const CotizacionUsuario(),
      const ProvinciasTurista(),
      const NegociosTurista(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openUserProfile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Configuración de Usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar perfil'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar perfil seleccionado')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/loginHome', // Ruta para volver al inicio de sesión
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Turista'),
        backgroundColor: const Color(0xFF8B0000),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _openUserProfile,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF8B0000),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Cotización',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Provincias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Negocios',
          ),
        ],
      ),
    );
  }
}
