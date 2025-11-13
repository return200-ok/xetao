import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/maintenance_type.dart';
import '../../domain/use_cases/maintenance/get_maintenance_reminder.dart';
import '../../domain/use_cases/maintenance/create_maintenance.dart';
import '../../domain/use_cases/maintenance/delete_maintenance.dart';
import 'repository_providers.dart';

final maintenanceReminderProvider =
    FutureProvider.family<MaintenanceReminder?, MaintenanceType>((ref, type) async {
  final getReminder = GetMaintenanceReminder(
    ref.watch(maintenanceRepositoryProvider),
    ref.watch(vehicleRepositoryProvider),
  );
  final result = await getReminder(type: type);
  return result.when(
    success: (data) => data,
    failure: (_) => null,
  );
});

final createMaintenanceProvider = Provider<CreateMaintenance>((ref) {
  return CreateMaintenance(
    ref.watch(maintenanceRepositoryProvider),
    ref.watch(vehicleRepositoryProvider),
  );
});

final deleteMaintenanceProvider = Provider<DeleteMaintenance>((ref) {
  return DeleteMaintenance(ref.watch(maintenanceRepositoryProvider));
});
