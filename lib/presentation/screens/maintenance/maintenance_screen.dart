import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/maintenance_list_provider.dart' as maintenance_list;
import '../../providers/maintenance_provider.dart';
import '../../../domain/entities/maintenance_type.dart';
import 'add_maintenance_screen.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảo dưỡng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final vehicle = await ref.read(vehicleProvider.future);
              if (!context.mounted) return;
              
              if (vehicle != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMaintenanceScreen(vehicleId: vehicle.id),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng thêm thông tin xe trước')),
                );
              }
            },
          ),
        ],
      ),
      body: vehicleAsync.when(
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có thông tin xe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hãy thêm thông tin xe để xem lịch sử bảo dưỡng',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final maintenanceListAsync =
              ref.watch(maintenance_list.maintenanceListProvider(vehicle.id));

          return maintenanceListAsync.when(
            data: (maintenances) {
              if (maintenances.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.build, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Chưa có lịch sử bảo dưỡng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nhấn nút + để thêm bảo dưỡng',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(maintenance_list.maintenanceListProvider(vehicle.id));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: maintenances.length,
                  itemBuilder: (context, index) {
                    final maintenance = maintenances[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: maintenance.type == MaintenanceType.small
                              ? Colors.blue
                              : Colors.orange,
                          child: Icon(
                            maintenance.type == MaintenanceType.small
                                ? Icons.build
                                : Icons.build_circle,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(maintenance.type.displayName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Ngày: ${DateFormat('dd/MM/yyyy').format(maintenance.date)}',
                            ),
                            Text('Số km: ${maintenance.mileage.toStringAsFixed(0)} km'),
                            if (maintenance.cost != null)
                              Text(
                                'Chi phí: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(maintenance.cost)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            if (maintenance.notes != null && maintenance.notes!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Ghi chú: ${maintenance.notes}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Xác nhận'),
                                content: const Text('Bạn có chắc muốn xóa bảo dưỡng này?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              final deleteMaintenance = ref.read(deleteMaintenanceProvider);
                              final result = await deleteMaintenance(maintenance.id);
                              
                              if (context.mounted) {
                                result.when(
                                  success: (_) {
                                    ref.invalidate(maintenance_list.maintenanceListProvider(vehicle.id));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Đã xóa bảo dưỡng')),
                                    );
                                  },
                                  failure: (message) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(maintenance_list.maintenanceListProvider(vehicle.id));
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Lỗi: $error')),
      ),
    );
  }
}
