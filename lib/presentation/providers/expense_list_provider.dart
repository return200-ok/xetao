import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense.dart' as domain;
import 'repository_providers.dart';

final expenseListProvider =
    FutureProvider.family<List<domain.Expense>, String>((ref, vehicleId) async {
  final repository = ref.watch(expenseRepositoryProvider);
  return await repository.getExpensesByVehicle(vehicleId);
});
