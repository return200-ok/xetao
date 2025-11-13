# Xe Tao - Ứng dụng Quản lý Xe Ô Tô

Ứng dụng di động giúp chủ xe ô tô tại Việt Nam quản lý việc bảo dưỡng, chi phí vận hành và lịch sửa chữa.

## 🎯 Tính năng chính

- ✅ Nhắc bảo dưỡng định kỳ
- ✅ Thống kê chi phí vận hành
- ✅ Đặt lịch sửa xe / bảo dưỡng
- ✅ Nhắc các hạn định kỳ (đăng kiểm, bảo hiểm, phí đường bộ)
- ✅ Tiện ích thêm (giá xăng, mẹo chăm xe)

## 🚀 Quick Start

### Prerequisites

- Flutter 3.9.2+
- Dart 3.9.2+
- Android Studio / Xcode (for mobile development)

### Installation

```bash
# Install dependencies
flutter pub get

# Generate code (for Drift database)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS (simulator)

## 🏗️ Project Structure

```
lib/
├── core/              # Core utilities, constants, themes
├── data/              # Data layer (repositories, data sources)
├── domain/            # Business logic, entities, use cases
├── presentation/      # UI layer (screens, widgets, providers)
└── main.dart          # App entry point
```

## 📝 Development

### Code Generation

When you modify database schemas or models, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
flutter test
```

## 📄 License

UNLICENSED - Private project

