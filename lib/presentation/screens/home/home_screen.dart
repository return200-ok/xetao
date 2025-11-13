import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/maintenance_provider.dart';
import '../../../domain/entities/maintenance_type.dart';
import '../vehicle/vehicle_form_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider);
    final smallMaintenanceAsync =
        ref.watch(maintenanceReminderProvider(MaintenanceType.small));
    final largeMaintenanceAsync =
        ref.watch(maintenanceReminderProvider(MaintenanceType.large));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xe Tao'),
      ),
      body: vehicleAsync.when(
        data: (vehicle) {
          if (vehicle == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có thông tin xe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hãy thêm thông tin xe để bắt đầu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehicleFormScreen(),
                        ),
                      );
                    },
                    child: const Text('Thêm thông tin xe'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Số km hiện tại: ${vehicle.currentMileage.toStringAsFixed(0)} km',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Maintenance Reminders
                const Text(
                  'Nhắc bảo dưỡng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                smallMaintenanceAsync.when(
                  data: (reminder) {
                    if (reminder == null) return const SizedBox.shrink();
                    return Card(
                      color: reminder.isDue ? Colors.orange.shade50 : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.build,
                                  color: reminder.isDue
                                      ? Colors.orange
                                      : Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Bảo dưỡng nhỏ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: reminder.isDue
                                        ? Colors.orange
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(reminder.message),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                largeMaintenanceAsync.when(
                  data: (reminder) {
                    if (reminder == null) return const SizedBox.shrink();
                    return Card(
                      color: reminder.isDue ? Colors.orange.shade50 : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.build_circle,
                                  color: reminder.isDue
                                      ? Colors.orange
                                      : Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Bảo dưỡng lớn',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: reminder.isDue
                                        ? Colors.orange
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(reminder.message),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),
      ),
    );
  }
}

