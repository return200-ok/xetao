import 'package:drift/drift.dart';
import '../../domain/entities/vehicle.dart' as domain;
import '../../domain/repositories/vehicle_repository.dart';
import '../database/app_database.dart';
import '../database/app_database.dart' as db;
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final AppDatabase _database;

  VehicleRepositoryImpl(this._database);

  @override
  Future<domain.Vehicle?> getVehicle() async {
    final query = _database.select(_database.vehicles);
    final data = await query.getSingleOrNull();
    return data != null ? VehicleModel.fromData(data) : null;
  }

  @override
  Future<domain.Vehicle> createVehicle(domain.Vehicle vehicle) async {
    await _database.into(_database.vehicles).insert(vehicle.toData());
    return vehicle;
  }

  @override
  Future<domain.Vehicle> updateVehicle(domain.Vehicle vehicle) async {
    await (_database.update(_database.vehicles)
          ..where((tbl) => tbl.id.equals(vehicle.id)))
        .write(vehicle.toData());
    return vehicle;
  }

  @override
  Future<void> deleteVehicle(String id) async {
    await (_database.delete(_database.vehicles)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<void> updateMileage(String vehicleId, int mileage) async {
    await (_database.update(_database.vehicles)
          ..where((tbl) => tbl.id.equals(vehicleId)))
        .write(db.VehiclesCompanion(
      currentMileage: Value(mileage),
      updatedAt: Value(DateTime.now()),
    ));
  }
}

