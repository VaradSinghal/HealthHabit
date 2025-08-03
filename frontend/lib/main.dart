import 'package:flutter/material.dart';
import 'package:healthhabit/screens/auth/login_screen.dart';
import 'package:healthhabit/screens/onboarding/onboarding_screen.dart';
import 'package:healthhabit/services/shared_prefs.dart';
import 'package:healthhabit/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboardingCompleted = await SharedPrefs().isOnboardingCompleted();
  
  runApp(MyApp(
    onboardingCompleted: onboardingCompleted,
  ));
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;
  
  const MyApp({Key? key, required this.onboardingCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Habit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: onboardingCompleted ? LoginScreen() : OnboardingScreen(),
    );
  }
}