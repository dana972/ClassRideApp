import 'package:flutter/material.dart';
class DriverDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Dashboard")),
      body: Center(child: Text("Welcome Driver!")),
    );
  }
}