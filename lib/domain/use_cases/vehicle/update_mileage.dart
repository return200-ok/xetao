import '../../repositories/vehicle_repository.dart';
import '../../../core/utils/result.dart';

class UpdateMileage {
  final VehicleRepository _repository;

  UpdateMileage(this._repository);

  Future<Result<void>> call({
    required String vehicleId,
    required int mileage,
  }) async {
    try {
      if (mileage < 0) {
        return const Failure('Số km không hợp lệ');
      }

      await _repository.updateMileage(vehicleId, mileage);
      return const Success(null);
    } catch (e) {
      return Failure('Không thể cập nhật số km: ${e.toString()}');
    }
  }
}

