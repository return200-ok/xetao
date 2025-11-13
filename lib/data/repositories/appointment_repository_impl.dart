import 'package:drift/drift.dart';
import '../../domain/entities/appointment.dart' as domain;
import '../../domain/repositories/appointment_repository.dart';
import '../database/app_database.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppDatabase _database;

  AppointmentRepositoryImpl(this._database);

  @override
  Future<List<domain.Appointment>> getAppointmentsByVehicle(String vehicleId) async {
    final query = _database.select(_database.appointments)
      ..where((tbl) => tbl.vehicleId.equals(vehicleId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]);
    final data = await query.get();
    return data.map((d) => AppointmentModel.fromData(d)).toList();
  }

  @override
  Future<List<domain.Appointment>> getUpcomingAppointments(String vehicleId) async {
    final now = DateTime.now();
    final query = _database.select(_database.appointments)
      ..where((tbl) =>
          tbl.vehicleId.equals(vehicleId) &
          tbl.date.isBiggerOrEqualValue(now))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]);
    final data = await query.get();
    return data.map((d) => AppointmentModel.fromData(d)).toList();
  }

  @override
  Future<domain.Appointment?> getAppointmentById(String id) async {
    final query = _database.select(_database.appointments)
      ..where((tbl) => tbl.id.equals(id));
    final data = await query.getSingleOrNull();
    return data != null ? AppointmentModel.fromData(data) : null;
  }

  @override
  Future<domain.Appointment> createAppointment(domain.Appointment appointment) async {
    await _database
        .into(_database.appointments)
        .insert(appointment.toData());
    return appointment;
  }

  @override
  Future<domain.Appointment> updateAppointment(domain.Appointment appointment) async {
    await (_database.update(_database.appointments)
          ..where((tbl) => tbl.id.equals(appointment.id)))
        .write(appointment.toData());
    return appointment;
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await (_database.delete(_database.appointments)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

