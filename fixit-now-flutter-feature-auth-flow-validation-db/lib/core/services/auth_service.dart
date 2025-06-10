import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config/api_config.dart';

class AuthService {
  static const String baseUrl = ApiConfig.baseUrl;
  final http.Client _client;

  AuthService([http.Client? client]) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> login(String name, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Login failed: status=${response.statusCode}, body=${response.body}');
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Failed to login');
        } catch (_) {
          throw Exception('Failed to login: ${response.body}');
        }
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<User> getProfile(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get profile');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> logout(String token) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to logout');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> register(User user) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to register');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}