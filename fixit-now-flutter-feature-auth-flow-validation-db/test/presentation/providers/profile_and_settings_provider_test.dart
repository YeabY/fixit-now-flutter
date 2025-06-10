import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fixit_now/core/services/user_service.dart';
import 'package:fixit_now/presentation/providers/profile_and_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@GenerateMocks([UserService])
import 'profile_and_settings_provider_test.mocks.dart';

void main() {
  late MockUserService mockUserService;
  late ProviderContainer container;

  setUp(() {
    mockUserService = MockUserService();
    container = ProviderContainer(
      overrides: [
        profileAndSettingsProvider.overrideWith(
          (ref) => ProfileAndSettingsNotifier(mockUserService),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('loadProfile loads profile data', () async {
    final profile = <String, dynamic>{'id': 1, 'name': 'Test User'};
    when(mockUserService.getUserProfile()).thenAnswer((_) async => profile);
    final notifier = container.read(profileAndSettingsProvider.notifier);
    await notifier.loadProfile();
    final state = container.read(profileAndSettingsProvider);
    expect(state.value, profile);
  });

  test('loadProfile handles errors', () async {
    when(mockUserService.getUserProfile()).thenThrow(Exception('Error'));
    final notifier = container.read(profileAndSettingsProvider.notifier);
    await notifier.loadProfile();
    final state = container.read(profileAndSettingsProvider);
    expect(state, isA<AsyncError>());
  });

  test('updateProfile updates profile and reloads data', () async {
    final profile = <String, dynamic>{'id': 1, 'name': 'Test User'};
    when(mockUserService.getUserProfile()).thenAnswer((_) async => profile);
    when(mockUserService.updateProfile(
      userId: 1,
      name: 'Updated Name',
      email: 'test@example.com',
      phone: '1234567890',
      gender: 'Male',
      serviceType: 'General',
      cbeAccount: '123',
      awashAccount: '456',
      paypalAccount: 'test@paypal.com',
      telebirrAccount: '789',
    )).thenAnswer((_) async => profile);
    final notifier = container.read(profileAndSettingsProvider.notifier);
    await notifier.updateProfile(
      userId: 1,
      name: 'Updated Name',
      email: 'test@example.com',
      phone: '1234567890',
      gender: 'Male',
      serviceType: 'General',
      cbeAccount: '123',
      awashAccount: '456',
      paypalAccount: 'test@paypal.com',
      telebirrAccount: '789',
    );
    final state = container.read(profileAndSettingsProvider);
    expect(state.value, profile);
  });

  test('updateProfile handles errors', () async {
    when(mockUserService.updateProfile(
      userId: 1,
      name: 'Updated Name',
      email: 'test@example.com',
      phone: '1234567890',
      gender: 'Male',
      serviceType: 'General',
      cbeAccount: '123',
      awashAccount: '456',
      paypalAccount: 'test@paypal.com',
      telebirrAccount: '789',
    )).thenThrow(Exception('Error'));
    final notifier = container.read(profileAndSettingsProvider.notifier);
    await notifier.updateProfile(
      userId: 1,
      name: 'Updated Name',
      email: 'test@example.com',
      phone: '1234567890',
      gender: 'Male',
      serviceType: 'General',
      cbeAccount: '123',
      awashAccount: '456',
      paypalAccount: 'test@paypal.com',
      telebirrAccount: '789',
    );
    final state = container.read(profileAndSettingsProvider);
    expect(state, isA<AsyncError>());
  });
} 