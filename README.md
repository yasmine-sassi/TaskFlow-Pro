# TaskFlow Pro - Modern Flutter Application

A production-grade Flutter application with modern UI, featuring a fixed top navigation bar and comprehensive settings page, matching the React web prototype exactly.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Riverpod](https://img.shields.io/badge/State-Riverpod-purple)
![Material 3](https://img.shields.io/badge/Design-Material%203-blue)

## ✨ Features

### 🎯 Core Features

- ✅ **Fixed Top Navigation Bar** - Always visible with active state highlighting
- ✅ **Comprehensive Settings Page** - Profile, Notifications, Appearance, Security
- ✅ **Dark Mode Support** - Real-time theme switching
- ✅ **State Management** - Type-safe Riverpod implementation
- ✅ **Backend Integration** - Ready-to-use service layer for NestJS APIs
- ✅ **Clean Architecture** - Separation of concerns, testable, maintainable

### 🎨 Design System

- ✅ **Pixel-Perfect Match** to React prototype
- ✅ **Centralized Theme** - All colors, typography, spacing defined
- ✅ **Reusable Components** - Custom widgets matching prototype design
- ✅ **Responsive Layout** - Works on all screen sizes
- ✅ **Material 3** - Modern design language

## 📸 Screenshots

### Light Mode

- Top Navigation with Dashboard, Projects, Tasks, Settings
- Settings Page with Profile, Notifications, Appearance, Security tabs

### Dark Mode

- Full dark theme support
- Instant theme switching

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- NestJS backend running (for API integration)

### Installation

```bash
# Clone the repository
cd TaskFlow-Pro

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Usage

```dart
import 'package:taskflow_pro/pages/modern_main_layout.dart';

ModernMainLayout(
  dashboardContent: YourDashboard(),
  projectsContent: YourProjects(),
  tasksContent: YourTasks(),
)
```

## 📁 Project Structure

```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart              # Complete theme system
├── data/
│   └── services/
│       ├── user_service.dart           # User API calls
│       └── settings_service.dart       # Settings API calls
├── pages/
│   ├── modern_main_layout.dart        # Main layout with top nav
│   ├── settings_page.dart             # Settings implementation
│   └── app_main_screen.dart           # Example usage
└── presentation/
    ├── providers/
    │   ├── settings_provider.dart      # Settings state
    │   └── user_provider.dart          # User state
    └── widgets/
        ├── app_top_nav_bar.dart        # Top navigation
        ├── settings_card.dart          # Card component
        ├── custom_switch.dart          # Switch widget
        └── custom_input.dart           # Input widget
```

## 🎨 Theme System

### Using Colors

```dart
import 'package:taskflow_pro/core/theme/app_theme.dart';

// Primary colors
AppTheme.primary              // #6366F1
AppTheme.background           // Light/Dark aware
AppTheme.foreground

// Status colors
AppTheme.statusInProgress     // Blue
AppTheme.statusDone           // Green

// Typography
AppTheme.heading1
AppTheme.bodyMedium
```

### Theme Switching

```dart
// Toggle dark mode
ref.read(settingsProvider.notifier).updateDarkMode(true);
```

## 🔌 Backend Integration

### API Endpoints (NestJS)

```typescript
// User endpoints
GET    /users/profile
PATCH  /users/:id
PATCH  /users/:id/password
POST   /users/:id/avatar

// Settings endpoints
GET    /users/:id/settings
PATCH  /users/:id/settings
PATCH  /users/:id/notifications
PATCH  /users/:id/appearance
```

### Service Usage

```dart
// User service
final userService = UserService(dio);
final user = await userService.getProfile();

// Settings service
final settingsService = SettingsService(dio);
await settingsService.updateSettings(userId: 1, darkMode: true);
```

## 📚 Documentation

- **[Implementation Guide](IMPLEMENTATION_GUIDE.md)** - Complete setup and usage
- **[Quick Start](QUICK_START.md)** - Quick reference guide
- **[Integration Checklist](INTEGRATION_CHECKLIST.md)** - Step-by-step integration
- **[Architecture](ARCHITECTURE.md)** - System architecture diagrams
- **[Implementation Summary](IMPLEMENTATION_SUMMARY.md)** - Feature checklist

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
flutter format .
```

## 🏗️ Architecture

### State Management: Riverpod

**Why Riverpod?**

- Type-safe and compile-time error detection
- Better testability than Provider
- Less boilerplate than Bloc
- Automatic resource disposal
- Excellent performance

### Clean Architecture Layers

1. **Presentation Layer** - Widgets, Pages, Providers
2. **Domain Layer** - Entities, Use Cases
3. **Data Layer** - Services, Repositories, Models
4. **Core Layer** - Theme, Network, Constants

### Data Flow

```
UI Widget → Provider → Service → Backend API
                ↓
         State Updates
                ↓
           UI Rebuilds
```

## 🎯 Key Components

### Top Navigation Bar

- Fixed position at top of screen
- Active state highlighting
- User dropdown menu
- Notification badge
- Search functionality

### Settings Page

- **Profile Tab** - Avatar, name, email editing
- **Notifications Tab** - Email, push, reminders, digest toggles
- **Appearance Tab** - Dark mode, language selection
- **Security Tab** - Password change, 2FA setup

### Custom Widgets

- `AppTopNavBar` - Top navigation component
- `SettingsCard` - Card container with title
- `CustomSwitch` - Toggle switch matching prototype
- `CustomInput` - Styled input field
- `SettingsTabButton` - Tab button with icon

## 🔧 Configuration

### Dio Client

```dart
// lib/core/network/dio_client.dart
final dio = Dio(BaseOptions(
  baseUrl: 'http://your-backend-url/api',
  connectTimeout: const Duration(seconds: 30),
));
```

### Environment Variables

Create `.env` file:

```env
API_BASE_URL=http://localhost:3000/api
API_TIMEOUT=30000
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1 # State management
  dio: ^5.4.0 # HTTP client
  shared_preferences: ^2.2.2 # Local storage
  intl: ^0.19.0 # Internationalization
```

## 🤝 Contributing

When adding new features:

1. Follow existing architecture patterns
2. Use Riverpod for state management
3. Match design system colors/typography
4. Keep widgets reusable
5. Document new endpoints

## 🐛 Troubleshooting

### Theme not updating?

Check that `ProviderScope` wraps `MaterialApp` and `settingsProvider` is watched.

### Navigation not working?

Verify `ModernMainLayout` is used with correct content widgets.

### Backend calls failing?

Check Dio base URL configuration and verify API endpoints exist.

## 📝 License

This project is part of TaskFlow Pro application.

## 👥 Authors

Senior Flutter Engineer Team

## 🔗 Related Projects

- **Backend:** NestJS API (in `NestBackend/` folder)
- **Web Prototype:** React application (in `flow-pro-prototype/` folder)

## 📞 Support

For issues and questions:

1. Check documentation files
2. Review example implementations
3. Consult architecture diagrams

---

**Built with ❤️ using Flutter**
