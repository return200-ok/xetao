import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/maintenance_provider.dart';
import '../../providers/maintenance_list_provider.dart' as maintenance_list;
import '../../../domain/entities/maintenance_type.dart';

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const AddMaintenanceScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  ConsumerState<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  MaintenanceType _type = MaintenanceType.small;
  DateTime _selectedDate = DateTime.now();
  final _mileageController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _mileageController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final createMaintenance = ref.read(createMaintenanceProvider);
    final result = await createMaintenance(
      vehicleId: widget.vehicleId,
      type: _type,
      date: _selectedDate,
      mileage: int.parse(_mileageController.text),
      cost: _costController.text.isNotEmpty
          ? double.tryParse(_costController.text.replaceAll(',', '.'))
          : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    if (mounted) {
      result.when(
        success: (_) {
          ref.invalidate(maintenance_list.maintenanceListProvider(widget.vehicleId));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm bảo dưỡng')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm bảo dưỡng'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Loại bảo dưỡng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<MaintenanceType>(
              segments: const [
                ButtonSegment(
                  value: MaintenanceType.small,
                  label: Text('Bảo dưỡng nhỏ'),
                ),
                ButtonSegment(
                  value: MaintenanceType.large,
                  label: Text('Bảo dưỡng lớn'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (Set<MaintenanceType> newSelection) {
                setState(() {
                  _type = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày bảo dưỡng',
                suffixIcon: const Icon(Icons.calendar_today),
                hintText: DateFormat('dd/MM/yyyy').format(_selectedDate),
              ),
              onTap: _selectDate,
              controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy').format(_selectedDate),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mileageController,
              decoration: const InputDecoration(
                labelText: 'Số km',
                hintText: 'Ví dụ: 50000',
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
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Chi phí (tùy chọn)',
                hintText: 'Ví dụ: 500000',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final cost = double.tryParse(value.replaceAll(',', '.'));
                  if (cost == null || cost < 0) {
                    return 'Chi phí không hợp lệ';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (tùy chọn)',
                hintText: 'Nhập ghi chú nếu có',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
