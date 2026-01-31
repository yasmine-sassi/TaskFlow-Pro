import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final client = DioClient();
  ref.onDispose(() {
    // Clean up if needed
  });
  return client;
});

// Keep the provider alive to maintain singleton
final dioProvider = Provider<DioClient>((ref) {
  return ref.watch(dioClientProvider);
});

final themeModeProvider = StateProvider<bool>(
  (ref) => false,
); // false = light, true = dark

final authStateProvider = StateProvider<bool>(
  (ref) => false,
); // simplistic example
