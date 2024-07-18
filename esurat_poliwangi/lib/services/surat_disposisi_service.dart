import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SuratDisposisiService with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final baseUrl = 'http://192.168.170.178:3000/api/surat-disposisi';
  final suratMasukUrl = 'http://192.168.170.178:3000/api/surat-masuk';
  final usersUrl = 'http://192.168.170.178:3000/api/users';

  Future<String?> get token async => await storage.read(key: 'token');

  final StreamController<List<Map<String, dynamic>>> _suratDisposisiController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get suratDisposisiStream =>
      _suratDisposisiController.stream;

  Timer? _pollingTimer;

  SuratDisposisiService() {
    getSuratDisposisi();
    startPolling();
  }

  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      getSuratDisposisi();
    });
  }

  // Get semua surat disposisi yang dimiliki oleh user
  Future<void> getSuratDisposisi() async {
    final token = await this.token;

    if (token == null || JwtDecoder.isExpired(token)) {
      throw Exception('Token tidak valid');
    }

    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['userId'];

    if (userId == null) {
      throw Exception('User ID tidak ditemukan');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Map<String, dynamic>> suratDisposisis = responseData
          .where((data) => data['user_id'] == userId)
          .map((data) {
            data['surat_masuks'] =
                Map<String, dynamic>.from(data['surat_masuks']);
            return data;
          })
          .toList()
          .cast<Map<String, dynamic>>();

      _suratDisposisiController.sink.add(suratDisposisis);
    } else {
      throw Exception('Gagal mengambil data surat disposisi');
    }
  }

  // Get data surat masuk
  Future<List<Map<String, dynamic>>> getSuratMasuk() async {
    final token = await this.token;

    if (token == null || JwtDecoder.isExpired(token)) {
      throw Exception('Token tidak valid');
    }

    final response = await http.get(
      Uri.parse(suratMasukUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil data surat masuk');
    }
  }

  // Get data users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final token = await this.token;

    if (token == null || JwtDecoder.isExpired(token)) {
      throw Exception('Token tidak valid');
    }

    final response = await http.get(
      Uri.parse(usersUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil data pengguna');
    }
  }

  // Create surat disposisi baru
  Future<void> createSuratDisposisi(Map<String, dynamic> suratDisposisi) async {
    final token = await this.token;

    if (token == null || JwtDecoder.isExpired(token)) {
      throw Exception('Token tidak valid');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(suratDisposisi),
    );

    if (response.statusCode == 201) {
      getSuratDisposisi();
    } else {
      throw Exception('Gagal membuat surat disposisi');
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _suratDisposisiController.close();
    super.dispose();
  }

  Future<void> refreshData() async {
    getSuratDisposisi();
  }
}
