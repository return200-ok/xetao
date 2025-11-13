import 'package:drift/drift.dart';
import '../../domain/entities/maintenance.dart' as domain;
import '../../domain/entities/maintenance_type.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../database/app_database.dart';
import '../models/maintenance_model.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final AppDatabase _database;

  MaintenanceRepositoryImpl(this._database);

  @override
  Future<List<domain.Maintenance>> getMaintenancesByVehicle(String vehicleId) async {
    final query = _database.select(_database.maintenances)
      ..where((tbl) => tbl.vehicleId.equals(vehicleId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    final data = await query.get();
    return data.map((d) => MaintenanceModel.fromData(d)).toList();
  }

  @override
  Future<domain.Maintenance?> getMaintenanceById(String id) async {
    final query = _database.select(_database.maintenances)
      ..where((tbl) => tbl.id.equals(id));
    final data = await query.getSingleOrNull();
    return data != null ? MaintenanceModel.fromData(data) : null;
  }

  @override
  Future<domain.Maintenance> createMaintenance(domain.Maintenance maintenance) async {
    await _database
        .into(_database.maintenances)
        .insert(maintenance.toData());
    return maintenance;
  }

  @override
  Future<domain.Maintenance> updateMaintenance(domain.Maintenance maintenance) async {
    await (_database.update(_database.maintenances)
          ..where((tbl) => tbl.id.equals(maintenance.id)))
        .write(maintenance.toData());
    return maintenance;
  }

  @override
  Future<void> deleteMaintenance(String id) async {
    await (_database.delete(_database.maintenances)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<domain.Maintenance?> getLastMaintenance(
    String vehicleId,
    MaintenanceType type,
  ) async {
    final query = _database.select(_database.maintenances)
      ..where((tbl) =>
          tbl.vehicleId.equals(vehicleId) & tbl.type.equals(type.index))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
      ..limit(1);
    final data = await query.getSingleOrNull();
    return data != null ? MaintenanceModel.fromData(data) : null;
  }
}

