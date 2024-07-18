import 'package:esurat_poliwangi/layouts/direktur_layout.dart';
import 'package:esurat_poliwangi/layouts/pegawai_layout.dart';
import 'package:esurat_poliwangi/layouts/wadir_layout.dart';
import 'package:esurat_poliwangi/screens/login_screen.dart';
import 'package:esurat_poliwangi/services/surat_disposisi_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esurat_poliwangi/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider<SuratDisposisiService>(
          create: (context) => SuratDisposisiService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.blue,
            secondary: Colors.blueAccent,
            background: Colors.white,
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return FutureBuilder<bool>(
              future: authService.isAuthenticated,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.blue,
                  );
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const AuthWrapper();
                } else {
                  return const LoginScreen();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // Define a map for role to screen navigation
    final Map<String, Widget> roleToScreen = {
      'Direktur': const DirekturLayout(),
      'Wadir': const WadirLayout(),
      'Pegawai': const PegawaiLayout(),
    };

    return FutureBuilder<List<String>>(
      future: authService.roles.then((value) => value ?? []),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          Widget dashboard = roleToScreen.entries
              .firstWhere(
                (entry) => snapshot.data!.contains(entry.key),
                orElse: () => const MapEntry(
                  'default',
                  Center(
                    child: Text('Role not recognized'),
                  ),
                ),
              )
              .value;
          return dashboard;
        } else {
          return const Center(
            child: Text('No roles found or error occurred'),
          );
        }
      },
    );
  }
}
