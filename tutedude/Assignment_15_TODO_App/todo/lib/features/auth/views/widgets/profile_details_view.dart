import 'package:flutter/material.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../controllers/auth_controller.dart';

class ProfileDetailsView extends StatelessWidget {
  final AuthController auth;
  final ThemeController themeCtrl;
  final VoidCallback onEditPressed;

  const ProfileDetailsView({
    super.key,
    required this.auth,
    required this.themeCtrl,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('DetailsView'),
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: themeCtrl.getTintedSurface(context, strength: 0.15),
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          boxShadow: themeCtrl.getNeumorphicShadow(context),
          border: Border.all(
            color: themeCtrl.currentSeedColor.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 54,
              backgroundColor: themeCtrl.currentSeedColor,
              child: Text(
                auth.currentUsername.isNotEmpty
                    ? auth.currentUsername.substring(0, 1).toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '@${auth.currentUsername}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              auth.currentUser?.email ?? 'Connected client',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text('AES-256 Storage Active'),
            ),
            const ListTile(
              leading: Icon(Icons.shield_outlined),
              title: Text('Data Vault Isolated'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Modify Profile Details'),
              onPressed: onEditPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeCtrl.currentSeedColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
