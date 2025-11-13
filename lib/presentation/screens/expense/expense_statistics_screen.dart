import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../../domain/entities/expense_category.dart';

class ExpenseStatisticsScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const ExpenseStatisticsScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  ConsumerState<ExpenseStatisticsScreen> createState() =>
      _ExpenseStatisticsScreenState();
}

class _ExpenseStatisticsScreenState
    extends ConsumerState<ExpenseStatisticsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: _endDate,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final getStatistics = ref.read(expenseStatisticsProvider);
    final statisticsAsync = FutureProvider((ref) async {
      return await getStatistics(
        vehicleId: widget.vehicleId,
        startDate: _startDate,
        endDate: _endDate,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê chi phí'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final statsAsync = ref.watch(statisticsAsync);

          return statsAsync.when(
            data: (result) {
              return result.when(
                success: (stats) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: InkWell(
                                  onTap: _selectStartDate,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Từ ngày',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(_startDate),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                child: InkWell(
                                  onTap: _selectEndDate,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Đến ngày',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(_endDate),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Card(
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
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
                                const SizedBox(height: 8),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: '₫',
                                  ).format(stats.total),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Chi tiết theo danh mục',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...stats.byCategory.entries.map((entry) {
                          final percentage = stats.total > 0
                              ? (entry.value / stats.total * 100)
                              : 0.0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getCategoryColor(entry.key),
                                child: Icon(
                                  _getCategoryIcon(entry.key),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(entry.key.displayName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: '₫',
                                ).format(entry.value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
                failure: (message) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Lỗi: $message'),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Lỗi: $error'),
            ),
          );
        },
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
