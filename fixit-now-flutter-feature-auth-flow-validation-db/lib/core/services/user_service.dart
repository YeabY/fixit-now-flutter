import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';
import '../config/api_config.dart';

class UserService {
  final String baseUrl = ApiConfig.baseUrl;
  final TokenService _tokenService;
  final http.Client _client;

  UserService({
    TokenService? tokenService,
    http.Client? client,
  })  : _tokenService = tokenService ?? TokenService(),
        _client = client ?? http.Client();

  Future<List<dynamic>> getRequesters() async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/requesters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load requesters');
    }
  }

  Future<List<dynamic>> searchRequesterByName(String name) async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/search-requester?name=$name'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search requesters: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createRequester(Map<String, dynamic> userData) async {
    final token = await _tokenService.getToken();
    final response = await _client.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        ...userData,
        'role': 'REQUESTER',
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create requester');
    }
  }

  Future<Map<String, dynamic>> updateRequester(int id, Map<String, dynamic> userData) async {
    final token = await _tokenService.getToken();
    final response = await _client.patch(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update requester');
    }
  }

  Future<void> deleteRequester(int id) async {
    final token = await _tokenService.getToken();
    final response = await _client.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete requester');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required int userId,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? cbeAccount,
    String? paypalAccount,
    String? telebirrAccount,
    String? awashAccount,
    String? serviceType,
    String? password,
  }) async {
    final token = await _tokenService.getToken();
    final response = await _client.patch(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (cbeAccount != null) 'cbeAccount': cbeAccount,
        if (paypalAccount != null) 'paypalAccount': paypalAccount,
        if (telebirrAccount != null) 'telebirrAccount': telebirrAccount,
        if (awashAccount != null) 'awashAccount': awashAccount,
        if (serviceType != null) 'serviceType': serviceType,
        if (password != null) 'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<List<dynamic>> getProviders() async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/providers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load providers');
    }
  }

  Future<List<dynamic>> searchProviderByName(String name) async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/search-provider?name=$name'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search providers: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createProvider(Map<String, dynamic> userData) async {
    final token = await _tokenService.getToken();
    final response = await _client.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        ...userData,
        'role': 'PROVIDER',
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create provider');
    }
  }

  Future<Map<String, dynamic>> updateProvider(int id, Map<String, dynamic> userData) async {
    final token = await _tokenService.getToken();
    final response = await _client.patch(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update provider');
    }
  }

  Future<void> deleteProvider(int id) async {
    final token = await _tokenService.getToken();
    final response = await _client.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete provider');
    }
  }

  Future<List<dynamic>> getTopRatedProviders() async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/top-rated-providers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top rated providers');
    }
  }

  Future<int> getTotalProviders() async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/users/total-providers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load total providers count');
    }
  }
}