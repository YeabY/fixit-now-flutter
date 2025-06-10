import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  final _userService = UserService();

  @override
  FutureOr<List<dynamic>> build() async {
    return _userService.getRequesters();
  }

  Future<void> searchUsers(String query) async {
    try {
      state = const AsyncValue.loading();
      if (query.isEmpty) {
        state = await AsyncValue.guard(() => _userService.getRequesters());
      } else {
        state = await AsyncValue.guard(() => _userService.searchRequesterByName(query));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      state = const AsyncValue.loading();
      await _userService.createRequester(userData);
      state = await AsyncValue.guard(() => _userService.getRequesters());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      state = const AsyncValue.loading();
      await _userService.updateRequester(id, userData);
      state = await AsyncValue.guard(() => _userService.getRequesters());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      state = const AsyncValue.loading();
      await _userService.deleteRequester(id);
      state = await AsyncValue.guard(() => _userService.getRequesters());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 