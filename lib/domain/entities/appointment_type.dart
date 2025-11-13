enum AppointmentType {
  maintenance, // Bảo dưỡng
  repair, // Sửa chữa
  inspection, // Kiểm tra
}

extension AppointmentTypeExtension on AppointmentType {
  String get displayName {
    switch (this) {
      case AppointmentType.maintenance:
        return 'Bảo dưỡng';
      case AppointmentType.repair:
        return 'Sửa chữa';
      case AppointmentType.inspection:
        return 'Kiểm tra';
    }
  }
}

