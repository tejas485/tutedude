import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/sidebar_modules/profile_settings_view.dart'; // FIXED: Aligned target uri to the correct module file
import '../widgets/groups_tab_view.dart';
import '../widgets/message_tab_view.dart';
import '../widgets/notification_overlay.dart';
import '../widgets/task_stream_view.dart';
import '../widgets/task_dialogs.dart';
import '../widgets/sidebar_modules/official_drawer_hub.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _activeTab = 'tasks';
  bool _isDarkMode = false;
  String? _globalSelectedGroupId;
  String _searchKeyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getRailIndex() {
    if (_activeTab == 'tasks') return 0;
    if (_activeTab == 'groups') return 1;
    if (_activeTab == 'messages') return 2;
    return 3;
  }

  void _handleTabSwitch(String tabKey) {
    setState(() => _activeTab = tabKey);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool useInlineSidebar = screenWidth >= 1024;

    return Theme(
      data: _isDarkMode ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Toggle Navigation Control Center',
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text(_activeTab.toUpperCase()),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
            const NotificationOverlay(),
            const SizedBox(width: 16),
          ],
        ),
        drawer: OfficialDrawerHub(
          selectedGroupId: _globalSelectedGroupId,
          onGroupChanged: (id) => setState(() => _globalSelectedGroupId = id),
          onTabChanged: _handleTabSwitch,
          onLogoutTap: () async {
            Navigator.pop(context);
            await _authService.signOut();
          },
        ),
        body: Row(
          children: [
            if (useInlineSidebar)
              NavigationRail(
                labelType: NavigationRailLabelType.all,
                selectedIndex: _getRailIndex(),
                onDestinationSelected: (idx) {
                  if (idx == 0) _handleTabSwitch('tasks');
                  if (idx == 1) _handleTabSwitch('groups');
                  if (idx == 2) _handleTabSwitch('messages');
                  if (idx == 3) _handleTabSwitch('profile');
                  if (idx == 4) _authService.signOut();
                },
                extended: screenWidth > 1200,
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.playlist_add_check), label: Text('Tasks')),
                  NavigationRailDestination(icon: Icon(Icons.group), label: Text('Groups')),
                  NavigationRailDestination(icon: Icon(Icons.message), label: Text('Messages')),
                  NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Profile')),
                  NavigationRailDestination(icon: Icon(Icons.exit_to_app, color: Colors.red), label: Text('Logout')),
                ],
              ),
            if (useInlineSidebar) const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  if (_activeTab == 'tasks')
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '🔍 Search decrypted tasks or locations...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchKeyword.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchKeyword = '');
                            },
                          )
                              : null,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (val) => setState(() => _searchKeyword = val),
                      ),
                    ),
                  Expanded(child: _renderActiveViewBody()),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _activeTab == 'tasks'
            ? FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('New Task'),
          onPressed: () => TaskDialogs.showAddTaskModal(context, (title, loc, start, end, priority) {
            _dbService.addTodo(
              title: title,
              groupId: _globalSelectedGroupId,
              location: loc,
              startTime: start,
              endTime: end,
              priority: priority,
            );
          }),
        )
            : null,
      ),
    );
  }

  Widget _renderActiveViewBody() {
    if (_activeTab == 'groups') {
      return GroupsTabView(onGroupSelected: (id) {
        setState(() {
          _globalSelectedGroupId = id;
          _activeTab = 'tasks';
        });
      });
    }
    if (_activeTab == 'messages') return const MessageTabView();
    if (_activeTab == 'profile') return const ProfileSettingsView(); // Verified type mapping resolution
    return TaskStreamView(selectedGroupId: _globalSelectedGroupId, searchKeyword: _searchKeyword);
  }
}
