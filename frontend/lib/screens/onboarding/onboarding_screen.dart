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
    return Scaffold(
      body: Stack(
        children: [
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
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => _buildPage(_pages[index]),
            ),
          ),
          _buildIndicators(),
          _buildNavigationButtons(),
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
          Expanded(child: Image.asset(page.image, fit: BoxFit.contain)),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Row(
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
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: _currentPage == _pages.length - 1
          ? ElevatedButton(
              onPressed: _completeOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                FloatingActionButton(
                  onPressed: _nextPage,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_forward,
                    color: _pages[_currentPage].color,
                  ),
                ),
              ],
            ),
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
