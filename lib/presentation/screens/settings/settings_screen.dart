import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/vehicle_provider.dart';
import '../vehicle/vehicle_form_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: vehicleAsync.when(
        data: (vehicle) {
          if (vehicle == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.settings, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có thông tin xe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hãy thêm thông tin xe để bắt đầu',
                    style: TextStyle(color: Colors.grey),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Thông tin xe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VehicleFormScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Sửa'),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildInfoRow('Tên xe', vehicle.name),
                      _buildInfoRow('Hãng', vehicle.brand),
                      _buildInfoRow('Đời xe', vehicle.model),
                      _buildInfoRow('Năm sản xuất', vehicle.year.toString()),
                      _buildInfoRow(
                        'Số km hiện tại',
                        '${vehicle.currentMileage.toStringAsFixed(0)} km',
                      ),
                      if (vehicle.lastMaintenanceDate != null)
                        _buildInfoRow(
                          'Bảo dưỡng gần nhất',
                          DateFormat('dd/MM/yyyy')
                              .format(vehicle.lastMaintenanceDate!),
                        ),
                      if (vehicle.lastMaintenanceMileage != null)
                        _buildInfoRow(
                          'Số km bảo dưỡng',
                          '${vehicle.lastMaintenanceMileage!.toStringAsFixed(0)} km',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cập nhật số km',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _UpdateMileageWidget(vehicleId: vehicle.id),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin ứng dụng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildInfoRow('Tên ứng dụng', 'Xe Tao'),
                      _buildInfoRow('Phiên bản', '1.0.0'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Lỗi: $error')),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateMileageWidget extends ConsumerStatefulWidget {
  final String vehicleId;

  const _UpdateMileageWidget({required this.vehicleId});

  @override
  ConsumerState<_UpdateMileageWidget> createState() =>
      _UpdateMileageWidgetState();
}

class _UpdateMileageWidgetState extends ConsumerState<_UpdateMileageWidget> {
  final _formKey = GlobalKey<FormState>();
  final _mileageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _updateMileage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updateMileage = ref.read(updateMileageProvider);
    final result = await updateMileage(
      vehicleId: widget.vehicleId,
      mileage: int.parse(_mileageController.text),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (_) {
          ref.invalidate(vehicleProvider);
          _mileageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật số km')),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _mileageController,
            decoration: const InputDecoration(
              labelText: 'Số km mới',
              hintText: 'Ví dụ: 55000',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số km';
              }
              final mileage = int.tryParse(value);
              if (mileage == null || mileage < 0) {
                return 'Số km không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updateMileage,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cập nhật'),
            ),
          ),
        ],
      ),
    );
  }
}
