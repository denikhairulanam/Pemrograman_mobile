import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/survey_screen.dart';
import 'screens/survey_summary_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Forms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const ProfileScreen() : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/survey': (context) => const SurveyScreen(),
        '/survey-summary': (context) => const SurveySummaryScreen(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_logged_in') ?? false;
    } catch (e) {
      return false;
    }
  }
}
