import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit_now/core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});