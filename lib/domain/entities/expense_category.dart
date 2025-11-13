enum ExpenseCategory {
  fuel, // Xăng dầu
  maintenance, // Bảo dưỡng
  repair, // Sửa chữa
  parts, // Phụ tùng
  toll, // Phí cầu đường
  insurance, // Bảo hiểm
  registration, // Đăng kiểm
  other, // Khác
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.fuel:
        return 'Xăng dầu';
      case ExpenseCategory.maintenance:
        return 'Bảo dưỡng';
      case ExpenseCategory.repair:
        return 'Sửa chữa';
      case ExpenseCategory.parts:
        return 'Phụ tùng';
      case ExpenseCategory.toll:
        return 'Phí cầu đường';
      case ExpenseCategory.insurance:
        return 'Bảo hiểm';
      case ExpenseCategory.registration:
        return 'Đăng kiểm';
      case ExpenseCategory.other:
        return 'Khác';
    }
  }
}

