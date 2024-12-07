import 'package:flutter/material.dart';

class VistaPrincipal extends StatefulWidget {
  const VistaPrincipal({super.key});

  @override
  State<VistaPrincipal> createState() => _VistaPrincipalState();
}

class _VistaPrincipalState extends State<VistaPrincipal> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 0
            ? const Text('Inicio')
            : _selectedIndex == 1
                ? const Text('Cotización')
                : _selectedIndex == 2
                    ? const Text('Búsqueda')
                    : const Text('Usuario'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Mantiene los iconos fijos
        backgroundColor: const Color(0xFF8B0000), // Color guinda
        selectedItemColor: Colors.yellow, // Color del icono seleccionado
        unselectedItemColor:
            Colors.white, // Color de los iconos no seleccionados
        currentIndex: _selectedIndex, // Índice seleccionado actualmente
        onTap: _onItemTapped, // Manejo de tap en los ítems
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.yellow),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.green), // Icono de cruz verde
            label: 'Cotización',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: Colors.blue), // Icono de búsqueda azul
            label: 'Búsqueda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: Colors.orange), // Icono de usuario naranja
            label: 'Usuario',
          ),
        ],
      ),
    );
  }
}