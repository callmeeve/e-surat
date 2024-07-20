import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailDisposisiScreen extends StatelessWidget {
  final Map<String, dynamic> suratDisposisi;

  const DetailDisposisiScreen({super.key, required this.suratDisposisi});

  @override
  Widget build(BuildContext context) {
    final suratMasuk =
        suratDisposisi['surat_masuks'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Disposisi'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard(
                'Induk:', suratDisposisi['induk']?.toString() ?? 'N/A'),
            _buildDetailCard('Disposisi Singkat:',
                suratDisposisi['disposisi_singkat'] ?? 'N/A'),
            _buildDetailCard('Disposisi Narasi:',
                suratDisposisi['disposisi_narasi'] ?? 'N/A'),
            _buildDetailCard('Waktu:', _formatDate(suratDisposisi['waktu'])),
            _buildDetailCard(
                'Surat Masuk Nomor:', suratMasuk['nomor'] ?? 'N/A'),
            _buildDetailCard('Pengirim:', suratMasuk['pengirim'] ?? 'N/A'),
            _buildDetailCard(
                'Tanggal Surat:', _formatDate(suratMasuk['tanggal_surat'])),
            _buildDetailCard('Tanggal Diterima:',
                _formatDate(suratMasuk['tanggal_diterima'])),
            _buildDetailCard('Catatan Sekretariat:',
                suratMasuk['catatan_sekretariat'] ?? 'N/A'),
            _buildDetailCard('File:', suratMasuk['file'] ?? 'N/A', onTap: () {
              downloadFile(context, suratMasuk['file']);
            }),
          ],
        ),
      ),
    );
  }

  Future<void> downloadFile(BuildContext context, String fileUrl) async {
    // Request storage permissions
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    String baseUrl = 'http://192.168.170.178:3000/uploads/';
    final url = baseUrl + fileUrl;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Use path_provider to get the path to the downloads directory
        Directory? directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/$folder";
          } else {
            break;
          }
        }
        newPath = "$newPath/Download";
        directory = Directory(newPath);

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final file = File('${directory.path}/$fileUrl');
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File berhasil diunduh ke folder: $file'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh file: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat.yMMMd().format(date); // Format date as "Jul 20, 2024"
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Widget _buildDetailCard(String title, String value, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 0,
      child: ListTile(
        leading: Icon(
          _getIconForTitle(title),
          color: Colors.blue,
        ),
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Induk:':
        return Icons.category;
      case 'Disposisi Singkat:':
        return Icons.description;
      case 'Disposisi Narasi:':
        return Icons.article;
      case 'Waktu:':
        return Icons.access_time;
      case 'Surat Masuk Nomor:':
        return Icons.mark_email_read;
      case 'Pengirim:':
        return Icons.person;
      case 'Tanggal Surat:':
        return Icons.date_range;
      case 'Tanggal Diterima:':
        return Icons.date_range;
      case 'Catatan Sekretariat:':
        return Icons.note;
      case 'File:':
        return Icons.attach_file;
      default:
        return Icons.help;
    }
  }
}
