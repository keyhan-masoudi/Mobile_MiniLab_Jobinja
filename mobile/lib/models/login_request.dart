class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  /// Converts the typed request object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}