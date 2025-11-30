import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_button.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Focus nodes untuk navigasi antar field
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupAutoValidation();
  }

  void _setupAutoValidation() {
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus && _nameController.text.isNotEmpty) {
        _formKey.currentState?.validate();
      }
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _emailController.text.isNotEmpty) {
        _formKey.currentState?.validate();
      }
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus && _phoneController.text.isNotEmpty) {
        _formKey.currentState?.validate();
      }
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Validasi real-time untuk confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak sama';
    }

    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Harap perbaiki data yang masih salah');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if email already exists
      final existingUserData = prefs.getString('user_data');
      if (existingUserData != null) {
        final existingUser = json.decode(existingUserData);
        if (existingUser['email'] == _emailController.text) {
          _showErrorSnackBar('Email sudah terdaftar');
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Simpan data user
      final userData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'bio': 'Halo! Saya pengguna baru.',
        'birthDate': DateTime.now()
            .subtract(const Duration(days: 365 * 20))
            .toIso8601String(),
        'gender': 'Laki-laki',
        'profileImagePath': null, // Default null untuk foto profil
      };

      await prefs.setString('user_data', json.encode(userData));
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', _emailController.text.trim());

      if (!mounted) return;

      _showSuccessSnackBar('Registrasi berhasil!');

      // Navigate to profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Registrasi gagal: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _fillDemoData() {
    setState(() {
      _nameController.text = 'John Doe';
      _emailController.text = 'john.doe@example.com';
      _phoneController.text = '081234567890';
      _passwordController.text = 'password123';
      _confirmPasswordController.text = 'password123';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 32),

              // Form Fields
              _buildFormFields(),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const FlutterLogo(size: 80),
        const SizedBox(height: 24),
        const Text(
          'Buat Akun Baru',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          child: Text(
            'Isi data diri Anda untuk mulai menggunakan aplikasi',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center, // Pindah textAlign ke sini
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          label: 'Nama Lengkap',
          validator: Validators.validateName,
          focusNode: _nameFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _fieldFocusChange(context, _nameFocus, _emailFocus);
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _fieldFocusChange(context, _emailFocus, _phoneFocus);
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          label: 'Nomor Telepon',
          keyboardType: TextInputType.phone,
          validator: Validators.validatePhone,
          focusNode: _phoneFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _fieldFocusChange(context, _phoneFocus, _passwordFocus);
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          obscureText: _obscurePassword,
          validator: Validators.validatePassword,
          focusNode: _passwordFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _fieldFocusChange(context, _passwordFocus, _confirmPasswordFocus);
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Konfirmasi Password',
          obscureText: _obscureConfirmPassword,
          validator: _validateConfirmPassword,
          focusNode: _confirmPasswordFocus,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            _confirmPasswordFocus.unfocus();
            if (!_isLoading) {
              _register();
            }
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        LoadingButton(
          onPressed: _register,
          text: 'Daftar',
          isLoading: _isLoading,
          color: Colors.green,
        ),
        const SizedBox(height: 16),

        // Demo Data Button
        OutlinedButton(
          onPressed: _isLoading ? null : _fillDemoData,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Isi Data Demo'),
        ),
        const SizedBox(height: 16),

        // Login Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sudah punya akun?'),
            const SizedBox(width: 4),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
              child: const Text(
                'Login di sini',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }
}
