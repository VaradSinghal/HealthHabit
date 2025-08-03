import 'package:flutter/material.dart';
import 'package:healthhabit/screens/auth/login_screen.dart';
import 'package:healthhabit/services/shared_prefs.dart';
import 'package:permission_handler/permission_handler.dart';

import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: 'assets/images/welcome.png',
      title: 'Start Your Health Journey!',
      description:
          'Track your steps, water intake, and more with fun challenges.',
      color: const Color(0xFF2D7868),
    ),
    OnboardingPage(
      image: 'assets/images/badge.png',
      title: 'Earn Badges & Rewards',
      description:
          'Achieve daily goals to unlock exciting badges and milestones.',
      color: const Color(0xFF64B39A),
    ),
    OnboardingPage(
      image: 'assets/images/health.png',
      title: 'Stay Active & Healthy',
      description: 'Get reminders for active breaks and nutritious meals.',
      color: const Color(0xFF7CCE97),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonAreaHeight = screenHeight * 0.15; // Space for bottom buttons

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _pages[_currentPage].color.withOpacity(0.8),
                  _pages[_currentPage].color.withOpacity(0.4),
                ],
              ),
            ),
          ),

          // Page content
          Padding(
            padding: EdgeInsets.only(bottom: buttonAreaHeight),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => _buildPage(_pages[index]),
            ),
          ),

          // Indicators
          Positioned(
            bottom: buttonAreaHeight - 20, // Position above buttons
            left: 0,
            right: 0,
            child: _buildIndicators(),
          ),

          // Navigation buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: buttonAreaHeight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _buildNavigationButtons(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image takes 60% of available space
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(page.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 32),
          // Text content
          Column(
            children: [
              Text(
                page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  page.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _pages.map((page) {
        int index = _pages.indexOf(page);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return _currentPage == _pages.length - 1
        ? ElevatedButton(
            onPressed: _completeOnboarding,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _pages[_currentPage].color,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: _nextPage,
                backgroundColor: Colors.white,
                elevation: 4,
                child: Icon(
                  Icons.arrow_forward,
                  color: _pages[_currentPage].color,
                  size: 28,
                ),
              ),
            ],
          );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> _skipOnboarding() async {
    await _completeOnboarding();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _completeOnboarding() async {
    await SharedPrefs().setOnboardingCompleted(true);
    await _requestPermissions();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _requestPermissions() async {
    await [Permission.activityRecognition, Permission.notification].request();
  }
}
