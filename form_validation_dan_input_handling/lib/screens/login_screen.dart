import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_button.dart';
import 'profile_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Focus nodes
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      final savedPassword = prefs.getString('saved_password');

      if (savedEmail != null && savedPassword != null) {
        setState(() {
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;
          _rememberMe = true;
        });
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user exists (dalam real app, ini akan check ke API)
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        final userData = json.decode(userDataString);
        if (userData['email'] == _emailController.text &&
            userData['password'] == _passwordController.text) {
          if (_rememberMe) {
            await prefs.setString('saved_email', _emailController.text);
            await prefs.setString('saved_password', _passwordController.text);
          } else {
            await prefs.remove('saved_email');
            await prefs.remove('saved_password');
          }

          // Save login state
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_email', _emailController.text);

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
          return;
        }
      }

      // Jika login gagal
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email atau password salah'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: 80),
              const SizedBox(height: 32),
              const Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                focusNode: _emailFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _fieldFocusChange(_emailFocus, _passwordFocus);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _passwordFocus.unfocus();
                  _login();
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              const SizedBox(height: 24),
              LoadingButton(
                onPressed: _login,
                text: 'Login',
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        // Demo credentials
                        _emailController.text = 'demo@example.com';
                        _passwordController.text = 'password123';
                      },
                child: const Text('Gunakan Demo Credentials'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?'),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                    child: const Text('Daftar di sini'),
                  ),
                ],
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
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}
