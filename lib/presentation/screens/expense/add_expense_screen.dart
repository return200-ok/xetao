import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../providers/expense_list_provider.dart';
import '../../../domain/entities/expense_category.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const AddExpenseScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  ExpenseCategory _category = ExpenseCategory.fuel;
  DateTime _selectedDate = DateTime.now();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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

    final createExpense = ref.read(createExpenseProvider);
    final result = await createExpense(
      vehicleId: widget.vehicleId,
      category: _category,
      amount: double.parse(_amountController.text.replaceAll(',', '.')),
      date: _selectedDate,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    );

    if (mounted) {
      result.when(
        success: (_) {
          ref.invalidate(expenseListProvider(widget.vehicleId));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm chi phí')),
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
        title: const Text('Thêm chi phí'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Danh mục',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ExpenseCategory>(
              value: _category,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ExpenseCategory.values.map((category) {
                return DropdownMenuItem<ExpenseCategory>(
                  value: category,
                  child: Text(category.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày',
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
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Số tiền',
                hintText: 'Ví dụ: 500000',
                prefixText: '₫ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số tiền';
                }
                final amount = double.tryParse(value.replaceAll(',', '.'));
                if (amount == null || amount <= 0) {
                  return 'Số tiền phải lớn hơn 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
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
