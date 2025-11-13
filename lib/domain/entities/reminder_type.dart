enum ReminderType {
  registration, // Đăng kiểm
  insurance, // Bảo hiểm
  roadFee, // Phí đường bộ
}

extension ReminderTypeExtension on ReminderType {
  String get displayName {
    switch (this) {
      case ReminderType.registration:
        return 'Đăng kiểm';
      case ReminderType.insurance:
        return 'Bảo hiểm';
      case ReminderType.roadFee:
        return 'Phí đường bộ';
    }
  }
}

