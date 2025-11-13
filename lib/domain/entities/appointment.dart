import 'appointment_type.dart';

class Appointment {
  final String id;
  final String vehicleId;
  final String garageName;
  final DateTime date;
  final String time; // Format: "HH:mm"
  final AppointmentType type;
  final String? notes;
  final bool reminderSent;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.vehicleId,
    required this.garageName,
    required this.date,
    required this.time,
    required this.type,
    this.notes,
    this.reminderSent = false,
    required this.createdAt,
  });

  Appointment copyWith({
    String? id,
    String? vehicleId,
    String? garageName,
    DateTime? date,
    String? time,
    AppointmentType? type,
    String? notes,
    bool? reminderSent,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      garageName: garageName ?? this.garageName,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      reminderSent: reminderSent ?? this.reminderSent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

