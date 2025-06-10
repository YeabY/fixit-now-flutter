import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/services/service_service.dart';
import '../../core/services/user_service.dart';

part 'recruitment_provider.g.dart';

@riverpod
class RecruitmentNotifier extends _$RecruitmentNotifier {
  final _serviceService = ServiceService();
  final _userService = UserService();

  @override
  FutureOr<Map<String, dynamic>> build() async {
    return _fetchRecruitmentData();
  }

  Future<Map<String, dynamic>> _fetchRecruitmentData() async {
    final services = await _serviceService.findAll();
    final providers = await _userService.getTopRatedProviders();
    final totalProviders = await _userService.getTotalProviders();

    return {
      'trendingServices': services.take(3).toList(),
      'topProviders': providers,
      'totalProviders': totalProviders,
      'averageRating': 4.5, // This could be calculated from actual data if available
    };
  }

  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRecruitmentData());
  }
} 