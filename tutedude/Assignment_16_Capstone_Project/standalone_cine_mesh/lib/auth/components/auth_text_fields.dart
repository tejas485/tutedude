// lib/auth/components/auth_text_fields.dart
import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class AuthTextFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignUpMode;
  final VoidCallback onForgotPassword;

  const AuthTextFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isSignUpMode,
    required this.onForgotPassword,
  });

  @override
  State<AuthTextFields> createState() => _AuthTextFieldsState();
}

class _AuthTextFieldsState extends State<AuthTextFields> {
  bool _obscurePassword = true;
  String _passwordStrengthLabel = "";
  Color _passwordStrengthColor = Colors.transparent;
  double _passwordStrengthPercent = 0.0;
  bool _isEmailValid = true;

  @override
  void initState() {
    super.initState();
    // Attach live validation observers to our controller streams
    widget.emailController.addListener(_validateEmailFormat);
    widget.passwordController.addListener(_evaluatePasswordStrengthMetrics);
  }

  void _validateEmailFormat() {
    final text = widget.emailController.text.trim();
    if (text.isEmpty) {
      if (!_isEmailValid) setState(() => _isEmailValid = true);
      return;
    }
    // Standard RFC 5322 regex validation parsing matrix
    final bool valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text);
    if (_isEmailValid != valid) {
      setState(() => _isEmailValid = valid);
    }
  }

  void _evaluatePasswordStrengthMetrics() {
    final text = widget.passwordController.text;
    if (text.isEmpty) {
      setState(() {
        _passwordStrengthLabel = "";
        _passwordStrengthPercent = 0.0;
        _passwordStrengthColor = Colors.transparent;
      });
      return;
    }

    int score = 0;
    if (text.length >= 6) score++;
    if (text.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(text)) score++;
    if (RegExp(r'[0-9]').hasMatch(text)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(text)) score++;

    setState(() {
      if (score <= 1) {
        _passwordStrengthLabel = "Weak Node Security 🔴";
        _passwordStrengthColor = CinemaMeshTheme.errorCrimson;
        _passwordStrengthPercent = 0.25;
      } else if (score <= 3) {
        _passwordStrengthLabel = "Moderate Security Matrix 🟡";
        _passwordStrengthColor = CinemaMeshTheme.warningOrange;
        _passwordStrengthPercent = 0.60;
      } else {
        _passwordStrengthLabel = "Strong Vector Encryption 🟢";
        _passwordStrengthColor = CinemaMeshTheme.emeraldGreen;
        _passwordStrengthPercent = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📨 THE EMAIL INPUT CONTAINER WITH DYNAMIC ERROR METRICS
        TextField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            prefixIcon: const Icon(Icons.mail_outline, size: 20),
            errorText: _isEmailValid ? null : "Please enter a valid email structure",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // 🔑 THE PASSWORD INPUT CONTAINER WITH ANIMATED VISIBILITY EYE TOGGLE
        TextField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),

        // DYNAMIC ENCRYPTION STRENGTH LAYOUT MATRIX (ONLY VISIBLE ON ACCOUNT CREATIONS)
        if (widget.isSignUpMode && _passwordStrengthLabel.isNotEmpty) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_passwordStrengthLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _passwordStrengthColor)),
                Text("${(_passwordStrengthPercent * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: CinemaMeshTheme.mutedSubtleGrey)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _passwordStrengthPercent,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
              minHeight: 4,
            ),
          ),
        ],

        // FORGOT CREDENTIALS ROUTING TOGGLE LINK
        if (!widget.isSignUpMode)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: const Text('Forgot Password?', style: TextStyle(color: CinemaMeshTheme.electricBlue, fontSize: 12)),
            ),
          )
        else
          const SizedBox(height: 16),
      ],
    );
  }
}
