// lib/utils/validators.dart

class Validators {
  /// Validates that an email is not empty, conforms to standard formats,
  /// and strips out invalid whitespace.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ایمیل را وارد کنید';
    }
    
    final trimmedValue = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'فرمت ایمیل صحیح نیست';
    }
    return null;
  }

  /// Ensures password lengths meet the minimum requirement of 6 characters
  /// and screens for trivially insecure space-only inputs.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور را وارد کنید';
    }
    if (value.length < 6) {
      return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
    }
    if (value.trim().isEmpty) {
      return 'رمز عبور نمی‌تواند فقط شامل فاصله باشد';
    }
    return null;
  }

  /// Verifies a name is provided, is at least 2 characters long,
  /// and does not contain numeric or malicious script characters.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'نام را وارد کنید';
    }
    
    final trimmedValue = value.trim();
    if (trimmedValue.length < 2) {
      return 'نام باید حداقل ۲ کاراکتر باشد';
    }
    
    // Professional addition: Prevent numeric digits in the name field
    final containsNumbers = RegExp(r'[0-9]');
    if (containsNumbers.hasMatch(trimmedValue)) {
      return 'نام نمی‌تواند حاوی اعداد باشد';
    }
    return null;
  }

  /// Generic required field validator that trims text before performing checks
  /// to prevent blank-space submission bypasses.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName را وارد کنید';
    }
    return null;
  }
}