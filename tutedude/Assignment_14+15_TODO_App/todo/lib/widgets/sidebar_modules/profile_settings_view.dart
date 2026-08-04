import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../task_dialogs.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Security Credentials Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(currentUid).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox();
                final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                final String userUniqueId = data['uniqueId'] ?? '@generating_id...';

                return Card(
                  color: Colors.deepPurple.withValues(alpha: 0.05),
                  child: ListTile(
                    leading: const Icon(Icons.alternate_email, color: Colors.deepPurple),
                    title: const Text('My Unique Workspace Handle ID', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    subtitle: Text(userUniqueId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple)),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy Unique ID Handle String',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: userUniqueId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Unique ID tag copied to clipboard!')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 32),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Change Display Name', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                bool proceed = await TaskDialogs.confirmAction(
                  context,
                  "Confirm Update",
                  "Do you want to change your public display name string moniker across the team directory index?",
                );
                if (proceed) _dbService.updateProfileDisplayName(_nameCtrl.text);
              },
              child: const Text('Update Profile Name'),
            ),
            const Divider(height: 40),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'New Primary Email Login Address ID', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                bool proceed = await TaskDialogs.confirmAction(
                  context,
                  "Confirm Update",
                  "A verification email tracker will be dispatched to register your new Email Login ID. Proceed?",
                );
                if (proceed) _authService.updateAccountEmail(_emailCtrl.text);
              },
              child: const Text('Verify & Change Email ID'),
            ),
            const Divider(height: 40),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'New Secret Password Account Token', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                bool proceed = await TaskDialogs.confirmAction(
                  context,
                  "Confirm Update",
                  "Are you sure you want to change your login password entry token?",
                );
                if (proceed) _authService.updateAccountPassword(_passCtrl.text);
              },
              child: const Text('Commit Password Token Change'),
            ),
          ],
        ),
      ),
    );
  }
}
