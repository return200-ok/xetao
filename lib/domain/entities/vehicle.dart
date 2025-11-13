class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final int currentMileage;
  final DateTime? lastMaintenanceDate;
  final int? lastMaintenanceMileage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.currentMileage,
    this.lastMaintenanceDate,
    this.lastMaintenanceMileage,
    required this.createdAt,
    required this.updatedAt,
  });

  Vehicle copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    int? year,
    int? currentMileage,
    DateTime? lastMaintenanceDate,
    int? lastMaintenanceMileage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      currentMileage: currentMileage ?? this.currentMileage,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      lastMaintenanceMileage: lastMaintenanceMileage ?? this.lastMaintenanceMileage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$brand $model ($year)';
}

