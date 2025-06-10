import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/services/user_service.dart';
import '../../core/services/request_service.dart';
import '../../core/models/request.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  final _userService = UserService();
  final _requestService = RequestService();

  @override
  FutureOr<Map<String, dynamic>> build() async {
    return _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final profile = await _userService.getUserProfile();
    final requests = await _requestService.getMyRequests();
    return {
      'profile': profile,
      'recentRequests': requests.take(3).toList(),
    };
  }

  Future<void> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String cbeAccount,
    required String paypalAccount,
    required String telebirrAccount,
    required String awashAccount,
  }) async {
    try {
      state = const AsyncValue.loading();
      await _userService.updateProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        cbeAccount: cbeAccount,
        paypalAccount: paypalAccount,
        telebirrAccount: telebirrAccount,
        awashAccount: awashAccount,
      );
      state = await AsyncValue.guard(() => _fetchProfileData());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfileData());
  }
} 