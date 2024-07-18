import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService with ChangeNotifier {
  final storage = const FlutterSecureStorage();

  final baseUrl = 'http://192.168.170.178:3000/api/auth';
  // final baseUrl = 'https://tasty-planets-move.loca.lt/api/auth';

  Future<String?> get token async => await storage.read(key: 'token');

  Future<String?> get userId async => await storage.read(key: 'userId');

  Future<List<String>?> get roles async {
    final rolesString = await storage.read(key: 'roles');
    return rolesString != null
        ? List<String>.from(json.decode(rolesString))
        : null;
  }

  Future<bool> get isAuthenticated async {
    final token = await this.token;
    return token != null && !JwtDecoder.isExpired(token);
  }

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await storage.write(key: 'token', value: responseData['token']);
      await storage.write(
        key: 'roles',
        value: jsonEncode(responseData['roles']),
      );
      await storage.write(
        key: 'userId',
        value: responseData['userId'],
      );
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'roles');
    notifyListeners();
  }
}
