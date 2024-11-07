class AuthState {
  final bool isLoading;
  final Map<String, dynamic>? user;
  final String? error;

  AuthState({required this.isLoading, this.user, this.error});

  factory AuthState.initial() => AuthState(isLoading: false);
  factory AuthState.loading() => AuthState(isLoading: true);
  factory AuthState.authenticated(Map<String, dynamic> user) =>
      AuthState(isLoading: false, user: user);
  factory AuthState.error(String error) =>
      AuthState(isLoading: false, error: error);
}
