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

  /// converts the registration data into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
    };
  }
}