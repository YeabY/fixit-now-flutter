import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';
import '../config/api_config.dart';

class ServiceService {
  final String baseUrl = ApiConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  Future<List<dynamic>> findAll() async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Sort by rating in descending order
        data.sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
        return data;
      } else {
        throw Exception('Failed to load services: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createService(Map<String, dynamic> serviceData) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/services'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(serviceData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create service: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateService(int id, Map<String, dynamic> serviceData) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/services/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(serviceData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update service: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> deleteService(int id) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/services/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete service: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getProviderServices(int providerId) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/services/provider/$providerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load provider services: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateServiceRating(int serviceId, double rating) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/services/$serviceId/rating'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'rating': rating}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update service rating: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
} 