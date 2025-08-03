// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'profile_setup.dart';
// import 'login.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({Key? key}) : super(key: key);

//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   final List<OnboardingPage> _pages = [
//     OnboardingPage(
//       image: 'assets/images/welcome.png',
//       title: 'Start Your Health Journey!',
//       description:
//           'Track your steps, water intake, and more with fun challenges.',
//       color: const Color(0xFF2D7868),
//     ),
//     OnboardingPage(
//       image: 'assets/images/badge.png',
//       title: 'Earn Badges & Rewards',
//       description:
//           'Achieve daily goals to unlock exciting badges and milestones.',
//       color: const Color(0xFF64B39A),
//     ),
//     OnboardingPage(
//       image: 'assets/images/health.png',
//       title: 'Stay Active & Healthy',
//       description: 'Get reminders for active breaks and nutritious meals.',
//       color: const Color(0xFF7CCE97),
//     ),
//   ];

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFF0C2521),
//                   Color(0xFF2D7868),
//                   Color(0xFFA2DCA3),
//                 ],
//                 stops: [0.0, 0.5, 1.0],
//               ),
//             ),
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: _pages.length,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//               itemBuilder: (context, index) {
//                 return OnboardingPageWidget(page: _pages[index]);
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 120,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildPageIndicator(),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 20,
//             right: 20,
//             child: _currentPage == _pages.length - 1
//                 ? ElevatedButton(
//                     onPressed: _navigateToProfileSetup,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF64B39A),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text(
//                       'Set Up Profile',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: _completeOnboarding,
//                         child: const Text(
//                           'Skip',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             shadows: [
//                               Shadow(
//                                 blurRadius: 2.0,
//                                 color: Colors.black45,
//                                 offset: Offset(1, 1),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           _pageController.nextPage(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeIn,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0C2521),
//                           shape: const CircleBorder(),
//                           padding: const EdgeInsets.all(16),
//                         ),
//                         child: const Icon(
//                           Icons.arrow_forward,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildPageIndicator() {
//     return List<Widget>.generate(_pages.length, (index) {
//       return Container(
//         width: 12,
//         height: 12,
//         margin: const EdgeInsets.symmetric(horizontal: 6),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: _currentPage == index
//               ? const Color(0xFF7CCE97)
//               : const Color(0xFFA2DCA3).withOpacity(0.4),
//         ),
//       );
//     });
//   }

//   Future<void> _navigateToProfileSetup() async {
//     await _requestPermissions();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
//     );
//   }

//   Future<void> _completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_completed', true);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   Future<void> _requestPermissions() async {
//     await Permission.activityRecognition.request();
//     await Permission.notification.request();
//   }
// }

// class OnboardingPage {
//   final String image;
//   final String title;
//   final String description;
//   final Color color;

//   OnboardingPage({
//     required this.image,
//     required this.title,
//     required this.description,
//     required this.color,
//   });
// }

// class OnboardingPageWidget extends StatelessWidget {
//   final OnboardingPage page;

//   const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             height: 300,
//             width: double.infinity,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Stack(
//                 children: [
//                   Image.asset(
//                     page.image,
//                     fit: BoxFit.cover,
//                     height: 300,
//                     width: double.infinity,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           page.color.withOpacity(0.5),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 40),
//           Text(
//             page.title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               letterSpacing: 1.2,
//               shadows: const [
//                 Shadow(
//                   blurRadius: 2.0,
//                   color: Colors.black45,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               page.description,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//                 height: 1.6,
//                 shadows: [
//                   Shadow(
//                     blurRadius: 2.0,
//                     color: Colors.black45,
//                     offset: Offset(1, 1),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
