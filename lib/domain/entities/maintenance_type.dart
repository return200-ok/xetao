enum MaintenanceType {
  small, // Bảo dưỡng nhỏ
  large, // Bảo dưỡng lớn
}

extension MaintenanceTypeExtension on MaintenanceType {
  String get displayName {
    switch (this) {
      case MaintenanceType.small:
        return 'Bảo dưỡng nhỏ';
      case MaintenanceType.large:
        return 'Bảo dưỡng lớn';
    }
  }
}

