import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fixit_now/core/services/user_service.dart';
import 'package:fixit_now/core/config/api_config.dart';
import 'package:fixit_now/core/services/token_service.dart';

@GenerateMocks([http.Client, TokenService])
import 'user_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late MockTokenService mockTokenService;
  late UserService userService;
  const testToken = 'test_token';

  setUp(() {
    mockClient = MockClient();
    mockTokenService = MockTokenService();
    userService = UserService(
      client: mockClient,
      tokenService: mockTokenService,
    );
    when(mockTokenService.getToken()).thenAnswer((_) async => testToken);
  });

  group('getRequesters', () {
    test('returns list of requesters on success', () async {
      final data = [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'},
      ];
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/requesters'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(data), 200));
      final result = await userService.getRequesters();
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
    });
    test('throws on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/requesters'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.getRequesters(), throwsException);
    });
  });

  group('searchRequesterByName', () {
    test('returns list on success', () async {
      final data = [
        {'id': 1, 'name': 'Alice'},
      ];
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/search-requester?name=Alice'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(data), 200));
      final result = await userService.searchRequesterByName('Alice');
      expect(result, isA<List<dynamic>>());
      expect(result.first['name'], 'Alice');
    });
    test('throws on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/search-requester?name=Alice'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.searchRequesterByName('Alice'), throwsException);
    });
  });

  group('createRequester', () {
    test('returns created requester on success', () async {
      final userData = {'name': 'Alice', 'email': 'alice@example.com'};
      final responseData = {'id': 1, 'name': 'Alice'};
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/users'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseData), 201));
      final result = await userService.createRequester(userData);
      expect(result['id'], 1);
      expect(result['name'], 'Alice');
    });
    test('throws on error', () async {
      final userData = {'name': 'Alice'};
      when(mockClient.post(
        Uri.parse('${ApiConfig.baseUrl}/users'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.createRequester(userData), throwsException);
    });
  });

  group('updateRequester', () {
    test('returns updated requester on success', () async {
      final userData = {'name': 'Alice'};
      final responseData = {'id': 1, 'name': 'Alice'};
      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseData), 200));
      final result = await userService.updateRequester(1, userData);
      expect(result['id'], 1);
      expect(result['name'], 'Alice');
    });
    test('throws on error', () async {
      final userData = {'name': 'Alice'};
      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.updateRequester(1, userData), throwsException);
    });
  });

  group('deleteRequester', () {
    test('completes on success', () async {
      when(mockClient.delete(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 200));
      await userService.deleteRequester(1);
      verify(mockClient.delete(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
      )).called(1);
    });
    test('throws on error', () async {
      when(mockClient.delete(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.deleteRequester(1), throwsException);
    });
  });

  group('getUserProfile', () {
    test('returns profile on success', () async {
      final data = {'id': 1, 'name': 'Alice'};
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/profile'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(data), 200));
      final result = await userService.getUserProfile();
      expect(result['id'], 1);
      expect(result['name'], 'Alice');
    });
    test('throws on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/profile'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.getUserProfile(), throwsException);
    });
  });

  group('updateProfile', () {
    test('returns updated profile on success', () async {
      final responseData = {'id': 1, 'name': 'Alice'};
      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseData), 200));
      final result = await userService.updateProfile(userId: 1, name: 'Alice');
      expect(result['id'], 1);
      expect(result['name'], 'Alice');
    });
    test('throws on error', () async {
      when(mockClient.patch(
        Uri.parse('${ApiConfig.baseUrl}/users/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.updateProfile(userId: 1, name: 'Alice'), throwsException);
    });
  });

  group('getProviders', () {
    test('returns list of providers on success', () async {
      final data = [
        {'id': 1, 'name': 'Provider1'},
        {'id': 2, 'name': 'Provider2'},
      ];
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/providers'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(data), 200));
      final result = await userService.getProviders();
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
    });
    test('throws on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/providers'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.getProviders(), throwsException);
    });
  });

  group('searchProviderByName', () {
    test('returns list on success', () async {
      final data = [
        {'id': 1, 'name': 'Provider1'},
      ];
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/search-provider?name=Provider1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(data), 200));
      final result = await userService.searchProviderByName('Provider1');
      expect(result, isA<List<dynamic>>());
      expect(result.first['name'], 'Provider1');
    });
    test('throws on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/search-provider?name=Provider1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('error', 400));
      expect(userService.searchProviderByName('Provider1'), throwsException);
    });
  });
} 