import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<Vehicle?> getVehicle();
  Future<Vehicle> createVehicle(Vehicle vehicle);
  Future<Vehicle> updateVehicle(Vehicle vehicle);
  Future<void> deleteVehicle(String id);
  Future<void> updateMileage(String vehicleId, int mileage);
}

