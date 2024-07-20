import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
              _viewFile(context, suratMasuk['file']);
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _viewFile(BuildContext context, String? fileUrl) async {
    if (fileUrl == null || fileUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file attached'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Construct the full URL for the file
    final Uri url = Uri.parse(fileUrl);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening file...'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'Could not open the file';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening file: $e'),
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
