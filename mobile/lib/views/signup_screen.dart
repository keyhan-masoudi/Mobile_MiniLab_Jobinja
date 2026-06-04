// lib/views/signup_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../presenters/auth_presenter.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// Implements AuthViewContract to connect this UI with the AuthPresenter
class _SignupScreenState extends State<SignupScreen> implements AuthViewContract {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AuthPresenter _presenter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the presenter and attach this view to it
    _presenter = AuthPresenter(this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- AuthViewContract Implementation ---

  @override
  void showLoading() => setState(() => _isLoading = true);

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void onLoginSuccess(User user) {} // Not used on the Signup Screen

  @override
  void onSignupSuccess(User user) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to the Home Screen and clear the backstack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
    );
  }

  @override
  void onLogoutSuccess() {} // Not used on the Signup Screen

  @override
  void showError(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // --- UI Action Handlers ---

  void _submit() {
    // Validate the form before calling the presenter
    if (_formKey.currentState!.validate()) {
      _presenter.signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // Jobinja Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A56DB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.work, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Jobinja',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A56DB),
                  ),
                ),
                const SizedBox(height: 6),
                
                const Text(
                  'Create a new account',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 36),
                
                // Name Input
                CustomTextField(
                  label: 'Full Name',
                  hint: 'e.g., John Doe',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  keyboardType: TextInputType.name,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                
                // Email Input
                CustomTextField(
                  label: 'Email Address',
                  hint: 'example@email.com',
                  controller: _emailController,
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                
                // Password Input
                CustomTextField(
                  label: 'Password',
                  hint: 'Minimum 6 characters',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                
                // Confirm Password Input
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Repeat your password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                
                // Submit Button
                CustomButton(
                  text: 'Sign Up',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
                
                // Navigation to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF1A56DB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}