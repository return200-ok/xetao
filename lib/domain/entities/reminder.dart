import 'reminder_type.dart';

class Reminder {
  final String id;
  final String vehicleId;
  final ReminderType type;
  final DateTime expiryDate;
  final int reminderDays; // Số ngày nhắc trước
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.expiryDate,
    this.reminderDays = 7,
    required this.createdAt,
  });

  Reminder copyWith({
    String? id,
    String? vehicleId,
    ReminderType? type,
    DateTime? expiryDate,
    int? reminderDays,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      expiryDate: expiryDate ?? this.expiryDate,
      reminderDays: reminderDays ?? this.reminderDays,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  DateTime get reminderDate => expiryDate.subtract(Duration(days: reminderDays));
  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get shouldRemind => DateTime.now().isAfter(reminderDate) && !isExpired;
}

