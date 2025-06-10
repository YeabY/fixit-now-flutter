import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'job_request_provider.dart';
import 'performance_provider.dart';
import 'my_requests_provider.dart';

final providerCoordinator = Provider((ref) => ProviderCoordinator(ref));

class ProviderCoordinator {
  final Ref _ref;

  ProviderCoordinator(this._ref);

  Future<void> onRequestAccepted(int requestId) async {
    // Update job requests
    await _ref.read(jobRequestProvider.notifier).acceptRequest(requestId);
    
    // Refresh performance stats
    await _ref.read(performanceProvider.notifier).loadStats();
  }

  Future<void> onRequestCompleted() async {
    // Refresh both providers
    await Future.wait([
      _ref.read(myRequestsNotifierProvider.notifier).refreshRequests(),
      _ref.read(performanceProvider.notifier).loadStats(),
    ]);
  }
} 