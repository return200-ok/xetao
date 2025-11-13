import '../../entities/vehicle.dart';
import '../../repositories/vehicle_repository.dart';
import '../../../core/utils/result.dart';

class GetVehicle {
  final VehicleRepository _repository;

  GetVehicle(this._repository);

  Future<Result<Vehicle?>> call() async {
    try {
      final vehicle = await _repository.getVehicle();
      return Success(vehicle);
    } catch (e) {
      return Failure('Không thể lấy thông tin xe: ${e.toString()}');
    }
  }
}

