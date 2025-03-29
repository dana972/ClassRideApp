import 'package:flutter/material.dart';
import 'screens/client.dart';

void main() {
  runApp(const ClassRideApp());
}

class ClassRideApp extends StatelessWidget {
  const ClassRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Ride App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ClientPage(),
    );
  }
}
