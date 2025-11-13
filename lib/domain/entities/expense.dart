import 'expense_category.dart';

class Expense {
  final String id;
  final String vehicleId;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  final String? description;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.vehicleId,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    required this.createdAt,
  });

  Expense copyWith({
    String? id,
    String? vehicleId,
    ExpenseCategory? category,
    double? amount,
    DateTime? date,
    String? description,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

