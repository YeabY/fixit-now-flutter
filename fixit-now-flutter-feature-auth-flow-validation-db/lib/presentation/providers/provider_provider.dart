import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_provider.g.dart';

@riverpod
class ServiceProviderNotifier extends _$ServiceProviderNotifier {
  final _userService = UserService();

  @override
  FutureOr<List<dynamic>> build() async {
    return _userService.getProviders();
  }

  Future<void> searchProviders(String query) async {
    try {
      state = const AsyncValue.loading();
      if (query.isEmpty) {
        state = await AsyncValue.guard(() => _userService.getProviders());
      } else {
        state = await AsyncValue.guard(() => _userService.searchProviderByName(query));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createProvider(Map<String, dynamic> providerData) async {
    try {
      state = const AsyncValue.loading();
      await _userService.createProvider(providerData);
      state = await AsyncValue.guard(() => _userService.getProviders());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProvider(int id, Map<String, dynamic> providerData) async {
    try {
      state = const AsyncValue.loading();
      await _userService.updateProvider(id, providerData);
      state = await AsyncValue.guard(() => _userService.getProviders());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProvider(int id) async {
    try {
      state = const AsyncValue.loading();
      await _userService.deleteProvider(id);
      state = await AsyncValue.guard(() => _userService.getProviders());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 