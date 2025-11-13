import '../../entities/expense.dart';
import '../../entities/expense_category.dart';
import '../../repositories/expense_repository.dart';
import '../../../core/utils/result.dart';

class ExpenseStatistics {
  final double total;
  final Map<ExpenseCategory, double> byCategory;
  final List<Expense> expenses;

  ExpenseStatistics({
    required this.total,
    required this.byCategory,
    required this.expenses,
  });
}

class GetExpenseStatistics {
  final ExpenseRepository _repository;

  GetExpenseStatistics(this._repository);

  Future<Result<ExpenseStatistics>> call({
    required String vehicleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expenses = await _repository.getExpensesByPeriod(
        vehicleId,
        startDate,
        endDate,
      );

      final total = await _repository.getTotalExpensesByPeriod(
        vehicleId,
        startDate,
        endDate,
      );

      final byCategory = <ExpenseCategory, double>{};
      for (final expense in expenses) {
        byCategory[expense.category] =
            (byCategory[expense.category] ?? 0) + expense.amount;
      }

      return Success(ExpenseStatistics(
        total: total,
        byCategory: byCategory,
        expenses: expenses,
      ));
    } catch (e) {
      return Failure('Không thể lấy thống kê chi phí: ${e.toString()}');
    }
  }
}

