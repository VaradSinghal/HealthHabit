// import 'package:flutter/material.dart' hide Badge;
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'login.dart';
// import 'package:healthhabit/models/user_profile.dart';
// import 'package:healthhabit/services/api_service.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _handleRegister() async {
//     if (_isLoading) return;

//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         final age = prefs.getInt('temp_age');
//         final fitnessGoals = prefs.getString('temp_fitnessGoals');
//         final dietaryPreferences = prefs.getString('temp_dietaryPreferences');

//         final profile = UserProfile(
//           age: age,
//           fitnessGoals: fitnessGoals,
//           dietaryPreferences: dietaryPreferences,
//           healthPoints: 0,
//         );

//         final user = User(
//           email: _emailController.text,
//           password: _passwordController.text,
//           profile: profile,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         );

//         final response = await http.post(
//           Uri.parse('https://healthhabit.onrender.com/api/auth/register'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(user.toJson()),
//         );

//         if (mounted) {
//           if (response.statusCode == 201) {
//             final data = jsonDecode(response.body);
//             final token = data['token'];
//             final userId = data['userId'] ?? data['_id'];
//             await prefs.setString('auth_token', token);
//             await prefs.setString('userId', userId);
//             await prefs.remove('temp_age');
//             await prefs.remove('temp_fitnessGoals');
//             await prefs.remove('temp_dietaryPreferences');

           
//             final goalsData = await ApiService.fetchGoals();
//             final badgesData = await ApiService.fetchBadges();
//             final goal = goalsData.isNotEmpty ? Goal.fromJson(goalsData) : null;
//             final badges = badgesData is List
//                 ? badgesData.map((b) => Badge.fromJson(b)).toList()
//                 : [Badge.fromJson(badgesData as Map<String, dynamic>)];
//             await prefs.setString('currentGoal', jsonEncode(goal?.toJson() ?? {}));
//             await prefs.setString('badges', jsonEncode(badges.map((b) => b.toJson()).toList()));

//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Registration successful!'),
//                 backgroundColor: Color(0xFF64B39A),
//               ),
//             );
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const LoginScreen()),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Registration failed: ${response.body}'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF0C2521), 
//               Color(0xFF2D7868), 
//               Color(0xFFA2DCA3), 
//             ],
//             stops: [0.0, 0.5, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 20),
//                   Text(
//                     'Create Your Health Account',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                       shadows: const [
//                         Shadow(
//                           blurRadius: 4.0,
//                           color: Colors.black45,
//                           offset: Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Start your personalized health journey',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white.withOpacity(0.9),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.person_add,
//                       color: Color(0xFF7CCE97), 
//                       size: 40,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 20,
//                             offset: Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             _buildTextField(
//                               label: 'Email',
//                               icon: Icons.email,
//                               keyboardType: TextInputType.emailAddress,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 if (!RegExp(
//                                   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                                 ).hasMatch(value)) {
//                                   return 'Please enter a valid email';
//                                 }
//                                 return null;
//                               },
//                               controller: _emailController,
//                             ),
//                             const SizedBox(height: 24),
//                             _buildTextField(
//                               label: 'Password',
//                               icon: Icons.lock,
//                               obscureText: true,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 if (value.length < 6) {
//                                   return 'Password must be at least 6 characters';
//                                 }
//                                 return null;
//                               },
//                               controller: _passwordController,
//                             ),
//                             const SizedBox(height: 36),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : _handleRegister,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF64B39A),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(vertical: 16),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 4,
//                                   shadowColor: const Color(0xFF2D7868),
//                                 ),
//                                 child: _isLoading
//                                     ? const SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(Colors.white),
//                                         ),
//                                       )
//                                     : const Text(
//                                         'REGISTER',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           letterSpacing: 0.5,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             SizedBox(
//                               width: double.infinity,
//                               child: OutlinedButton(
//                                 onPressed: _isLoading
//                                     ? null
//                                     : () {
//                                         Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => const LoginScreen()),
//                                         );
//                                       },
//                                 style: OutlinedButton.styleFrom(
//                                   foregroundColor: const Color(0xFF2D7868),
//                                   side: const BorderSide(
//                                     color: Color(0xFF2D7868),
//                                     width: 1.5,
//                                   ),
//                                   padding: const EdgeInsets.symmetric(vertical: 15),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   backgroundColor: Colors.white,
//                                 ),
//                                 child: const Text(
//                                   'BACK TO LOGIN',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 0.5,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     required TextEditingController controller,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(
//           color: Color(0xFF2D7868),
//           fontWeight: FontWeight.w500,
//         ),
//         prefixIcon: Icon(icon, color: const Color(0xFF2D7868)),
//         filled: true,
//         fillColor: const Color(0xFFF5F5F5),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(
//             color: Color(0xFF7CCE97),
//             width: 1.5,
//           ),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 16,
//         ),
//       ),
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       validator: validator,
//       style: const TextStyle(color: Colors.black87, fontSize: 16),
//     );
//   }
// }