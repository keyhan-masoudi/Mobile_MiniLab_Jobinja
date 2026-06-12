// lib/presenters/auth_presenter.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../services/mock_api_service.dart';
import '../utils/constants.dart';

// Contract defining the required UI methods for Authentication screens
abstract class AuthViewContract {
  void showLoading();
  void hideLoading();
  void onLoginSuccess(User user);
  void onSignupSuccess(User user);
  void onLogoutSuccess();
  void showError(String message);
}

class AuthPresenter {
  final AuthViewContract _view;
  final MockApiService _apiService;

  AuthPresenter(this._view) : _apiService = MockApiService();

  // Executes the login request and saves session locally on success
  Future<void> login(String email, String password) async {
    _view.showLoading();
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.login(request);
      
      if (response.success && response.data != null) {
        await _saveUser(response.data!);
        _view.onLoginSuccess(response.data!);
      } else {
        _view.showError(response.message ?? 'Login failed. Please check your credentials.');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }

  // Executes the registration request and saves session locally on success
  Future<void> signup(String name, String email, String password) async {
    _view.showLoading();
    try {
      final request = SignupRequest(name: name, email: email, password: password);
      final response = await _apiService.signup(request);
      
      _view.hideLoading();
      
      if (response.success && response.data != null) {
        await _saveUser(response.data!);
        _view.onSignupSuccess(response.data!);
      } else {
        _view.showError(response.message ?? 'Registration failed. Email might already be in use.');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }

  // Clears server session and removes local cache
  Future<void> logout() async {
    _view.showLoading();
    try {
      await _apiService.logout();
      await _clearUser();
      
      _view.hideLoading();
      _view.onLogoutSuccess();
    } catch (e) {
      _view.hideLoading();
      _view.showError('Logout failed. Please try again.');
    }
  }

  // Retrieves the cached user for auto-login features on app startup
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(Constants.userKey);
    
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    }
    return null;
  }

  // Helper method to store user data and token in SharedPreferences
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.userKey, jsonEncode(user.toJson()));
    
    if (user.token != null) {
      await prefs.setString(Constants.tokenKey, user.token!);
    }
  }

  // Helper method to clear all session data from the device
  Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.userKey);
    await prefs.remove(Constants.tokenKey);
  }
}