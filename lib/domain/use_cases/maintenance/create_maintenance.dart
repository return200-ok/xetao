import 'package:uuid/uuid.dart';
import '../../entities/maintenance.dart';
import '../../entities/maintenance_type.dart';
import '../../repositories/maintenance_repository.dart';
import '../../repositories/vehicle_repository.dart';
import '../../../core/utils/result.dart';

class CreateMaintenance {
  final MaintenanceRepository _maintenanceRepository;
  final VehicleRepository _vehicleRepository;
  final _uuid = const Uuid();

  CreateMaintenance(
    this._maintenanceRepository,
    this._vehicleRepository,
  );

  Future<Result<Maintenance>> call({
    required String vehicleId,
    required MaintenanceType type,
    required DateTime date,
    required int mileage,
    double? cost,
    String? notes,
  }) async {
    try {
      if (mileage < 0) {
        return const Failure('Số km không hợp lệ');
      }

      final maintenance = Maintenance(
        id: _uuid.v4(),
        vehicleId: vehicleId,
        type: type,
        date: date,
        mileage: mileage,
        cost: cost,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _maintenanceRepository.createMaintenance(maintenance);

      // Cập nhật thông tin xe
      final vehicle = await _vehicleRepository.getVehicle();
      if (vehicle != null) {
        await _vehicleRepository.updateVehicle(
          vehicle.copyWith(
            lastMaintenanceDate: date,
            lastMaintenanceMileage: mileage,
            updatedAt: DateTime.now(),
          ),
        );
      }

      return Success(maintenance);
    } catch (e) {
      return Failure('Không thể tạo bảo dưỡng: ${e.toString()}');
    }
  }
}

