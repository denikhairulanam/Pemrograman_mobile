// main.dart
import 'package:flutter/material.dart';
import 'pages/dosen_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Feedback Dosen',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const DosenListPage(), // Ganti ke DosenListPage sebagai home
      debugShowCheckedModeBanner: false,
    );
  }
}
