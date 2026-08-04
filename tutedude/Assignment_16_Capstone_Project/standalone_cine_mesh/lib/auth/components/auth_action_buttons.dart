// lib/auth/components/auth_action_buttons.dart
import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class AuthActionButtons extends StatelessWidget {
  final bool isLoading;
  final bool isSignUpMode;
  final VoidCallback onEmailAuth;
  final VoidCallback onGoogleAuth;
  final VoidCallback onToggleMode;

  const AuthActionButtons({
    super.key,
    required this.isLoading,
    required this.isSignUpMode,
    required this.onEmailAuth,
    required this.onGoogleAuth,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    // Renders a smooth, uniform loading spin loop to block double taps
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: CircularProgressIndicator(color: CinemaMeshTheme.primaryNeonRed),
      );
    }

    return Column(
      children: [
        // 1. PRIMARY APP CREDENTIAL TRANSACTION TRIGGER BUTTON
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CinemaMeshTheme.primaryNeonRed,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: onEmailAuth,
          child: Text(
            isSignUpMode ? 'Create Account' : 'Sign In',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),

        // 2. NATIVE GOOGLE SINGLE-SIGN-ON POPUP BUTTON
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: const BorderSide(color: Colors.white12),
          ),
          icon: const Icon(Icons.account_circle, color: CinemaMeshTheme.electricBlue, size: 20),
          label: Text(
            isSignUpMode ? 'Sign Up with Google' : 'Continue with Google',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          onPressed: onGoogleAuth,
        ),
        const SizedBox(height: 24),

        // 3. ECOSYSTEM MODE CONTEXT INTERCHANGE REFLECTOR LINK
        TextButton(
          onPressed: onToggleMode,
          child: Text(
            isSignUpMode ? 'Already have an account? Sign In' : 'New to Cinema AI? Create New Account',
            style: const TextStyle(color: CinemaMeshTheme.mutedSubtleGrey, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
