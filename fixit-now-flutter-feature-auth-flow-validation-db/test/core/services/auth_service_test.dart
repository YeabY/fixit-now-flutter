import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fixit_now/core/services/auth_service.dart';
import 'package:fixit_now/core/models/user.dart';
import 'package:fixit_now/core/config/api_config.dart';

// Generate mock class
@GenerateMocks([http.Client])
import 'auth_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late AuthService authService;

  setUp(() {
    mockClient = MockClient();
    authService = AuthService(mockClient); // ✅ inject mock client here
  });

  group('AuthService', () {
    const testToken = 'test_token';
    final testUser = User(
      name: 'Test User',
      email: 'test@example.com',
      phone: '1234567890',
      gender: Gender.MALE,
      role: Role.REQUESTER,
    );

    test('login should return token on successful login', () async {
      // Arrange
      final responseData = {'access_token': testToken};
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': 'testuser',
          'password': 'password123',
        }),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseData), 200));

      // Act
      final result = await authService.login('testuser', 'password123');

      // Assert
      expect(result['access_token'], equals(testToken));
    });

    test('login should throw exception on invalid credentials', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': 'testuser',
          'password': 'wrongpassword',
        }),
      )).thenAnswer((_) async => http.Response(
        jsonEncode({'message': 'Invalid credentials'}),
        401,
      ));

      // Act & Assert
      expect(() => authService.login('testuser', 'wrongpassword'), throwsException);
    });

    test('register should create new user successfully', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testUser.toJson()),
      )).thenAnswer((_) async => http.Response(
        jsonEncode({'message': 'User registered successfully'}),
        201,
      ));

      // Act
      await authService.register(testUser);

      // Assert
      verify(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testUser.toJson()),
      )).called(1);
    });

    test('getProfile should return user profile', () async {
      // Arrange
      final profileData = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '1234567890',
        'gender': 'MALE',
        'role': 'REQUESTER',
      };

      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
      )).thenAnswer((_) async => http.Response(jsonEncode(profileData), 200));

      // Act
      final user = await authService.getProfile(testToken);

      // Assert
      expect(user.name, equals('Test User'));
      expect(user.email, equals('test@example.com'));
      expect(user.phone, equals('1234567890'));
      expect(user.gender, equals(Gender.MALE));
      expect(user.role, equals(Role.REQUESTER));
    });

    test('logout should clear session', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
      )).thenAnswer((_) async => http.Response(
        jsonEncode({'message': 'Logged out successfully'}),
        200,
      ));

      // Act
      await authService.logout(testToken);

      // Assert
      verify(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
      )).called(1);
    });

    test('should handle network errors gracefully', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': 'testuser',
          'password': 'password123',
        }),
      )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => authService.login('testuser', 'password123'), throwsException);
    });
  });
}
