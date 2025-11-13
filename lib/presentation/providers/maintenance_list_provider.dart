import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/maintenance.dart' as domain;
import 'repository_providers.dart';

final maintenanceListProvider =
    FutureProvider.family<List<domain.Maintenance>, String>((ref, vehicleId) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  return await repository.getMaintenancesByVehicle(vehicleId);
});
