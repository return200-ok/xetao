import 'package:drift/drift.dart';
import '../../domain/entities/expense.dart' as domain;
import '../../domain/repositories/expense_repository.dart';
import '../database/app_database.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final AppDatabase _database;

  ExpenseRepositoryImpl(this._database);

  @override
  Future<List<domain.Expense>> getExpensesByVehicle(String vehicleId) async {
    final query = _database.select(_database.expenses)
      ..where((tbl) => tbl.vehicleId.equals(vehicleId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    final data = await query.get();
    return data.map((d) => ExpenseModel.fromData(d)).toList();
  }

  @override
  Future<List<domain.Expense>> getExpensesByPeriod(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = _database.select(_database.expenses)
      ..where((tbl) =>
          tbl.vehicleId.equals(vehicleId) &
          tbl.date.isBiggerOrEqualValue(startDate) &
          tbl.date.isSmallerOrEqualValue(endDate))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    final data = await query.get();
    return data.map((d) => ExpenseModel.fromData(d)).toList();
  }

  @override
  Future<domain.Expense?> getExpenseById(String id) async {
    final query = _database.select(_database.expenses)
      ..where((tbl) => tbl.id.equals(id));
    final data = await query.getSingleOrNull();
    return data != null ? ExpenseModel.fromData(data) : null;
  }

  @override
  Future<domain.Expense> createExpense(domain.Expense expense) async {
    await _database.into(_database.expenses).insert(expense.toData());
    return expense;
  }

  @override
  Future<domain.Expense> updateExpense(domain.Expense expense) async {
    await (_database.update(_database.expenses)
          ..where((tbl) => tbl.id.equals(expense.id)))
        .write(expense.toData());
    return expense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    await (_database.delete(_database.expenses)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<double> getTotalExpensesByPeriod(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenses = _database.expenses;
    final query = _database.selectOnly(expenses, distinct: false)
      ..addColumns([expenses.amount.sum()])
      ..where(
        expenses.vehicleId.equals(vehicleId) &
        expenses.date.isBiggerOrEqualValue(startDate) &
        expenses.date.isSmallerOrEqualValue(endDate),
      );
    final result = await query.getSingle();
    return result.read(expenses.amount.sum()) ?? 0.0;
  }
}

