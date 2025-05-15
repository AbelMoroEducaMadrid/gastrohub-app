import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/models/user.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      if (email == "test@example.com" && password == "password123") {
        final user = User(id: 1, name: 'Test User', email: email);
        state = AuthState(user: user);
      } else {
        throw Exception('Credenciales incorrectas');
      }
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      // Simulación de registro exitoso
      final user = User(id: 2, name: name, email: email);
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(error: 'Error al registrar: $e');
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
