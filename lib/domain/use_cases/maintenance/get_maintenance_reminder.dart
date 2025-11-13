import '../../entities/maintenance_type.dart';
import '../../repositories/maintenance_repository.dart';
import '../../repositories/vehicle_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/result.dart';

class MaintenanceReminder {
  final int? nextMileage;
  final DateTime? nextDate;
  final bool isDue;
  final String message;

  MaintenanceReminder({
    this.nextMileage,
    this.nextDate,
    required this.isDue,
    required this.message,
  });
}

class GetMaintenanceReminder {
  final MaintenanceRepository _maintenanceRepository;
  final VehicleRepository _vehicleRepository;

  GetMaintenanceReminder(
    this._maintenanceRepository,
    this._vehicleRepository,
  );

  Future<Result<MaintenanceReminder?>> call({
    required MaintenanceType type,
  }) async {
    try {
      final vehicle = await _vehicleRepository.getVehicle();
      if (vehicle == null) {
        return const Success(null);
      }

      final lastMaintenance = await _maintenanceRepository.getLastMaintenance(
        vehicle.id,
        type,
      );

      final intervalKm = type == MaintenanceType.small
          ? AppConstants.smallMaintenanceInterval
          : AppConstants.largeMaintenanceInterval;

      final intervalMonths = type == MaintenanceType.small
          ? AppConstants.smallMaintenanceMonths
          : AppConstants.largeMaintenanceMonths;

      int? nextMileage;
      DateTime? nextDate;
      bool isDue = false;
      String message = '';

      if (lastMaintenance != null) {
        nextMileage = lastMaintenance.mileage + intervalKm;
        nextDate = lastMaintenance.date.add(Duration(days: intervalMonths * 30));

        final kmRemaining = nextMileage - vehicle.currentMileage;
        final daysRemaining = nextDate.difference(DateTime.now()).inDays;

        if (kmRemaining <= AppConstants.maintenanceReminderKm ||
            daysRemaining <= AppConstants.maintenanceReminderDays) {
          isDue = true;
          if (kmRemaining <= 0 || daysRemaining <= 0) {
            message = 'Đã đến hạn bảo dưỡng ${type.displayName}!';
          } else {
            message =
                'Còn $kmRemaining km hoặc $daysRemaining ngày nữa đến hạn bảo dưỡng ${type.displayName}';
          }
        } else {
          message =
              'Mốc bảo dưỡng tiếp theo: $nextMileage km hoặc ${nextDate.day}/${nextDate.month}/${nextDate.year}';
        }
      } else {
        // Chưa có lịch sử bảo dưỡng
        if (vehicle.lastMaintenanceMileage != null &&
            vehicle.lastMaintenanceDate != null) {
          nextMileage = vehicle.lastMaintenanceMileage! + intervalKm;
          nextDate = vehicle.lastMaintenanceDate!
              .add(Duration(days: intervalMonths * 30));

          final kmRemaining = nextMileage - vehicle.currentMileage;
          final daysRemaining = nextDate.difference(DateTime.now()).inDays;

          if (kmRemaining <= AppConstants.maintenanceReminderKm ||
              daysRemaining <= AppConstants.maintenanceReminderDays) {
            isDue = true;
            message =
                'Còn $kmRemaining km hoặc $daysRemaining ngày nữa đến hạn bảo dưỡng ${type.displayName}';
          } else {
            message =
                'Mốc bảo dưỡng tiếp theo: $nextMileage km hoặc ${nextDate.day}/${nextDate.month}/${nextDate.year}';
          }
        } else {
          message = 'Chưa có thông tin bảo dưỡng';
        }
      }

      return Success(MaintenanceReminder(
        nextMileage: nextMileage,
        nextDate: nextDate,
        isDue: isDue,
        message: message,
      ));
    } catch (e) {
      return Failure('Không thể tính toán nhắc bảo dưỡng: ${e.toString()}');
    }
  }
}

