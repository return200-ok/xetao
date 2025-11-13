import '../entities/maintenance.dart';
import '../entities/maintenance_type.dart';

abstract class MaintenanceRepository {
  Future<List<Maintenance>> getMaintenancesByVehicle(String vehicleId);
  Future<Maintenance?> getMaintenanceById(String id);
  Future<Maintenance> createMaintenance(Maintenance maintenance);
  Future<Maintenance> updateMaintenance(Maintenance maintenance);
  Future<void> deleteMaintenance(String id);
  Future<Maintenance?> getLastMaintenance(String vehicleId, MaintenanceType type);
}

