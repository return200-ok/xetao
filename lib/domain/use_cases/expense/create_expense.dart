import 'package:uuid/uuid.dart';
import '../../entities/expense.dart';
import '../../entities/expense_category.dart';
import '../../repositories/expense_repository.dart';
import '../../../core/utils/result.dart';

class CreateExpense {
  final ExpenseRepository _repository;
  final _uuid = const Uuid();

  CreateExpense(this._repository);

  Future<Result<Expense>> call({
    required String vehicleId,
    required ExpenseCategory category,
    required double amount,
    required DateTime date,
    String? description,
  }) async {
    try {
      if (amount <= 0) {
        return const Failure('Số tiền phải lớn hơn 0');
      }

      final expense = Expense(
        id: _uuid.v4(),
        vehicleId: vehicleId,
        category: category,
        amount: amount,
        date: date,
        description: description,
        createdAt: DateTime.now(),
      );

      await _repository.createExpense(expense);
      return Success(expense);
    } catch (e) {
      return Failure('Không thể tạo chi phí: ${e.toString()}');
    }
  }
}

