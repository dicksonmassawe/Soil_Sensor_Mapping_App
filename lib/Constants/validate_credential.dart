class PasswordValidator {
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Enter a longer password';
    }

    return null; // Return null if the password is valid
  }
}

class EmailValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    // You can add more complex email validation logic if needed
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }

    // Return null if the email is valid
    return null;
  }
}
