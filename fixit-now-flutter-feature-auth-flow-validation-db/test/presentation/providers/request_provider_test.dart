import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fixit_now/core/services/request_service.dart';
import 'package:fixit_now/core/services/token_service.dart';
import 'package:fixit_now/core/models/request.dart';
import 'package:fixit_now/presentation/providers/request_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@GenerateMocks([RequestService, TokenService])
import 'request_provider_test.mocks.dart';

void main() {
  late MockRequestService mockRequestService;
  late MockTokenService mockTokenService;
  late ProviderContainer container;
  const testToken = 'test_token';

  setUp(() {
    mockRequestService = MockRequestService();
    mockTokenService = MockTokenService();
    container = ProviderContainer(
      overrides: [
        requestNotifierProvider.overrideWith(() => RequestNotifier(
              requestService: mockRequestService,
              tokenService: mockTokenService,
            )),
      ],
    );
    when(mockTokenService.getToken()).thenAnswer((_) async => testToken);
  });

  tearDown(() {
    container.dispose();
  });

  test('fetches requests on initial build', () async {
    final requests = [
      Request(id: 1, serviceType: 'CLEANING', description: 'Test', urgency: 'HIGH', budget: 100.0, status: 'PENDING', createdAt: DateTime.now()),
    ];
    when(mockRequestService.getAllRequests(testToken)).thenAnswer((_) async => requests);
    final result = await container.read(requestNotifierProvider.future);
    expect(result, requests);
  });

  test('throws on token not found', () async {
    when(mockTokenService.getToken()).thenAnswer((_) async => null);
    expect(container.read(requestNotifierProvider.future), throwsException);
  });

  test('setFilter updates filter and fetches completed requests', () async {
    final requests = [
      Request(id: 1, serviceType: 'CLEANING', description: 'Test', urgency: 'HIGH', budget: 100.0, status: 'COMPLETED', createdAt: DateTime.now()),
    ];
    when(mockRequestService.getCompletedRequests(testToken)).thenAnswer((_) async => requests);
    final notifier = container.read(requestNotifierProvider.notifier);
    await notifier.setFilter('completed');
    final result = await container.read(requestNotifierProvider.future);
    expect(result, requests);
    expect(notifier.selectedFilter, 'completed');
  });

  test('setFilter fetches rejected requests', () async {
    final requests = [
      Request(id: 1, serviceType: 'CLEANING', description: 'Test', urgency: 'HIGH', budget: 100.0, status: 'REJECTED', createdAt: DateTime.now()),
    ];
    when(mockRequestService.getRejectedRequests(testToken)).thenAnswer((_) async => requests);
    final notifier = container.read(requestNotifierProvider.notifier);
    await notifier.setFilter('rejected');
    final result = await container.read(requestNotifierProvider.future);
    expect(result, requests);
    expect(notifier.selectedFilter, 'rejected');
  });

  test('setFilter fetches all requests by default', () async {
    final requests = [
      Request(id: 1, serviceType: 'CLEANING', description: 'Test', urgency: 'HIGH', budget: 100.0, status: 'PENDING', createdAt: DateTime.now()),
    ];
    when(mockRequestService.getAllRequests(testToken)).thenAnswer((_) async => requests);
    final notifier = container.read(requestNotifierProvider.notifier);
    await notifier.setFilter('all');
    final result = await container.read(requestNotifierProvider.future);
    expect(result, requests);
    expect(notifier.selectedFilter, 'all');
  });
} 