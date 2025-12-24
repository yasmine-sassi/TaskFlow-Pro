import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../service_locator.dart';
import '../utils/dio_client.dart';
import '../services/auth_service.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  String? _output;
  String? _token;
  bool _loading = false;

  AuthService get _authService => GetIt.I<AuthService>();

  Future<void> _login() async {
    setState(() => _loading = true);
    if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      _setOutput('Please enter email and password.');
      return;
    }
    try {
      final session = await _authService.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      _token = session.accessToken;
      setAccessToken(_token);
      _setOutput(
        'Login OK\nToken: ${session.accessToken}\nUser: ${session.user.fullName} (${session.user.email})\nRole: ${session.user.role}',
      );
    } catch (e) {
      _setOutput('Login failed: $e');
    }
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    if (_emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _firstNameCtrl.text.trim().isEmpty ||
        _lastNameCtrl.text.trim().isEmpty) {
      _setOutput('Please fill email, password, first name and last name.');
      return;
    }
    try {
      final session = await _authService.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
      );
      _token = session.accessToken;
      setAccessToken(_token);
      _setOutput(
        'Register OK\nToken: ${session.accessToken}\nUser: ${session.user.fullName} (${session.user.email})',
      );
    } catch (e) {
      _setOutput('Register failed: $e');
    }
  }

  Future<void> _me() async {
    setState(() => _loading = true);
    if (_token == null) {
      _setOutput('No token. Please login first.');
      return;
    }
    try {
      final user = await _authService.me();
      _setOutput('Me OK\nUser: ${user.fullName} (${user.email})');
    } catch (e) {
      _setOutput('Me failed: $e');
    }
  }

  Future<void> _fetchProjects() async {
    setState(() => _loading = true);
    try {
      final dio = GetIt.I<DioClient>().dio;
      final res = await dio.get('/projects');
      _setOutput('Projects:\n${res.data}');
    } catch (e) {
      _setOutput('Projects failed: $e');
    }
  }

  void _logout() {
    _token = null;
    setAccessToken(null);
    _setOutput('Logged out (client-side only).');
  }

  void _setOutput(String msg) {
    setState(() {
      _output = msg;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'e.g. user@taskflow.dev',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _me,
                    child: const Text('Me'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _fetchProjects,
                    child: const Text('Projects'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _logout,
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstNameCtrl,
              decoration: const InputDecoration(
                labelText: 'First Name (for register)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Last Name (for register)',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(_output ?? 'Output will appear here.'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
