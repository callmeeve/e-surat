import 'package:esurat_poliwangi/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DirekturLayout extends StatelessWidget {
  const DirekturLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direktur'),
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
        child: Text('Welcome, Direktur!'),
      ),
    );
  }
}
