// lib/models/signup_request.dart

class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String? phone;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });

  /// Safely converts the registration data into a JSON map.
  /// Omits the 'phone' key entirely if the user did not provide one.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
    };
  }
}