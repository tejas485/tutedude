// lib/auth/components/auth_error_handler.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/ui_dialogs.dart';

class AuthErrorHandler {
  /// Evaluates specific exception error codes to show user-friendly popup dialogs
  static void processException(BuildContext context, FirebaseAuthException exception) {
    String errorTitle = "Authentication Blocked";
    String errorBody = "An unexpected validation failure occurred. Please retry.";

    switch (exception.code) {
      case 'user-not-found':
      case 'invalid-credential':
        errorTitle = "Account Does Not Exist";
        errorBody = "No CineMesh profile matches those credentials. Check your email or toggle 'Create New Account' down below.";
        break;
      case 'wrong-password':
        errorTitle = "Incorrect Password";
        errorBody = "The password entered is incorrect. If you forgot your credentials, tap the 'Forgot Password?' helper link.";
        break;
      case 'invalid-email':
        errorTitle = "Malformed Email Address";
        errorBody = "The format of your email address is invalid (e.g., missing '@' or domain). Please verify and try again.";
        break;
      case 'email-already-in-use':
        errorTitle = "Email Already Registered";
        errorBody = "This email is already bound to an active AI lounge profile node. Switch to Sign In mode to access it.";
        break;
      case 'weak-password':
        errorTitle = "Weak Password";
        errorBody = "Your password is too simple. Firebase requires a password containing at least 6 characters.";
        break;
      case 'network-request-failed':
        errorTitle = "Network Connection Lost";
        errorBody = "Your mobile device lost connection to the server. Please check your data signal or Wi-Fi router.";
        break;
      case 'closed-by-user':
      case 'cancelled-popup-request':
        errorTitle = "Google Sign-In Aborted";
        errorBody = "You closed the Google account selector screen before completing the login process.";
        break;
    }

    CinemaUiDialogs.showWarningAlert(context, errorTitle, errorBody);
  }

  /// Intercepts platform-specific background popup cancellations
  static void handleGeneralCancellation(BuildContext context, String rawError) {
    final String errString = rawError.toLowerCase();
    if (errString.contains("cancelled") || errString.contains("user-cancelled") || errString.contains("popup-closed")) {
      CinemaUiDialogs.showWarningAlert(
          context,
          "Google Window Closed",
          "The Google login screen overlay was closed manually before authentication completed."
      );
    } else {
      CinemaUiDialogs.showWarningAlert(context, "Handshake Error", "An unhandled provider fault occurred: $rawError");
    }
  }
}
