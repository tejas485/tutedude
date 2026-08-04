import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _credentialController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthController>(context, listen: false)
          .signInWithEmailOrUsername(_credentialController.text.trim(), _passwordController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login problem: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showRecoveryDialog(bool isUsernameRecovery) {
    final recoveryController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isUsernameRecovery ? 'Find Your Username 🔍' : 'Reset Your Password 🔑'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isUsernameRecovery
                ? 'Enter your registered recovery details to locate your account identification.'
                : 'Enter your email address to receive a secure link.'),
            const SizedBox(height: 16),
            TextField(
              controller: recoveryController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                Widget accountChooserWidget = Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quick Account Chooser 👤', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: const Text('Continue with Google'),
                          onTap: () => Provider.of<AuthController>(context, listen: false).signInWithGoogle(),
                        ),
                      ],
                    ),
                  ),
                );

                Widget credentialsFormWidget = Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Traditional Sign In 📝', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _credentialController,
                            decoration: const InputDecoration(labelText: 'Email or Username', border: OutlineInputBorder()),
                            validator: (val) => val!.trim().isEmpty ? 'Required field.' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                            validator: (val) => val!.length >= 6 ? null : 'Minimum 6 chars.',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: () => _showRecoveryDialog(true), child: const Text('Forgot Username?')),
                              TextButton(onPressed: () => _showRecoveryDialog(false), child: const Text('Forgot Password?')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(onPressed: _handleLogin, child: const Text('Log In')),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                            child: const Text('Create Account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                if (constraints.maxWidth > 800) {
                  return Row(children: [Expanded(child: accountChooserWidget), const SizedBox(width: 16), Expanded(child: credentialsFormWidget)]);
                } else {
                  return Column(children: [accountChooserWidget, const SizedBox(height: 16), credentialsFormWidget]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
