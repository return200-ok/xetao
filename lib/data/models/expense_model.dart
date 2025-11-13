import '../../domain/entities/expense.dart' as domain;
import '../../domain/entities/expense_category.dart';
import '../database/app_database.dart' as db;

extension ExpenseModel on domain.Expense {
  db.Expense toData() {
    return db.Expense(
      id: id,
      vehicleId: vehicleId,
      category: category.index,
      amount: amount,
      date: date,
      description: description,
      createdAt: createdAt,
    );
  }

  static domain.Expense fromData(db.Expense data) {
    return domain.Expense(
      id: data.id,
      vehicleId: data.vehicleId,
      category: ExpenseCategory.values[data.category],
      amount: data.amount,
      date: data.date,
      description: data.description,
      createdAt: data.createdAt,
    );
  }
}

