import '../../domain/entities/maintenance.dart' as domain;
import '../../domain/entities/maintenance_type.dart';
import '../database/app_database.dart' as db;

extension MaintenanceModel on domain.Maintenance {
  db.Maintenance toData() {
    return db.Maintenance(
      id: id,
      vehicleId: vehicleId,
      type: type.index,
      date: date,
      mileage: mileage,
      cost: cost,
      notes: notes,
      createdAt: createdAt,
    );
  }

  static domain.Maintenance fromData(db.Maintenance data) {
    return domain.Maintenance(
      id: data.id,
      vehicleId: data.vehicleId,
      type: MaintenanceType.values[data.type],
      date: data.date,
      mileage: data.mileage,
      cost: data.cost,
      notes: data.notes,
      createdAt: data.createdAt,
    );
  }
}

