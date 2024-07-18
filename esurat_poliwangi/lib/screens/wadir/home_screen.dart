import 'package:esurat_poliwangi/screens/wadir/create_disposisi_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esurat_poliwangi/services/surat_disposisi_service.dart';

class WadirHomeScreen extends StatefulWidget {
  const WadirHomeScreen({super.key});

  @override
  State<WadirHomeScreen> createState() => _WadirHomeScreenState();
}

class _WadirHomeScreenState extends State<WadirHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  Future<void> _refreshData() async {
    try {
      await Provider.of<SuratDisposisiService>(context, listen: false)
          .refreshData();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final suratDisposisiService = Provider.of<SuratDisposisiService>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: suratDisposisiService.suratDisposisiStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No surat disposisi found'),
            );
          } else if (snapshot.hasData) {
            final suratDisposisis = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: suratDisposisis.length,
                itemBuilder: (context, index) {
                  final suratDisposisi = suratDisposisis[index];
                  final suratMasuk =
                      suratDisposisi['surat_masuks'] as Map<String, dynamic>? ??
                          {};
                  return ListTile(
                    title:
                        Text(suratDisposisi['disposisi_singkat'] ?? 'No Title'),
                    subtitle: Text(suratMasuk['nomor'] ?? 'No Number'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Unexpected error occurred'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateDisposisiScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
