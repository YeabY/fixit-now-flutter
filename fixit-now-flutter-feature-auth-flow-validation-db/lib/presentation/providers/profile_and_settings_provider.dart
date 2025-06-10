import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/user_service.dart';

final profileAndSettingsProvider = StateNotifierProvider<ProfileAndSettingsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return ProfileAndSettingsNotifier(UserService());
});

class ProfileAndSettingsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final UserService _userService;

  ProfileAndSettingsNotifier(this._userService) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await _userService.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String serviceType,
    required String cbeAccount,
    required String awashAccount,
    required String paypalAccount,
    required String telebirrAccount,
  }) async {
    try {
      await _userService.updateProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        serviceType: serviceType,
        cbeAccount: cbeAccount,
        awashAccount: awashAccount,
        paypalAccount: paypalAccount,
        telebirrAccount: telebirrAccount,
      );
      await loadProfile(); // Reload profile after update
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 