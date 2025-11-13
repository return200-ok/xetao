import 'maintenance_type.dart';

class Maintenance {
  final String id;
  final String vehicleId;
  final MaintenanceType type;
  final DateTime date;
  final int mileage;
  final double? cost;
  final String? notes;
  final DateTime createdAt;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.mileage,
    this.cost,
    this.notes,
    required this.createdAt,
  });

  Maintenance copyWith({
    String? id,
    String? vehicleId,
    MaintenanceType? type,
    DateTime? date,
    int? mileage,
    double? cost,
    String? notes,
    DateTime? createdAt,
  }) {
    return Maintenance(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      date: date ?? this.date,
      mileage: mileage ?? this.mileage,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

