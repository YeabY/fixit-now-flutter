import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/services/request_service.dart';
import '../../core/models/request.dart';

part 'my_requests_provider.g.dart';

@riverpod
class MyRequestsNotifier extends _$MyRequestsNotifier {
  final _requestService = RequestService();

  @override
  FutureOr<List<Request>> build() async {
    return _requestService.getMyRequests();
  }

  Future<void> addReview({
    required int requestId,
    required double rating,
    required String review,
  }) async {
    try {
      state = const AsyncValue.loading();
      await _requestService.addReview(
        requestId: requestId,
        rating: rating,
        review: review,
      );
      state = await AsyncValue.guard(() => _requestService.getMyRequests());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateRequestStatus(int requestId, String status) async {
    try {
      state = const AsyncValue.loading();
      await _requestService.updateRequestStatus(requestId, status);
      state = await AsyncValue.guard(() => _requestService.getMyRequests());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshRequests() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _requestService.getMyRequests());
  }
} 