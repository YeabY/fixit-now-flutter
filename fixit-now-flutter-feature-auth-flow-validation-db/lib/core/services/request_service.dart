import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';
import '../models/request.dart';
import '../config/api_config.dart';

class RequestService {
  final String baseUrl = ApiConfig.baseUrl;
  final TokenService _tokenService;
  final http.Client _client;

  RequestService({
    TokenService? tokenService,
    http.Client? client,
  })  : _tokenService = tokenService ?? TokenService(),
        _client = client ?? http.Client();

  Future<Request> createRequest({
    required String serviceType,
    required String description,
    required String urgency,
    required double budget,
    DateTime? scheduledDate,
    int? serviceId,
  }) async {
    final token = await _tokenService.getToken();
    final response = await _client.post(
      Uri.parse('$baseUrl/requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'serviceType': serviceType,
        'description': description,
        'urgency': urgency,
        'budget': budget,
        if (scheduledDate != null) 'scheduledDate': scheduledDate.toIso8601String(),
        if (serviceId != null) 'service_id': serviceId,
      }),
    );

    if (response.statusCode == 201) {
      return Request.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create request: ${response.body}');
    }
  }

  Future<List<Request>> getMyRequests() async {
    final token = await _tokenService.getToken();
    final response = await _client.get(
      Uri.parse('$baseUrl/requests/my-requests'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load requests: ${response.body}');
    }
  }

  Future<Request> updateRequestStatus(int requestId, String status) async {
    final token = await _tokenService.getToken();
    final response = await _client.patch(
      Uri.parse('$baseUrl/requests/$requestId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update request status: ${response.body}');
    }
  }

  Future<Request> addReview({
    required int requestId,
    required double rating,
    required String review,
  }) async {
    final token = await _tokenService.getToken();
    final response = await _client.patch(
      Uri.parse('$baseUrl/requests/$requestId/review'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'rating': rating,
        'review': review,
      }),
    );

    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add review: ${response.body}');
    }
  }

  Future<List<Request>> getAllRequests(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Request.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch requests');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<Request>> getCompletedRequests(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/requests/completed-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Request.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch completed requests');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<Request>> getRejectedRequests(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/requests/rejected-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Request.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch rejected requests');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
} 