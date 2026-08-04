class ValidationHelper {
  /// Enforces strict Instagram/GitHub-style username rules
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username handle cannot be left blank.';
    }

    final username = value.trim();
    if (username.length < 3 || username.length > 15) {
      return 'Username must be between 3 and 15 characters long.';
    }

    // Regex: Only lowercase, numbers, underscores, and periods allowed
    final validCharacters = RegExp(r'^[a-z0-9._]+$');
    if (!validCharacters.hasMatch(username)) {
      return 'Use only lowercase letters, numbers, underscores, or periods.';
    }

    if (username.startsWith('.') || username.startsWith('_') ||
        username.endsWith('.') || username.endsWith('_')) {
      return 'Symbols cannot be at the start or end.';
    }

    if (username.contains('..') || username.contains('__') ||
        username.contains('._') || username.contains('_.')) {
      return 'Consecutive special symbols are not allowed.';
    }

    return null; // Passed validation smoothly
  }

  /// Enforces corporate-grade secure password criteria
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be left blank.';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Enforces at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must include at least one uppercase letter (A-Z).';
    }

    // Enforces at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must include at least one lowercase letter (a-z).';
    }

    // Enforces at least one numerical digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must include at least one numeric digit (0-9).';
    }

    // Enforces at least one special character punctuation symbol
    if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
      return 'Include a special symbol (e.g., @, \$, !, %, *, ?, &).';
    }

    return null; // Passed validation smoothly
  }
}
