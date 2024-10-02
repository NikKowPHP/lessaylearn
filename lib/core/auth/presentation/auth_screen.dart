import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submit() async {
    final authService = ref.read(authServiceProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    ref.read(isLoadingProvider.notifier).state = true;
    ref.read(authErrorProvider.notifier).state = null;

    try {
      if (_isLogin) {
        await authService.signIn(email, password);
      } else {
        final name = _nameController.text.trim();
        await authService.register(email, password, name);
      }
    } catch (e) {
      ref.read(authErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _signInWithGoogle() async {
    final authService = ref.read(authServiceProvider);
    ref.read(isLoadingProvider.notifier).state = true;
    ref.read(authErrorProvider.notifier).state = null;

    try {
      await authService.signInWithGoogle();
    } catch (e) {
      ref.read(authErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final authError = ref.watch(authErrorProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_isLogin ? 'Login' : 'Register'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isLogin)
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Name',
                  padding: const EdgeInsets.all(12),
                ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: true,
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoButton.filled(
                  child: Text(_isLogin ? 'Login' : 'Register'),
                  onPressed: _submit,
                ),
              const SizedBox(height: 12),
              CupertinoButton(
                child: const Text('Sign in with Google'),
                onPressed: _signInWithGoogle,
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                child: Text(_isLogin
                    ? 'Create an account'
                    : 'I already have an account'),
                onPressed: _toggleAuthMode,
              ),
              if (authError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    authError,
                    style: const TextStyle(color: CupertinoColors.destructiveRed),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}