import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../data/repositories/maintenance_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../data/repositories/reminder_repository_impl.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/repositories/reminder_repository.dart';
import 'database_provider.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return VehicleRepositoryImpl(database);
});

final maintenanceRepositoryProvider =
    Provider<MaintenanceRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return MaintenanceRepositoryImpl(database);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ExpenseRepositoryImpl(database);
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return AppointmentRepositoryImpl(database);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ReminderRepositoryImpl(database);
});

