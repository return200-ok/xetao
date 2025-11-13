import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/app_constants.dart';

part 'app_database.g.dart';

// Tables
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  IntColumn get currentMileage => integer()();
  DateTimeColumn get lastMaintenanceDate => dateTime().nullable()();
  IntColumn get lastMaintenanceMileage => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Maintenances extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  IntColumn get type => integer()(); // 0: small, 1: large
  DateTimeColumn get date => dateTime()();
  IntColumn get mileage => integer()();
  RealColumn get cost => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  IntColumn get category => integer()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Appointments extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  TextColumn get garageName => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get time => text()(); // Format: "HH:mm"
  IntColumn get type => integer()(); // 0: maintenance, 1: repair, 2: inspection
  TextColumn get notes => text().nullable()();
  BoolColumn get reminderSent => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  IntColumn get type => integer()(); // 0: registration, 1: insurance, 2: roadFee
  DateTimeColumn get expiryDate => dateTime()();
  IntColumn get reminderDays => integer().withDefault(const Constant(7))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Vehicles, Maintenances, Expenses, Appointments, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}

