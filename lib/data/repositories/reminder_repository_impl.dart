import 'package:drift/drift.dart';
import '../../domain/entities/reminder.dart' as domain;
import '../../domain/repositories/reminder_repository.dart';
import '../database/app_database.dart';
import '../models/reminder_model.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final AppDatabase _database;

  ReminderRepositoryImpl(this._database);

  @override
  Future<List<domain.Reminder>> getRemindersByVehicle(String vehicleId) async {
    final query = _database.select(_database.reminders)
      ..where((tbl) => tbl.vehicleId.equals(vehicleId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.expiryDate)]);
    final data = await query.get();
    return data.map((d) => ReminderModel.fromData(d)).toList();
  }

  @override
  Future<List<domain.Reminder>> getUpcomingReminders(String vehicleId) async {
    final now = DateTime.now();
    final query = _database.select(_database.reminders)
      ..where((tbl) =>
          tbl.vehicleId.equals(vehicleId) &
          tbl.expiryDate.isBiggerOrEqualValue(now))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.expiryDate)]);
    final data = await query.get();
    return data.map((d) => ReminderModel.fromData(d)).toList();
  }

  @override
  Future<domain.Reminder?> getReminderById(String id) async {
    final query = _database.select(_database.reminders)
      ..where((tbl) => tbl.id.equals(id));
    final data = await query.getSingleOrNull();
    return data != null ? ReminderModel.fromData(data) : null;
  }

  @override
  Future<domain.Reminder> createReminder(domain.Reminder reminder) async {
    await _database.into(_database.reminders).insert(reminder.toData());
    return reminder;
  }

  @override
  Future<domain.Reminder> updateReminder(domain.Reminder reminder) async {
    await (_database.update(_database.reminders)
          ..where((tbl) => tbl.id.equals(reminder.id)))
        .write(reminder.toData());
    return reminder;
  }

  @override
  Future<void> deleteReminder(String id) async {
    await (_database.delete(_database.reminders)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

