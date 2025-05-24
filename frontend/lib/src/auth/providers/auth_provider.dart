import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gastrohub_app/src/auth/exception/api_exception.dart';
import 'package:gastrohub_app/src/auth/models/user.dart';
import 'package:gastrohub_app/src/auth/service/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final String? errorTitle;
  final bool registrationSuccess;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.errorTitle,
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
        final user = await _authService.getUserData(token);
        state = AuthState(user: user, token: token);
      } else {
        throw ApiException('Error', 'No se recibió token');
      }
    } catch (e) {
      if (e is ApiException) {
        state = AuthState(error: e.message, errorTitle: e.title);
        print('Estado actualizado con error: ${e.message}');
      } else {
        state = AuthState(error: e.toString());
      }
    }
  }

  Future<void> register(
      String name, String email, String password, String phone) async {
    state = AuthState(isLoading: true);
    try {
      await _authService.register(name, email, password, phone);
      state = AuthState(registrationSuccess: true);
    } catch (e) {
      if (e is ApiException) {
        state = AuthState(error: e.message, errorTitle: e.title);
      } else {
        state = AuthState(error: e.toString());
      }
    }
  }

  Future<void> joinRestaurant(String invitationCode) async {
    state = AuthState(isLoading: true, user: state.user, token: state.token);
    try {
      final token = state.token;
      if (token == null) {
        throw ApiException('Error', 'No hay token de autenticación');
      }

      final response = await _authService.joinRestaurant(token, invitationCode);
      final restaurantId = response['restaurantId'];
      final restaurantName = response['restaurantName'];

      final updatedUser = state.user!.copyWith(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
      );

      state = AuthState(user: updatedUser, token: token);
    } catch (e) {
      if (e is ApiException) {
        state = AuthState(
            error: e.message,
            errorTitle: e.title,
            user: state.user,
            token: state.token);
      } else {
        state = AuthState(
            error: e.toString(), user: state.user, token: state.token);
      }
    }
  }

  void clearError() {
    state = AuthState(
      user: state.user,
      token: state.token,
      isLoading: state.isLoading,
      registrationSuccess: state.registrationSuccess,
    );
    print('Error limpiado');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
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
