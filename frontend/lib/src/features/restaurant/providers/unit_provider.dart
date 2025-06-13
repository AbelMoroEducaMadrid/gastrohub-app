import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/unit_service.dart';
import 'package:gastrohub_app/src/features/restaurant/models/unit.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UnitNotifier extends StateNotifier<List<Unit>> {
  final UnitService _unitService;
  final String _token;

  UnitNotifier(this._unitService, this._token) : super([]);

  Future<void> loadUnits() async {
    try {
      state = await _unitService.getAllUnits(_token);
    } catch (e) {
      AppLogger.error('Failed to load units: $e');
    }
  }
}

final unitNotifierProvider =
    StateNotifierProvider<UnitNotifier, List<Unit>>((ref) {
  final unitService = ref.watch(unitServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return UnitNotifier(unitService, token);
});

final unitServiceProvider = Provider<UnitService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return UnitService(baseUrl: baseUrl);
});