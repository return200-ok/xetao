import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/use_cases/vehicle/get_vehicle.dart';
import '../../domain/use_cases/vehicle/create_vehicle.dart';
import '../../domain/use_cases/vehicle/update_mileage.dart';
import 'repository_providers.dart';

final vehicleProvider = FutureProvider<Vehicle?>((ref) async {
  final getVehicle = GetVehicle(ref.watch(vehicleRepositoryProvider));
  final result = await getVehicle();
  return result.when(
    success: (data) => data,
    failure: (_) => null,
  );
});

final createVehicleProvider = Provider<CreateVehicle>((ref) {
  return CreateVehicle(ref.watch(vehicleRepositoryProvider));
});

final updateMileageProvider = Provider<UpdateMileage>((ref) {
  return UpdateMileage(ref.watch(vehicleRepositoryProvider));
});
