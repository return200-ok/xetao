import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getRemindersByVehicle(String vehicleId);
  Future<List<Reminder>> getUpcomingReminders(String vehicleId);
  Future<Reminder?> getReminderById(String id);
  Future<Reminder> createReminder(Reminder reminder);
  Future<Reminder> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
}

