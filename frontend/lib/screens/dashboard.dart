import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF2D7868),
      ),
      body: const Center(
        child: Text(
          'Welcome to Your Health Dashboard!\n(Under Development)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
    );
  }
}