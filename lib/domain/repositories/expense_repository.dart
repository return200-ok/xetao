import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpensesByVehicle(String vehicleId);
  Future<List<Expense>> getExpensesByPeriod(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Expense?> getExpenseById(String id);
  Future<Expense> createExpense(Expense expense);
  Future<Expense> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<double> getTotalExpensesByPeriod(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  );
}

