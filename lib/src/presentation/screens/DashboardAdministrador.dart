import 'package:flutter/material.dart';

class DashboardAdministrador extends StatelessWidget {
  const DashboardAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Administrador'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardCard(
              context,
              title: 'Negocios Registrados',
              icon: Icons.store,
              onTap: () {
                Navigator.pushNamed(context, '/gestionNegocios');
              },
            ),
            _buildDashboardCard(
              context,
              title: 'Estadísticas Globales',
              icon: Icons.bar_chart,
              onTap: () {
                Navigator.pushNamed(context, '/estadisticasGlobales');
              },
            ),
            _buildDashboardCard(
              context,
              title: 'Gestión de Dueños',
              icon: Icons.person,
              onTap: () {
                Navigator.pushNamed(context, '/gestionUsuarios');
              },
            ),
            _buildDashboardCard(
              context,
              title: 'Reportes',
              icon: Icons.file_copy,
              onTap: () {
                Navigator.pushNamed(context, '/reportesGlobales');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
