import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/model/auth_state.dart';
import 'package:woo_commerce_test/sevices/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final user = await _authService.login(email, password);
      state = AuthState.authenticated(user!);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> singup(String email, String username, String password) async {
    state = AuthState.loading();
    try {
      final user = await _authService.signup(email, username, password);
      state = AuthState.authenticated(user!);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

//authservice provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

//authnotifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);
