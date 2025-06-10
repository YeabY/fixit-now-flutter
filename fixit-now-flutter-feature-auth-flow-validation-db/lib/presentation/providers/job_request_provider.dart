import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/provider_request_service.dart';
import '../../core/models/request.dart';

final jobRequestProvider = StateNotifierProvider<JobRequestNotifier, AsyncValue<Map<String, List<Request>>>>((ref) {
  return JobRequestNotifier(ProviderRequestService());
});

class JobRequestNotifier extends StateNotifier<AsyncValue<Map<String, List<Request>>>> {
  final ProviderRequestService _service;

  JobRequestNotifier(this._service) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      final unassigned = await _service.getUnassignedRequests();
      final recent = await _service.getProviderRecentRequests();
      state = AsyncValue.data({
        'unassigned': unassigned,
        'recent': recent.take(3).toList(),
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> acceptRequest(int requestId) async {
    try {
      // Optimistically update the UI
      final currentState = state;
      if (currentState.hasValue) {
        final currentData = currentState.value!;
        final updatedUnassigned = currentData['unassigned']!
            .where((request) => request.id != requestId)
            .toList();
        
        state = AsyncValue.data({
          'unassigned': updatedUnassigned,
          'recent': currentData['recent']!,
        });
      }

      // Make the API call
      await _service.acceptRequest(requestId);
      
      // Refresh the data in the background
      loadData();
    } catch (e, stack) {
      // If there's an error, revert to the previous state and show error
      state = AsyncValue.error(e, stack);
    }
  }
} 