import 'package:flutter/material.dart';

class MockUser {
  final String uid;
  final String? email;
  final String? displayName;

  MockUser({required this.uid, this.email, this.displayName});
}

class MockAuthService extends ChangeNotifier {
  MockUser? _user;
  bool _isLoggedIn = false;

  MockUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  // Method untuk langsung set user tanpa sign in
  void setMockUser() {
    _user = MockUser(
      uid: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: 'demo@brewmate.com',
      displayName: 'BrewMate Demo User',
    );
    _isLoggedIn = true;
    notifyListeners();
    print('✅ Mock user set: ${_user?.email}');
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    print('🔐 Mock sign in for: $email');

    await Future.delayed(const Duration(seconds: 1));

    _user = MockUser(
      uid: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@')[0],
    );
    _isLoggedIn = true;
    notifyListeners();

    print('✅ Mock login successful: ${_user?.email}');
    return null;
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    print('📝 Mock sign up for: $email');

    await Future.delayed(const Duration(seconds: 1));

    _user = MockUser(
      uid: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
    );
    _isLoggedIn = true;
    notifyListeners();

    print('✅ Mock registration successful: ${_user?.email}');
    return null;
  }

  Future<String?> resetPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
    print('📧 Mock password reset email sent to: $email');
    return null;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
    print('🚪 Mock user signed out');
  }
}
