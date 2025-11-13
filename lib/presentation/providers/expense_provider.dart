import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/expense/create_expense.dart';
import '../../domain/use_cases/expense/get_expense_statistics.dart';
import 'repository_providers.dart';

final createExpenseProvider = Provider<CreateExpense>((ref) {
  return CreateExpense(ref.watch(expenseRepositoryProvider));
});

final expenseStatisticsProvider = Provider<GetExpenseStatistics>((ref) {
  return GetExpenseStatistics(ref.watch(expenseRepositoryProvider));
});

