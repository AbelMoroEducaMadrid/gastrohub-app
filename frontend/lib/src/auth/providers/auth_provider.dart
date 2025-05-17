import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gastrohub_app/src/auth/models/user.dart';
import 'package:gastrohub_app/src/auth/service/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final bool registrationSuccess;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.registrationSuccess = false,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;

  AuthNotifier(this._authService, this._secureStorage) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final token = await _authService.login(email, password);
      if (token != null) {
        await _secureStorage.write(key: 'jwt_token', value: token);
        print('Token almacenado: $token');
        // Obtener datos reales del usuario
        final user = await _authService.getUserData(token);
        state = AuthState(user: user, token: token);
      } else {
        throw Exception('No se recibió token');
      }
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      state = AuthState(registrationSuccess: true);
    } catch (e) {
      state = AuthState(error: 'Error al registrar: $e');
    }
  }

  void logout() {
    state = AuthState();
  }

  void resetRegistration() {
    state = AuthState();
  }
}

// Provider para AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return AuthService(baseUrl: baseUrl);
});

// Provider para FlutterSecureStorage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Provider para AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthNotifier(authService, secureStorage);
});
