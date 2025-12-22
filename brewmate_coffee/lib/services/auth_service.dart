import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign up with email and password
  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user!.updateDisplayName(displayName);

      // Create user document in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'displayName': displayName,
        'createdAt': DateTime.now().toIso8601String(),
        'preferences': {
          'defaultCoffeeType': 'espresso',
          'defaultCupSize': 'medium',
          'defaultStrength': 'regular',
        },
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  // Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login for: $email');

      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(), // PASTIKAN .trim()
        password: password,
      );

      print('✅ Login successful for: ${credential.user?.email}');
      print('   User ID: ${credential.user?.uid}');

      return null; // Success
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      return _getErrorMessage(e.code); // Custom error message
    } catch (e) {
      print('❌ General Error: $e');
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah.';
      default:
        return 'Login gagal. Coba lagi.';
    }
  }
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  // Update user profile
  Future<String?> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      if (displayName != null && _user != null) {
        await _user!.updateDisplayName(displayName);
        await _firestore.collection('users').doc(_user!.uid).update({
          'displayName': displayName,
        });
      }
      if (photoURL != null && _user != null) {
        await _user!.updatePhotoURL(photoURL);
      }
      notifyListeners();
      return null;
    } catch (e) {
      return 'Gagal mengupdate profil';
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => _user != null;
}
