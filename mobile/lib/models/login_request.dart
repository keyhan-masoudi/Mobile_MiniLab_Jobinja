// lib/models/login_request.dart

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  /// Converts the typed request object into a JSON map ready to be 
  /// sent as the body of an HTTP POST request.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}