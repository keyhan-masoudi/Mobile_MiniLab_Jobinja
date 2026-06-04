import 'package:flutter/material.dart';

class AppColors {
  // Jobinja corporate blue theme
  static const Color primary = Color(0xFF006494); 
  static const Color accent = Color(0xFF24A0ED);
  
  // Scaffolding layout and canvas background configurations
  static const Color background = Color(0xFFF4F6F8);
  static const Color cardBackground = Colors.white;
  
  // Explicit typographic color states
  static const Color textPrimary = Color(0xFF2B2D42);
  static const Color textSecondary = Color(0xFF8D99AE);
  
  // Status and error validation colors
  static const Color error = Color(0xFFD90429);
  static const Color success = Color(0xFF38B000);
}

class Constants {
  // Mock API Base URL (Mandated by assignment guidelines)
  static const String mockBaseUrl = 'http://localhost:3000/api';

  // Real Jobinja Base URL references
  static const String jobinjaBaseUrl = 'https://jobinja.ir';
  static const String jobinjaApiBase = 'https://jobinja.ir/api/v10';

  // Local Session Storage Keys (SharedPreferences / Hydrated States)
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Global Pagination rules
  static const int perPage = 20;
}