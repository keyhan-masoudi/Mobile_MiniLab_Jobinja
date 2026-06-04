// lib/views/login_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../presenters/auth_presenter.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Implements AuthViewContract to connect this UI with the AuthPresenter
class _LoginScreenState extends State<LoginScreen> implements AuthViewContract {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- AuthViewContract Implementation ---

  @override
  void showLoading() => setState(() => _isLoading = true);

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void onLoginSuccess(User user) {
    if (!mounted) return;
    
    // Navigate to the Home Screen and clear the backstack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
    );
  }

  @override
  void onSignupSuccess(User user) {} // Not used on the Login Screen

  @override
  void onLogoutSuccess() {} // Not used on the Login Screen

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
      _presenter.login(
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
                const SizedBox(height: 40),
                
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
                  'Login to your account',
                  style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
                ),
                const SizedBox(height: 48),
                
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
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: Validators.validatePassword,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 12),
                
                // Forgot Password Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF1A56DB)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Submit Button
                CustomButton(
                  text: 'Login',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                
                // Demo credentials hint (useful for testing)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Color(0xFF1A56DB)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo account: test@example.com / 123456',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A56DB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                
                // Navigation to Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
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