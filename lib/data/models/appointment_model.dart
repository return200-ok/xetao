import '../../domain/entities/appointment.dart' as domain;
import '../../domain/entities/appointment_type.dart';
import '../database/app_database.dart' as db;

extension AppointmentModel on domain.Appointment {
  db.Appointment toData() {
    return db.Appointment(
      id: id,
      vehicleId: vehicleId,
      garageName: garageName,
      date: date,
      time: time,
      type: type.index,
      notes: notes,
      reminderSent: reminderSent,
      createdAt: createdAt,
    );
  }

  static domain.Appointment fromData(db.Appointment data) {
    return domain.Appointment(
      id: data.id,
      vehicleId: data.vehicleId,
      garageName: data.garageName,
      date: data.date,
      time: data.time,
      type: AppointmentType.values[data.type],
      notes: data.notes,
      reminderSent: data.reminderSent,
      createdAt: data.createdAt,
    );
  }
}

