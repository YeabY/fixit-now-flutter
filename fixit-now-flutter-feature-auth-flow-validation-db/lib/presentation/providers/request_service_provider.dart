import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/request_service.dart';

final requestServiceProvider = Provider((ref) => RequestService());

final requestServiceNotifierProvider = StateNotifierProvider<RequestServiceNotifier, AsyncValue<void>>((ref) {
  final requestService = ref.watch(requestServiceProvider);
  return RequestServiceNotifier(requestService);
});

class RequestServiceNotifier extends StateNotifier<AsyncValue<void>> {
  final RequestService _requestService;

  RequestServiceNotifier(this._requestService) : super(const AsyncValue.data(null));

  Future<void> createRequest({
    required String serviceType,
    required String description,
    required String urgency,
    required double budget,
    DateTime? scheduledDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _requestService.createRequest(
        serviceType: serviceType,
        description: description,
        urgency: urgency,
        budget: budget,
        scheduledDate: scheduledDate,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 