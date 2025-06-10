import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/provider_request_service.dart';

final performanceProvider = StateNotifierProvider<PerformanceNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return PerformanceNotifier(ProviderRequestService());
});

class PerformanceNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ProviderRequestService _userService;

  PerformanceNotifier(this._userService) : super(const AsyncValue.loading()) {
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final completedRequests = await _userService.getProviderCompletedRequestCount();
      final averageRating = await _userService.getProviderAverageRating();
      final totalBudget = await _userService.getProviderTotalBudget();

      state = AsyncValue.data({
        'completedRequests': completedRequests,
        'averageRating': averageRating,
        'totalBudget': totalBudget,
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // This method will be called when a request is completed
  Future<void> updateStats() async {
    // Optimistically update the UI with current values
    final currentState = state;
    if (currentState.hasValue) {
      final currentData = currentState.value!;
      state = AsyncValue.data({
        'completedRequests': currentData['completedRequests'],
        'averageRating': currentData['averageRating'],
        'totalBudget': currentData['totalBudget'],
      });
    }

    // Refresh the data in the background
    loadStats();
  }
} 