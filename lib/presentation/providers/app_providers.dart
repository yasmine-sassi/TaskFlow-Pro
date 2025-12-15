import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final themeModeProvider = StateProvider<bool>(
  (ref) => false,
); // false = light, true = dark

final authStateProvider = StateProvider<bool>(
  (ref) => false,
); // simplistic example
