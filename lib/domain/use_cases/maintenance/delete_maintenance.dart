import '../../repositories/maintenance_repository.dart';
import '../../../core/utils/result.dart';

class DeleteMaintenance {
  final MaintenanceRepository _repository;

  DeleteMaintenance(this._repository);

  Future<Result<void>> call(String id) async {
    try {
      await _repository.deleteMaintenance(id);
      return const Success(null);
    } catch (e) {
      return Failure('Không thể xóa bảo dưỡng: ${e.toString()}');
    }
  }
}
