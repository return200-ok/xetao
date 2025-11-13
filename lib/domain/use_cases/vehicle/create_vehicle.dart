import 'package:uuid/uuid.dart';
import '../../entities/vehicle.dart';
import '../../repositories/vehicle_repository.dart';
import '../../../core/utils/result.dart';

class CreateVehicle {
  final VehicleRepository _repository;
  final _uuid = const Uuid();

  CreateVehicle(this._repository);

  Future<Result<Vehicle>> call({
    required String name,
    required String brand,
    required String model,
    required int year,
    required int currentMileage,
    DateTime? lastMaintenanceDate,
    int? lastMaintenanceMileage,
  }) async {
    try {
      final now = DateTime.now();
      final vehicle = Vehicle(
        id: _uuid.v4(),
        name: name,
        brand: brand,
        model: model,
        year: year,
        currentMileage: currentMileage,
        lastMaintenanceDate: lastMaintenanceDate,
        lastMaintenanceMileage: lastMaintenanceMileage,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.createVehicle(vehicle);
      return Success(vehicle);
    } catch (e) {
      return Failure('Không thể tạo thông tin xe: ${e.toString()}');
    }
  }
}

