import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/admin_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  final AdminService _adminService = AdminService();

  @override
  FutureOr<Map<String, int>> build() async {
    return _fetchDashboardData();
  }

  Future<Map<String, int>> _fetchDashboardData() async {
    final results = await Future.wait([
      _adminService.getTotalRequesters(),
      _adminService.getTotalProviders(),
      _adminService.getTotalCompleted(),
      _adminService.getTotalRejected(),
      _adminService.getTotalPending(),
    ]);

    final totalRequesters = results[0];
    final totalProviders = results[1];
    final completedRequests = results[2];
    final rejectedRequests = results[3];
    final pendingRequests = results[4];
    final totalRequests = completedRequests + rejectedRequests + pendingRequests;

    return {
      'totalRequesters': totalRequesters,
      'totalProviders': totalProviders,
      'totalRequests': totalRequests,
      'completedRequests': completedRequests,
      'pendingRequests': pendingRequests,
      'rejectedRequests': rejectedRequests,
    };
  }

  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchDashboardData());
  }
} 