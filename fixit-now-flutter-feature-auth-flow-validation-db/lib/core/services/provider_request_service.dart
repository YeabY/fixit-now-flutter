import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/token_service.dart';
import '../models/request.dart';
import '../config/api_config.dart';

class ProviderRequestService {
  final String baseUrl = ApiConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  Future<List<Request>> getUnassignedRequests() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/unassigned'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load unassigned requests: ${response.body}');
    }
  }

  Future<Request> acceptRequest(int requestId) async {
    final token = await _tokenService.getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/requests/$requestId/accept'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to accept request: ${response.body}');
    }
  }

  Future<List<Request>> getProviderRecentRequests() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/provider-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load provider requests: ${response.body}');
    }
  }

  Future<List<Request>> getProviderAcceptedRequests() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/provider-accepted'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load accepted requests: ${response.body}');
    }
  }

  Future<List<Request>> getProviderCompletedRequests() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/provider-completed'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load completed requests: ${response.body}');
    }
  }

  Future<int> getProviderCompletedRequestCount() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/provider-stats/completed-count'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return int.tryParse(response.body) ?? 0;
    } else {
      throw Exception('Failed to load completed request count: ${response.body}');
    }
  }

  Future<double> getProviderAverageRating() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/provider-stats/average-rating'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return double.tryParse(response.body) ?? 0.0;
    } else {
      throw Exception('Failed to load average rating: ${response.body}');
    }
  }

  Future<double> getProviderTotalBudget() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/requests/provider-stats/total-budget'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return double.tryParse(response.body) ?? 0.0;
    } else {
      throw Exception('Failed to load total budget: ${response.body}');
    }
  }
}
