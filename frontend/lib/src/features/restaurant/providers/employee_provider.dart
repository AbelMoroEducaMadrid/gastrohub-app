import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/models/user.dart';
import 'package:gastrohub_app/src/features/restaurant/services/employee_service.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class EmployeeNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final EmployeeService _employeeService;
  final String _token;
  final Ref _ref;

  EmployeeNotifier(this._employeeService, this._token, this._ref)
      : super(const AsyncValue.loading()) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      state = const AsyncValue.loading();
      final employees = await _employeeService.getRestaurantEmployees(_token);
      state = AsyncValue.data(employees);
    } catch (e, stack) {
      AppLogger.error('Failed to load employees: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateEmployeeRole(int userId, String roleName) async {
    try {
      await _employeeService.updateEmployeeRole(_token, userId, roleName);
      final employees = state.value ?? [];
      final updatedEmployees = employees.map((emp) {
        if (emp.id == userId) {
          return emp.copyWith(role: roleName);
        }
        return emp;
      }).toList();
      state = AsyncValue.data(updatedEmployees);
    } catch (e) {
      AppLogger.error('Failed to update employee role: $e');
    }
  }

  Future<void> kickEmployee(int userId) async {
    try {
      await _employeeService.kickEmployee(_token, userId);
      final employees = state.value ?? [];
      final updatedEmployees =
          employees.where((emp) => emp.id != userId).toList();
      state = AsyncValue.data(updatedEmployees);
    } catch (e) {
      AppLogger.error('Failed to kick employee: $e');
    }
  }
}

final employeeServiceProvider = Provider<EmployeeService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return EmployeeService(baseUrl: baseUrl);
});

final employeeNotifierProvider =
    StateNotifierProvider<EmployeeNotifier, AsyncValue<List<User>>>((ref) {
  final employeeService = ref.watch(employeeServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return EmployeeNotifier(employeeService, token, ref);
});
