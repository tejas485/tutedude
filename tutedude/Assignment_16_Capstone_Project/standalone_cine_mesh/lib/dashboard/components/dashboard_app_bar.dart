// lib/dashboard/components/dashboard_app_bar.dart
import '../dashboard_imports.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color currentAccent;
  final bool isDark;
  final VoidCallback onStateRefresh;

  const DashboardAppBar({
    super.key,
    required this.currentAccent,
    required this.isDark,
    required this.onStateRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark ? CinemaMeshTheme.surfaceSlate : currentAccent,
      title: const Text("Welcome Lounge", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_link, size: 20, color: CinemaMeshTheme.amberGold),
          tooltip: "Paste Kaggle Tunnel Link",
          onPressed: () => DashboardActionsHandler.pasteAndApplyKaggleTunnel(context, onStateRefresh),
        ),
        Builder(builder: (bCtx) => IconButton(icon: const Icon(Icons.palette, size: 18), onPressed: () => Scaffold.of(bCtx).openEndDrawer())),
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 18),
          onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
        ),
        IconButton(
          icon: const Icon(Icons.logout, size: 18),
          onPressed: () => CinemaUiDialogs.showActionConfirmation(
            context: context,
            title: "Sign Out Account",
            message: "Are you sure you want to end your dynamic Cinema lounge session?",
            confirmLabel: "Logout",
            onConfirm: () async {
              // 1. Process account token session revocation over firebase services
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              // 2. 🛡️ CRITICAL ROUTING FIX: Clears all active navigation sheets off the tree stack
              // and safely re-boots the root initialization gate switcher interface cleanly.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (routeCtx) => const AuthRouterSwitch()),
                    (Route<dynamic> route) => false, // This false modifier drops all previous routes instantly
              );
            },
          ),
        )
      ],
    );
  }
}
