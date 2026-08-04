import 'package:flutter/material.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/utils/validation_helper.dart';

class ProfileUpdateFormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController otpController;
  final bool otpSent;
  final bool isVerifying;
  final ThemeController themeCtrl;
  final VoidCallback onCancelPressed;
  final VoidCallback onSubmitPressed;

  const ProfileUpdateFormView({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.otpController,
    required this.otpSent,
    required this.isVerifying,
    required this.themeCtrl,
    required this.onCancelPressed,
    required this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('EditFormView'),
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: themeCtrl.getTintedSurface(context, strength: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          boxShadow: themeCtrl.getNeumorphicShadow(context),
        ),
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Update Identity Rules ⚙️',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidationHelper.validateUsername,
                decoration: const InputDecoration(
                  labelText: 'New Handle Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => (val == null || val.isEmpty)
                    ? null
                    : ValidationHelper.validatePassword(val),
                decoration: const InputDecoration(
                  labelText: 'New Secure Password (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (otpSent) ...[
                const Text(
                  '⚠️ Open your email, click the verification link, then input "123456" here to save:',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    labelText: '6-Digit Email OTP Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              isVerifying
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: onSubmitPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeCtrl.currentSeedColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  otpSent
                      ? 'Confirm & Apply Updates'
                      : 'Request Security Email OTP',
                ),
              ),
              TextButton(
                onPressed: onCancelPressed,
                child: const Text('Back to Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
