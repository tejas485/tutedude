import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/constants/app_colors.dart';
import 'package:todo/core/theme/theme_controller.dart';
import 'package:todo/core/widgets/dynamic_loading_overlay.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/auth/views/profile_screen.dart';
import 'package:todo/features/auth/views/login_screen.dart';
import 'package:todo/features/todo/controllers/todo_controller.dart';
import 'package:todo/features/todo/models/todo_model.dart';
import 'package:todo/features/todo/views/widgets/color_palette_orbit.dart';
import 'package:todo/features/todo/views/widgets/overall_analytics_card.dart';
import 'package:todo/features/todo/views/widgets/task_list_item_card.dart';
import 'package:todo/features/todo/views/todo_form_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showColorsOrbit = false;
  late Color _localThemeColor;
  bool _isLocalColorInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLocalColorInitialized) {
      final themeCtrl = Provider.of<ThemeController>(context, listen: false);
      _localThemeColor = themeCtrl.currentSeedColor;
      _isLocalColorInitialized = true;
    }
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return AppColors.highPriority;
    if (priority == 'Medium') return AppColors.mediumPriority;
    return AppColors.lowPriority;
  }

  void _executeHardLogoutProtocol(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('🔒 High Security Exit'),
        content: const Text(
          'Are you sure you want to log out? This will disconnect network streams, revoke cloud auth tokens, and clear session runtime memory logs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay Secure'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final authCtrl = Provider.of<AuthController>(context, listen: false);

              // Executes the network-disabling safe purge logout protocol
              await authCtrl.completeHardPurgeLogout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
            child: const Text('Yes, Purge & Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showProgressAdjuster(BuildContext context, TodoModel item, Color activeColor) {
    int localPercent = item.progressPercent;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Logging Progress for: ${item.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Granular Status: $localPercent%', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: localPercent.toDouble(),
                min: 0,
                max: 100,
                divisions: 20,
                activeColor: activeColor,
                onChanged: (val) => setDialogState(() => localPercent = val.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: activeColor, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                item.progressPercent = localPercent;
                Provider.of<TodoController>(context, listen: false).saveTodo(item);
              },
              child: const Text('Really Update Task'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCtrl = Provider.of<TodoController>(context);
    final themeCtrl = Provider.of<ThemeController>(context, listen: true);
    final authCtrl = Provider.of<AuthController>(context, listen: true);
    final isDark = themeCtrl.isDarkMode(context);

    _localThemeColor = themeCtrl.currentSeedColor;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Secure Space ✨', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded, color: _localThemeColor),
                onPressed: () {
                  themeCtrl.toggleThemeMode(context);
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.palette_rounded, color: _localThemeColor),
                onPressed: () => setState(() => _showColorsOrbit = !_showColorsOrbit),
              ),
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: _localThemeColor),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
              IconButton(
                icon: Icon(Icons.logout_rounded, color: _localThemeColor),
                onPressed: () => _executeHardLogoutProtocol(context),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: todoCtrl.streamTodos(),
            builder: (context, snapshot) {
              double totalCompletionRatio = todoCtrl.getCompletionPercentage();
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    OverallAnalyticsCard(
                      totalCompletionRatio: totalCompletionRatio,
                      isDark: isDark,
                      themeCtrl: themeCtrl,
                      totalTasksCount: todoCtrl.todos.length,
                    ),
                    const SizedBox(height: 24),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todoCtrl.todos.length,
                      itemBuilder: (context, idx) {
                        final item = todoCtrl.todos[idx];
                        return Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.8),
                              borderRadius: const BorderRadius.all(Radius.circular(22)),
                            ),
                            child: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                          ),
                          onDismissed: (direction) {
                            todoCtrl.deleteTodo(item.id);
                          },
                          child: TaskListItemCard(
                            item: item,
                            themeCtrl: themeCtrl,
                            priorityColor: _getPriorityColor(item.priority),
                            onAdjustProgress: () => _showProgressAdjuster(context, item, _localThemeColor),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: _localThemeColor,
            child: const Icon(Icons.add_task, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodoFormScreen())),
          ),
        ),
        if (_showColorsOrbit)
          ColorPaletteOrbit(
            themeCtrl: themeCtrl,
            onClose: () => setState(() {
              _showColorsOrbit = false;
              _localThemeColor = themeCtrl.currentSeedColor;
            }),
          ),

        // Renders the chosen randomized animation form overlay during hard purge execution
        if (authCtrl.isPurging)
          const Positioned.fill(
            child: DynamicLoadingOverlay(
              textReason: "Executing Hard Purge... Revoking tokens and closing data tunnels safely.",
            ),
          ),
      ],
    );
  }
}
