import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/app_providers.dart';
import 'core/di/service_locator.dart';
import 'presentation/screens/auth_test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Point to your backend. For Android emulator use 10.0.2.2; iOS simulator 127.0.0.1; physical device use LAN IP.
  await initDependencies(baseUrl: 'http://10.0.2.2:3000');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'TaskFlow Pro',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const AuthTestScreen(),
    );
  }
}
