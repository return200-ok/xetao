import '../../domain/entities/reminder.dart' as domain;
import '../../domain/entities/reminder_type.dart';
import '../database/app_database.dart' as db;

extension ReminderModel on domain.Reminder {
  db.Reminder toData() {
    return db.Reminder(
      id: id,
      vehicleId: vehicleId,
      type: type.index,
      expiryDate: expiryDate,
      reminderDays: reminderDays,
      createdAt: createdAt,
    );
  }

  static domain.Reminder fromData(db.Reminder data) {
    return domain.Reminder(
      id: data.id,
      vehicleId: data.vehicleId,
      type: ReminderType.values[data.type],
      expiryDate: data.expiryDate,
      reminderDays: data.reminderDays,
      createdAt: data.createdAt,
    );
  }
}

