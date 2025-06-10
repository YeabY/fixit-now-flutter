import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fixit_now/core/services/request_service.dart';
import 'package:fixit_now/core/models/request.dart';
import 'package:fixit_now/core/config/api_config.dart';
import 'package:fixit_now/core/services/token_service.dart';

// Generate mock classes
@GenerateMocks([http.Client, TokenService])
import 'request_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late MockTokenService mockTokenService;
  late RequestService requestService;
  const testToken = 'test_token';

  setUp(() {
    mockClient = MockClient();
    mockTokenService = MockTokenService();
    requestService = RequestService(
      client: mockClient,
      tokenService: mockTokenService,
    );
    when(mockTokenService.getToken()).thenAnswer((_) async => testToken);
  });

  group('createRequest', () {
    test('should create a request successfully', () async {
      // Arrange
      final requestData = {
        'id': 1,
        'serviceType': 'PLUMBING',
        'description': 'Fix leaky faucet',
        'urgency': 'HIGH',
        'budget': 100.0,
        'status': 'PENDING',
        'createdAt': DateTime.now().toIso8601String(),
      };

      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(requestData), 201));

      // Act
      final result = await requestService.createRequest(
        serviceType: 'PLUMBING',
        description: 'Fix leaky faucet',
        urgency: 'HIGH',
        budget: 100.0,
      );

      // Assert
      expect(result, isA<Request>());
      expect(result.serviceType, equals('PLUMBING'));
      expect(result.description, equals('Fix leaky faucet'));
      expect(result.urgency, equals('HIGH'));
      expect(result.budget, equals(100.0));
    });

    test('should throw exception when request creation fails', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/requests'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
        () => requestService.createRequest(
          serviceType: 'PLUMBING',
          description: 'Fix leaky faucet',
          urgency: 'HIGH',
          budget: 100.0,
        ),
        throwsException,
      );
    });
  });

  group('getMyRequests', () {
    test('should return list of requests successfully', () async {
      // Arrange
      final requestsData = [
        {
          'id': 1,
          'serviceType': 'PLUMBING',
          'description': 'Fix leaky faucet',
          'urgency': 'HIGH',
          'budget': 100.0,
          'status': 'PENDING',
          'createdAt': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'serviceType': 'ELECTRICAL',
          'description': 'Fix power outlet',
          'urgency': 'MEDIUM',
          'budget': 150.0,
          'status': 'COMPLETED',
          'createdAt': DateTime.now().toIso8601String(),
        },
      ];

      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/requests/my-requests'),
        headers: {'Authorization': 'Bearer $testToken'},
      )).thenAnswer((_) async => http.Response(jsonEncode(requestsData), 200));

      // Act
      final result = await requestService.getMyRequests();

      // Assert
      expect(result, isA<List<Request>>());
      expect(result.length, equals(2));
      expect(result[0].serviceType, equals('PLUMBING'));
      expect(result[1].serviceType, equals('ELECTRICAL'));
    });

    test('should throw exception when fetching requests fails', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/requests/my-requests'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(() => requestService.getMyRequests(), throwsException);
    });
  });

  group('updateRequestStatus', () {
    test('should update request status successfully', () async {
      // Arrange
      final requestData = {
        'id': 1,
        'serviceType': 'PLUMBING',
        'description': 'Fix leaky faucet',
        'urgency': 'HIGH',
        'budget': 100.0,
        'status': 'IN_PROGRESS',
        'createdAt': DateTime.now().toIso8601String(),
      };

      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/requests/1/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
        body: jsonEncode({'status': 'IN_PROGRESS'}),
      )).thenAnswer((_) async => http.Response(jsonEncode(requestData), 200));

      // Act
      final result = await requestService.updateRequestStatus(1, 'IN_PROGRESS');

      // Assert
      expect(result, isA<Request>());
      expect(result.status, equals('IN_PROGRESS'));
    });

    test('should throw exception when status update fails', () async {
      // Arrange
      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/requests/1/status'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
        () => requestService.updateRequestStatus(1, 'IN_PROGRESS'),
        throwsException,
      );
    });
  });

  group('addReview', () {
    test('should add review successfully', () async {
      // Arrange
      final requestData = {
        'id': 1,
        'serviceType': 'PLUMBING',
        'description': 'Fix leaky faucet',
        'urgency': 'HIGH',
        'budget': 100.0,
        'status': 'COMPLETED',
        'rating': 4.5,
        'review': 'Great service!',
        'createdAt': DateTime.now().toIso8601String(),
      };

      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/requests/1/review'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
        body: jsonEncode({
          'rating': 4.5,
          'review': 'Great service!',
        }),
      )).thenAnswer((_) async => http.Response(jsonEncode(requestData), 200));

      // Act
      final result = await requestService.addReview(
        requestId: 1,
        rating: 4.5,
        review: 'Great service!',
      );

      // Assert
      expect(result, isA<Request>());
      expect(result.rating, equals(4.5));
      expect(result.review, equals('Great service!'));
    });

    test('should throw exception when adding review fails', () async {
      // Arrange
      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/requests/1/review'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
        () => requestService.addReview(
          requestId: 1,
          rating: 4.5,
          review: 'Great service!',
        ),
        throwsException,
      );
    });
  });

  group('getAllRequests', () {
    test('should return all requests successfully', () async {
      // Arrange
      final requestsData = [
        {
          'id': 1,
          'serviceType': 'PLUMBING',
          'description': 'Fix leaky faucet',
          'urgency': 'HIGH',
          'budget': 100.0,
          'status': 'PENDING',
          'createdAt': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'serviceType': 'ELECTRICAL',
          'description': 'Fix power outlet',
          'urgency': 'MEDIUM',
          'budget': 150.0,
          'status': 'COMPLETED',
          'createdAt': DateTime.now().toIso8601String(),
        },
      ];

      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
      )).thenAnswer((_) async => http.Response(jsonEncode(requestsData), 200));

      // Act
      final result = await requestService.getAllRequests(testToken);

      // Assert
      expect(result, isA<List<Request>>());
      expect(result.length, equals(2));
      expect(result[0].serviceType, equals('PLUMBING'));
      expect(result[1].serviceType, equals('ELECTRICAL'));
    });

    test('should throw exception when fetching all requests fails', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/requests'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(() => requestService.getAllRequests(testToken), throwsException);
    });
  });

  group('getCompletedRequests', () {
    test('should return completed requests successfully', () async {
      // Arrange
      final requestsData = [
        {
          'id': 1,
          'serviceType': 'PLUMBING',
          'description': 'Fix leaky faucet',
          'urgency': 'HIGH',
          'budget': 100.0,
          'status': 'COMPLETED',
          'createdAt': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'serviceType': 'ELECTRICAL',
          'description': 'Fix power outlet',
          'urgency': 'MEDIUM',
          'budget': 150.0,
          'status': 'COMPLETED',
          'createdAt': DateTime.now().toIso8601String(),
        },
      ];

      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/requests/completed-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
      )).thenAnswer((_) async => http.Response(jsonEncode(requestsData), 200));

      // Act
      final result = await requestService.getCompletedRequests(testToken);

      // Assert
      expect(result, isA<List<Request>>());
      expect(result.length, equals(2));
      expect(result[0].status, equals('COMPLETED'));
      expect(result[1].status, equals('COMPLETED'));
    });

    test('should throw exception when fetching completed requests fails', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/requests/completed-requests'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(() => requestService.getCompletedRequests(testToken), throwsException);
    });
  });
} 