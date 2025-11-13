import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointmentsByVehicle(String vehicleId);
  Future<List<Appointment>> getUpcomingAppointments(String vehicleId);
  Future<Appointment?> getAppointmentById(String id);
  Future<Appointment> createAppointment(Appointment appointment);
  Future<Appointment> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(String id);
}

