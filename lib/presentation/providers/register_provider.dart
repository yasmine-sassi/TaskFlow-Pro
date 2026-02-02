import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import 'user_provider.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );
  }
}

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController(this.ref) : super(const RegisterState());

  final Ref ref;

  bool _isEmailValid(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSpecial = RegExp(r'[@$!%*?&]').hasMatch(password);

    if (!hasUppercase || !hasLowercase || !hasNumber || !hasSpecial) {
      return 'Password must include uppercase, lowercase, number, and special character';
    }
    return null;
  }

  bool _validate({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    String? firstNameError;
    String? lastNameError;
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;

    if (firstName.trim().isEmpty) {
      firstNameError = 'First name is required';
    }

    if (lastName.trim().isEmpty) {
      lastNameError = 'Last name is required';
    }

    if (email.trim().isEmpty) {
      emailError = 'Email is required';
    } else if (!_isEmailValid(email.trim())) {
      emailError = 'Please enter a valid email';
    }

    passwordError = _validatePassword(password);

    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Confirmation is required';
    } else if (password != confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
    }

    state = state.copyWith(
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      errorMessage: null,
    );

    return firstNameError == null &&
        lastNameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  Future<String?> submit({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final isValid = _validate(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!isValid) {
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final client = AuthApiClientFactory.createPublic(
        baseUrl: ApiEndpoints.baseUrl,
      );

      final response = await client.register(
        RegisterDto(
          email: email.trim(),
          password: password,
          firstName: firstName.trim(),
          lastName: lastName.trim(),
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.accessToken);
      await prefs.setString('user_data', json.encode(response.user.toJson()));

      AuthApiClientFactory.createAuthenticated(
        baseUrl: ApiEndpoints.baseUrl,
        accessToken: response.accessToken,
      );

      await ref.read(userProvider.notifier).loadUser();

      state = state.copyWith(isLoading: false, errorMessage: null);
      return response.user.role;
    } on DioException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _extractErrorMessage(error),
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error. Please check your connection.',
      );
    }

    return null;
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      if (message is List && message.isNotEmpty) {
        return message.join(' ');
      }
    }
    return 'Registration failed. Please try again.';
  }
}

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  return RegisterController(ref);
});
