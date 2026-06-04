// lib/main.dart

import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'presenters/auth_presenter.dart';
import 'models/user.dart';

void main() {
  runApp(const JobinjaApp());
}

class JobinjaApp extends StatelessWidget {
  const JobinjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobinja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A56DB),
          primary: const Color(0xFF1A56DB),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Updated to a standard English font
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A56DB),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A56DB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        cardTheme: const CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)), // Changed this line
                  ),
                ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Implement AuthViewContract directly to utilize the presenter cleanly
class _SplashScreenState extends State<SplashScreen> implements AuthViewContract {
  late AuthPresenter _authPresenter;

  @override
  void initState() {
    super.initState();
    // Initialize presenter to access SharedPreferences
    _authPresenter = AuthPresenter(this);
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Show the splash screen for at least 1.5 seconds for branding purposes
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    // Check for saved user session
    final savedUser = await _authPresenter.getSavedUser();

    if (!mounted) return;
    
    // Route to the appropriate screen based on login status
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => savedUser != null
            ? HomeScreen(user: savedUser)
            : const LoginScreen(),
      ),
    );
  }

  // --- AuthViewContract Implementation (Stubs for Splash Screen) ---
  @override void showLoading() {}
  @override void hideLoading() {}
  @override void onLoginSuccess(User user) {}
  @override void onSignupSuccess(User user) {}
  @override void onLogoutSuccess() {}
  @override void showError(String message) {}

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A56DB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.work,
                color: Color(0xFF1A56DB),
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            
            // App Name
            const Text(
              'Jobinja',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // App Tagline
            Text(
              'Online Job Search',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 60),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}