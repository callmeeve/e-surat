import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esurat_poliwangi/services/auth_service.dart';

class PegawaiLayout extends StatelessWidget {
  const PegawaiLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pegawai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome, Pegawai!'),
      ),
    );
  }
}
