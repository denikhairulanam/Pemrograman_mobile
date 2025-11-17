import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/feedback_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CampusFeedbackApp());
}

class CampusFeedbackApp extends StatelessWidget {
  const CampusFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedbackService(),
      child: MaterialApp(
        title: 'Flutter Campus Feedback',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
