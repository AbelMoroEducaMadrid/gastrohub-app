import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_dropdown_field.dart';
import 'package:gastrohub_app/src/features/auth/models/user.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/employee_provider.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  final List<String> _roles = [
    'ROLE_MANAGER',
    'ROLE_WAITER',
    'ROLE_OWNER',
    'ROLE_COOK',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(employeeNotifierProvider.notifier).loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeeNotifierProvider);

    return Scaffold(
      body: employeesAsync.when(
        data: (employees) => employees.isEmpty
            ? const Center(child: Text('No hay empleados en el restaurante'))
            : ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.person, color: Colors.black),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              employee.name.toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),                      
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email_outlined,
                                  color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  employee.email,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  employee.phone,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.badge_outlined,
                                  color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  employee.role,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.badge_outlined,
                                color: Colors.black),
                            onPressed: () => _showRoleDialog(context, employee),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            onPressed: () =>
                                _showKickConfirmationDialog(context, employee),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, User employee) {
    String? selectedRole = employee.role;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Rol'),
        content: CustomDropdownField<String>(
          label: 'Rol',
          value: selectedRole,
          items: _roles.map((role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (value) {
            selectedRole = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (selectedRole != null) {
                ref
                    .read(employeeNotifierProvider.notifier)
                    .updateEmployeeRole(employee.id, selectedRole!);
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showKickConfirmationDialog(BuildContext context, User employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expulsar Empleado'),
        content:
            Text('¿Estás seguro de que quieres expulsar a ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(employeeNotifierProvider.notifier)
                  .kickEmployee(employee.id);
              Navigator.pop(context);
            },
            child: const Text('Expulsar'),
          ),
        ],
      ),
    );
  }
}
