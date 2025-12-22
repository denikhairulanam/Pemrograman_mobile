// lib/main.dart (update providers)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/firebase_auth_service.dart';
import 'services/weather_service.dart'; // Add this
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/coffee_selection_screen.dart';
import 'screens/brewing_screen.dart';
import 'screens/location_permission_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = '/splash';

  // Check location permission and set initial route
  PermissionStatus status = await Permission.location.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    // Show location permission screen first
    initialRoute = '/location_permission';
  } else {
    // Permission already granted, go to splash
    initialRoute = '/splash';
  }
  print('Location permission status: $status');

  runApp(BrewMateApp(initialRoute: initialRoute));
}

class BrewMateApp extends StatefulWidget {
  final String initialRoute;

  const BrewMateApp({super.key, this.initialRoute = '/splash'});

  @override
  State<BrewMateApp> createState() => _BrewMateAppState();
}

class _BrewMateAppState extends State<BrewMateApp> {
  bool _firebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        _firebaseInitialized = true;
      });
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Error initializing Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_firebaseInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        // Use Firebase Auth Service
        ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => WeatherService()), // Add WeatherService
        Provider(create: (_) => FirestoreService()), // Add FirestoreService
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'BrewMate Coffee',
            theme: themeProvider.currentTheme,
            initialRoute: widget.initialRoute,
            routes: {
              '/location_permission': (context) =>
                  const LocationPermissionScreen(),
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/main': (context) => const MainNavigation(),
              '/selection': (context) => const CoffeeSelectionScreen(),
              '/brewing': (context) {
                final args = ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
                return BrewingScreen(preferences: args);
              },
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
