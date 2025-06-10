import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';
import '../config/api_config.dart';

class AdminService {
  final String baseUrl = ApiConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  Future<int> getTotalRequesters() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/total-requesters'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get total requesters: ${response.body}');
    }
  }

  Future<int> getTotalProviders() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/total-providers'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get total providers: ${response.body}');
    }
  }

  Future<int> getTotalCompleted() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/total-completed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get total completed requests: ${response.body}');
    }
  }

  Future<int> getTotalRejected() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/total-rejected'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get total rejected requests: ${response.body}');
    }
  }

  Future<int> getTotalPending() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/total-pending'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to get total pending requests: ${response.body}');
    }
  }
} 