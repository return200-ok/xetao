import '../../domain/entities/vehicle.dart' as domain;
import '../database/app_database.dart' as db;

extension VehicleModel on domain.Vehicle {
  db.Vehicle toData() {
    return db.Vehicle(
      id: id,
      name: name,
      brand: brand,
      model: model,
      year: year,
      currentMileage: currentMileage,
      lastMaintenanceDate: lastMaintenanceDate,
      lastMaintenanceMileage: lastMaintenanceMileage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static domain.Vehicle fromData(db.Vehicle data) {
    return domain.Vehicle(
      id: data.id,
      name: data.name,
      brand: data.brand,
      model: data.model,
      year: data.year,
      currentMileage: data.currentMileage,
      lastMaintenanceDate: data.lastMaintenanceDate,
      lastMaintenanceMileage: data.lastMaintenanceMileage,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}

