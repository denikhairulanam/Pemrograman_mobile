import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Signing in with Firebase: $email');

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase login successful: ${result.user?.email}');
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase login failed: ${e.code} - ${e.message}');

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
          break;
        case 'wrong-password':
          message = 'Password salah. Silakan coba lagi.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan login. Coba lagi nanti.';
          break;
        default:
          message = 'Terjadi kesalahan saat login: ${e.message}';
      }

      return message;
    } catch (e) {
      print('❌ Unexpected error during login: $e');
      return 'Terjadi kesalahan tak terduga: $e';
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      print('📝 Signing up with Firebase: $email');

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(displayName);

      print('✅ Firebase registration successful: ${result.user?.email}');
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase registration failed: ${e.code} - ${e.message}');

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar. Silakan gunakan email lain.';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'operation-not-allowed':
          message = 'Pendaftaran akun dinonaktifkan sementara.';
          break;
        default:
          message = 'Terjadi kesalahan saat pendaftaran: ${e.message}';
      }

      return message;
    } catch (e) {
      print('❌ Unexpected error during registration: $e');
      return 'Terjadi kesalahan tak terduga: $e';
    }
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('📧 Password reset email sent to: $email');
      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ Password reset failed: ${e.code} - ${e.message}');

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Email tidak ditemukan.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        default:
          message = 'Terjadi kesalahan saat reset password: ${e.message}';
      }

      return message;
    } catch (e) {
      print('❌ Unexpected error during password reset: $e');
      return 'Terjadi kesalahan tak terduga: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('🚪 User signed out from Firebase');
      notifyListeners();
    } catch (e) {
      print('❌ Error during sign out: $e');
      throw e;
    }
  }
}
