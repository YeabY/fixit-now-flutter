import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/provider_request_service.dart';
import '../../core/models/request.dart';

final myJobsProvider = StateNotifierProvider<MyJobsNotifier, AsyncValue<List<Request>>>((ref) {
  return MyJobsNotifier(ProviderRequestService());
});

class MyJobsNotifier extends StateNotifier<AsyncValue<List<Request>>> {
  final ProviderRequestService _service;
  bool _showCompleted = false;

  MyJobsNotifier(this._service) : super(const AsyncValue.loading()) {
    loadJobs();
  }

  bool get showCompleted => _showCompleted;

  Future<void> loadJobs() async {
    try {
      List<Request> jobs;
      if (_showCompleted) {
        jobs = await _service.getProviderCompletedRequests();
      } else {
        jobs = await _service.getProviderAcceptedRequests();
      }
      state = AsyncValue.data(jobs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void toggleJobs(bool showCompleted) {
    _showCompleted = showCompleted;
    loadJobs();
  }
} 