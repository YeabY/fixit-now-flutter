import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/services/request_service.dart';
import '../../core/services/token_service.dart';
import '../../core/models/request.dart';

part 'request_provider.g.dart';

@riverpod
class RequestNotifier extends _$RequestNotifier {
  final RequestService _requestService;
  final TokenService _tokenService;
  String _selectedFilter = 'all';

  RequestNotifier({
    RequestService? requestService,
    TokenService? tokenService,
  })  : _requestService = requestService ?? RequestService(),
        _tokenService = tokenService ?? TokenService();

  String get selectedFilter => _selectedFilter;

  @override
  FutureOr<List<Request>> build() async {
    return _fetchRequests(_selectedFilter);
  }

  Future<List<Request>> _fetchRequests(String filter) async {
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    List<Request> requests;
    switch (filter) {
      case 'completed':
        requests = await _requestService.getCompletedRequests(token);
        break;
      case 'rejected':
        requests = await _requestService.getRejectedRequests(token);
        break;
      default:
        requests = await _requestService.getAllRequests(token);
    }

    return requests;
  }

  Future<void> setFilter(String filter) async {
    _selectedFilter = filter;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRequests(filter));
  }
} 