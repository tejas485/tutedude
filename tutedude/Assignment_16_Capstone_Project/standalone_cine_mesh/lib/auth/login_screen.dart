// lib/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/theme_config.dart';
import '../components/ui_dialogs.dart';
import 'components/auth_error_handler.dart';
import 'components/auth_text_fields.dart';
import 'components/auth_action_buttons.dart';

class StandaloneLoginScreen extends StatefulWidget {
  const StandaloneLoginScreen({super.key});
  @override
  State<StandaloneLoginScreen> createState() => _StandaloneLoginScreenState();
}

class _StandaloneLoginScreenState extends State<StandaloneLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUpMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _executeEmailAuthFlow() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CinemaUiDialogs.showWarningAlert(
          context,
          "Empty Input Fields",
          "Both the Email Address and Password boxes must be completed to proceed."
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUpMode) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) AuthErrorHandler.processException(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _triggerGoogleAccountSelectionPopup() async {
    setState(() => _isLoading = true);
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(googleProvider);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) AuthErrorHandler.processException(context, e);
    } catch (e) {
      if (mounted) AuthErrorHandler.handleGeneralCancellation(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _dispatchPasswordRecoveryEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      CinemaUiDialogs.showWarningAlert(
          context,
          "Missing Recovery Target",
          "Please type your email address first so we can send a password reset link."
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      messenger.showSnackBar(SnackBar(
        backgroundColor: CinemaMeshTheme.emeraldGreen,
        content: Text("Success: Password recovery link dispatched to $email"),
      ));
    } on FirebaseAuthException catch (e) {
      if (mounted) AuthErrorHandler.processException(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '🎬 Cinema AI Lounge',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? CinemaMeshTheme.primaryNeonRed : CinemaMeshTheme.darkTextGrey
                    )
                ),
                const SizedBox(height: 8),
                Text(
                    _isSignUpMode ? 'Register New Account Node' : 'Personalized Multi-Vector Recommendation Mesh',
                    style: const TextStyle(color: CinemaMeshTheme.mutedSubtleGrey, fontSize: 12),
                    textAlign: TextAlign.center
                ),
                const SizedBox(height: 30),
                AuthTextFields(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isSignUpMode: _isSignUpMode,
                  onForgotPassword: _dispatchPasswordRecoveryEmail,
                ),
                const SizedBox(height: 12),
                AuthActionButtons(
                  isLoading: _isLoading,
                  isSignUpMode: _isSignUpMode,
                  onEmailAuth: _executeEmailAuthFlow,
                  onGoogleAuth: _triggerGoogleAccountSelectionPopup,
                  onToggleMode: () => setState(() => _isSignUpMode = !_isSignUpMode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
