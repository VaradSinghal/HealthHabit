import 'package:flutter/material.dart';
import 'package:healthhabit/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _age;
  String _fitnessGoals = '';
  String _dietaryPreferences = '';
  bool _isFormValid = false;
  bool _isLoading = false;

  final List<String> _fitnessGoalOptions = [
    'Stay Active',
    'Lose Weight',
    'Build Muscle',
    'Improve Endurance',
    'General Wellness',
  ];

  final List<String> _dietaryPreferenceOptions = [
    'Balanced',
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Low-Carb',
  ];

  Future<void> _saveProfile() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    _validateForm();

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('temp_age', _age ?? 0);
      await prefs.setString('temp_fitnessGoals', _fitnessGoals);
      await prefs.setString('temp_dietaryPreferences', _dietaryPreferences);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _age != null &&
          _age! > 0 &&
          _fitnessGoals.isNotEmpty &&
          _dietaryPreferences.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4A1A), Color(0xFF1B5E20), Color(0xFF81C784)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Complete Your Profile',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us personalize your experience',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTextField(
                              label: 'Your Age',
                              icon: Icons.cake,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.parse(value) <= 0
                                  ? 'Please enter a valid age'
                                  : null,
                              onSaved: (value) {
                                _age = int.tryParse(value!);
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildDropdownField(
                              label: 'Fitness Goals',
                              icon: Icons.fitness_center,
                              value: _fitnessGoals,
                              items: _fitnessGoalOptions,
                              onChanged: (value) {
                                setState(() {
                                  _fitnessGoals = value!;
                                  _validateForm();
                                });
                              },
                              validator: (value) => value!.isEmpty
                                  ? 'Please select a goal'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            _buildDropdownField(
                              label: 'Dietary Preferences',
                              icon: Icons.restaurant,
                              value: _dietaryPreferences,
                              items: _dietaryPreferenceOptions,
                              onChanged: (value) {
                                setState(() {
                                  _dietaryPreferences = value!;
                                  _validateForm();
                                });
                              },
                              validator: (value) => value!.isEmpty
                                  ? 'Please select a preference'
                                  : null,
                            ),
                            const SizedBox(height: 36),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isFormValid && !_isLoading
                                    ? _saveProfile
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.green[800],
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        'SAVE PROFILE',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                        );
                                      },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E7D32),
                                  side: const BorderSide(
                                    color: Color(0xFF2E7D32),
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'CONTINUE AS GUEST',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.green[700]) : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      onChanged: (value) {
        _age = int.tryParse(value);
        _validateForm();
      },
      style: const TextStyle(color: Colors.black87, fontSize: 16),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    IconData? icon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value!.isNotEmpty ? value : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.green[700]) : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
    );
  }
}