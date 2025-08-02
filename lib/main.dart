import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;

  runApp(MyApp(hasCompletedOnboarding: hasCompletedOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MyApp({Key? key, required this.hasCompletedOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Habit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: hasCompletedOnboarding ? const LoginScreen() : const OnboardingScreen(),
    );
  }
}