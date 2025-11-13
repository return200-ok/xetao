import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/expense_list_provider.dart';
import '../../../domain/entities/expense_category.dart';
import 'add_expense_screen.dart';
import 'expense_statistics_screen.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi phí'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () async {
              final vehicle = await ref.read(vehicleProvider.future);
              if (vehicle != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseStatisticsScreen(vehicleId: vehicle.id),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final vehicle = await ref.read(vehicleProvider.future);
              if (!context.mounted) return;
              
              if (vehicle != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(vehicleId: vehicle.id),
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
                  Icon(Icons.attach_money, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có thông tin xe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hãy thêm thông tin xe để quản lý chi phí',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final expenseListAsync = ref.watch(expenseListProvider(vehicle.id));

          return expenseListAsync.when(
            data: (expenses) {
              if (expenses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Chưa có chi phí nào',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nhấn nút + để thêm chi phí',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              final total = expenses.fold<double>(
                0.0,
                (sum, expense) => sum + expense.amount,
              );

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng chi phí',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(
                            locale: 'vi_VN',
                            symbol: '₫',
                          ).format(total),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '${expenses.length} giao dịch',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(expenseListProvider(vehicle.id));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getCategoryColor(expense.category),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(expense.category.displayName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ngày: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                                  ),
                                  if (expense.description != null &&
                                      expense.description!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        expense.description!,
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: '₫',
                                ).format(expense.amount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
                      ref.invalidate(expenseListProvider(vehicle.id));
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

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Colors.orange;
      case ExpenseCategory.maintenance:
        return Colors.blue;
      case ExpenseCategory.repair:
        return Colors.red;
      case ExpenseCategory.parts:
        return Colors.purple;
      case ExpenseCategory.toll:
        return Colors.green;
      case ExpenseCategory.insurance:
        return Colors.teal;
      case ExpenseCategory.registration:
        return Colors.indigo;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Icons.local_gas_station;
      case ExpenseCategory.maintenance:
        return Icons.build;
      case ExpenseCategory.repair:
        return Icons.construction;
      case ExpenseCategory.parts:
        return Icons.settings;
      case ExpenseCategory.toll:
        return Icons.toll;
      case ExpenseCategory.insurance:
        return Icons.shield;
      case ExpenseCategory.registration:
        return Icons.description;
      case ExpenseCategory.other:
        return Icons.category;
    }
  }
}
