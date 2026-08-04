import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

class ProfileSettingsDialog {
  static void show(BuildContext context) {
    final dbService = DatabaseService();
    final currentName = FirebaseAuth.instance.currentUser?.displayName ?? '';
    final nameController = TextEditingController(text: currentName);
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.manage_accounts, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('My Profile Settings'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update your display name across your team workspace layouts:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Workspace Display Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_pin),
                ),
                enabled: !isSaving,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                if (nameController.text.trim().isNotEmpty) {
                  setModalState(() => isSaving = true);
                  try {
                    await dbService.updateProfileDisplayName(nameController.text.trim());
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Display name updated successfully!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Update failed: $e')),
                      );
                    }
                  } finally {
                    setModalState(() => isSaving = false);
                  }
                }
              },
              child: isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
