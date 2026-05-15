import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterMegaGuideApp());
}

/// Dynamic State Management for Themes & Global Configuration
class FlutterMegaGuideApp extends StatefulWidget {
  const FlutterMegaGuideApp({super.key});

  @override
  State<FlutterMegaGuideApp> createState() => _FlutterMegaGuideAppState();
}

class _FlutterMegaGuideAppState extends State<FlutterMegaGuideApp> {
  int _activePaletteIndex = 0;
  bool _isDarkMode = false;

  // FIX 1: Strongly typed configurations to prevent Map value type mixing errors
  final List<Map<String, dynamic>> _palettes = [
    {
      'name': 'Nordic Mint',
      'primary': const Color(0xFF0F4C81),
      'secondary': const Color(0xFF45B6FE),
      'lightBg': const Color(0xFFF4F7F6),
      'darkBg': const Color(0xFF121824),
    },
    {
      'name': 'Sunset Orchid',
      'primary': const Color(0xFF7209B7),
      'secondary': const Color(0xFFF72585),
      'lightBg': const Color(0xFFFAF7FC),
      'darkBg': const Color(0xFF1A1224),
    },
    {
      'name': 'Forest Emerald',
      'primary': const Color(0xFF0A5C36),
      'secondary': const Color(0xFF00E676),
      'lightBg': const Color(0xFFF5F8F5),
      'darkBg': const Color(0xFF0D1B14),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentPalette = _palettes[_activePaletteIndex];
    final brightness = _isDarkMode ? Brightness.dark : Brightness.light;
    final scaffoldBg = _isDarkMode ? (currentPalette['darkBg'] as Color) : (currentPalette['lightBg'] as Color);
    final surfaceColor = _isDarkMode ? Color.alphaBlend(Colors.white10, currentPalette['darkBg'] as Color) : Colors.white;

    final themeData = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: currentPalette['primary'] as Color,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: currentPalette['primary'] as Color,
        brightness: brightness,
        primary: currentPalette['primary'] as Color,
        secondary: currentPalette['secondary'] as Color,
        surface: surfaceColor,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ultimate Flutter Setup Engine',
      theme: themeData,
      home: MasterTopicsScreen(
        activePaletteIndex: _activePaletteIndex,
        palettes: _palettes,
        isDarkMode: _isDarkMode,
        onPaletteChanged: (idx) => setState(() => _activePaletteIndex = idx),
        onModeToggle: (darkMode) => setState(() => _isDarkMode = darkMode),
      ),
    );
  }
}

class GuideTopic {
  final String title;
  final String subtitle;
  final IconData icon;
  final String referenceUrl;
  final List<Map<String, String>> structuralSteps;

  const GuideTopic({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.referenceUrl,
    required this.structuralSteps,
  });
}

final List<GuideTopic> globalGuideBook = [
  const GuideTopic(
    title: 'Windows Native Installation',
    subtitle: 'Full Desktop & Android Setup Blueprint',
    icon: Icons.window,
    referenceUrl: 'flutter.dev',
    structuralSteps: [
      {
        'heading': '1. Download & Extract Flutter SDK Engine',
        'desc': 'Obtain the latest stable Windows architecture zip package from the official repository. Create a safe structural folder directory at C:\\src\\flutter. Extract the zipped package directly inside using a clean extractor tool. Avoid installing into protected directories like Program Files.',
        'command': ''
      },
      {
        'heading': '2. Update System Environment Path Variables',
        'desc': 'In your Windows Search box, locate and select "Edit the system environment variables". Inside the environment menu, highlight the variable named "Path" and select edit. Click "New" and paste the exact direct path pointing to your extracted package: C:\\src\\flutter\\bin',
        // FIX 5: Added missing backslash context to validate native environment parsing
        'command': 'setx PATH "%PATH%;C:\\src\\flutter\\bin" /M'
      },
      {
        'heading': '3. Verify Integrity via Flutter Doctor Diagnostics',
        'desc': 'Launch an Elevated Administrative Command Prompt or PowerShell terminal session and clear your active path logs. Run the core checking engine script to verify dependencies like Git, Android Studio binaries, and system toolchains.',
        'command': 'flutter doctor -v'
      },
    ],
  ),
  const GuideTopic(
    title: 'macOS & iOS Deployment Setup',
    subtitle: 'Xcode, Apple Toolchain, and CocoaPods Runtime',
    icon: Icons.apple,
    referenceUrl: 'flutter.dev',
    structuralSteps: [
      {
        'heading': '1. Configure Advanced Apple Command Line Tools',
        'desc': 'Open your central macOS Zsh Terminal terminal console app. Fire up the core interactive license developer suite command to cleanly initialize underlying compiler binaries required by iOS native wrapper shells.',
        'command': 'xcode-select --install'
      },
      {
        'heading': '2. Agree to Native Xcode Development Licenses',
        'desc': 'Ensure complete developer operational workspace clearing by explicitly executing the global agreement confirmation pass. This ensures automated build packaging runner scripts do not fail due to unaccepted digital terms.',
        'command': 'sudo xcodebuild -license accept'
      },
      {
        'heading': '3. Install CocoaPods Dependency Management Engine',
        'desc': 'Inject the local Ruby ecosystem package manager used globally by Flutter platform hooks to pull underlying modular frameworks down for build compiling targets. Requires sudo permissions context.',
        'command': 'sudo gem install cocoapods'
      },
    ],
  ),
  const GuideTopic(
    title: 'Emulator & Hardware Integration',
    subtitle: 'Virtual Device System Images & Launch Triggers',
    icon: Icons.phone_android,
    referenceUrl: 'flutter.dev',
    structuralSteps: [
      {
        'heading': '1. Query Available Local Android Virtual Targets',
        'desc': 'List all current compiled Android Virtual Devices (AVD) images detected over your internal system. This exposes technical alphanumeric designations needed to spawn an instance directly outside of the main IDE workflow wrapper.',
        'command': 'flutter emulators'
      },
      {
        'heading': '2. Instantly Bootstrap Virtual Testing Targets',
        'desc': 'Manually execute the emulator platform launcher routine with the dedicated identity flag safely isolated to prevent resource blocking context freezes inside the principal testing window.',
        'command': 'flutter emulators --launch Pixel_6_API_33'
      },
    ],
  ),
];

class MasterTopicsScreen extends StatelessWidget {
  final int activePaletteIndex;
  final List<Map<String, dynamic>> palettes;
  final bool isDarkMode;
  final ValueChanged<int> onPaletteChanged;
  final ValueChanged<bool> onModeToggle;

  const MasterTopicsScreen({
    super.key,
    required this.activePaletteIndex,
    required this.palettes,
    required this.isDarkMode,
    required this.onPaletteChanged,
    required this.onModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderCol = isDarkMode ? Colors.white24 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Setup Core', style: TextStyle(fontWeight: FontWeight.w900)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        children: [
          Pseudo3DContainer(
            color: theme.colorScheme.surface,
            borderColor: theme.primaryColor,
            isDark: isDarkMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INTERFACE CONFIGURATOR',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.primaryColor, letterSpacing: 1.5),
                    ),
                    Row(
                      children: [
                        Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, size: 18, color: theme.primaryColor),
                        const SizedBox(width: 4),
                        Switch(
                          value: isDarkMode,
                          // FIX 4: Upgraded activeColor to activeThumbColor to respect the layout API deprecation pass
                          activeThumbColor: theme.primaryColor,
                          onChanged: onModeToggle,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(palettes.length, (idx) {
                    final isSelected = activePaletteIndex == idx;
                    final pColor = palettes[idx]['primary'] as Color;
                    return GestureDetector(
                      onTap: () => onPaletteChanged(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? pColor : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderCol, width: 2),
                          boxShadow: isSelected ? [BoxShadow(color: borderCol, offset: const Offset(2, 2))] : null,
                        ),
                        child: Text(
                          palettes[idx]['name'] as String, // FIX 2: Explicit cast to handle String parameters inside generic dynamic maps cleanly
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'SELECT STRUCTURAL PATHWAY',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: isDarkMode ? Colors.white60 : Colors.black54, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: globalGuideBook.length,
            itemBuilder: (context, idx) {
              final item = globalGuideBook[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Pseudo3DContainer(
                  color: theme.colorScheme.surface,
                  borderColor: theme.primaryColor,
                  isDark: isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailInstructionScreen(topic: item, isDarkMode: isDarkMode)),
                    );
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.15),
                      foregroundColor: theme.primaryColor,
                      radius: 26,
                      child: Icon(item.icon, size: 28),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(item.subtitle, style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.black54, fontSize: 13)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: theme.primaryColor, size: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailInstructionScreen extends StatelessWidget {
  final GuideTopic topic;
  final bool isDarkMode;
  const DetailInstructionScreen({super.key, required this.topic, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderCol = isDarkMode ? Colors.white30 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          Pseudo3DContainer(
            color: theme.colorScheme.secondary.withValues(alpha: 0.12),
            borderColor: borderCol,
            isDark: isDarkMode,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OFFICIAL VERIFIED MANUAL LINK',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white60 : Colors.black54, letterSpacing: 1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.referenceUrl,
                        style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy_all, color: theme.primaryColor),
                  tooltip: 'Copy URL Target',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: topic.referenceUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Target Document URL copied to Clipboard!')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: theme.primaryColor),
                  tooltip: 'Share System URL',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: 'Check out the official docs: ${topic.referenceUrl}'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing setup script string copied!')),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'EXECUTION RUNBOOK STEPS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: isDarkMode ? Colors.white60 : Colors.black54, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          ...topic.structuralSteps.map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol, width: 2),
                  boxShadow: [BoxShadow(color: borderCol, offset: const Offset(4, 4))],
                ),
                child: ExpansionTile(
                  iconColor: theme.primaryColor,
                  collapsedIconColor: isDarkMode ? Colors.white70 : Colors.black87,
                  title: Text(
                    step['heading']!,
                    // FIX 3: Replaced invalid 'whiteDF'/'blackDE' tags with standard high contrast color parameters
                    style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontSize: 15),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(color: borderCol, thickness: 1.5),
                          const SizedBox(height: 8),
                          Text(
                            step['desc']!,
                            style: TextStyle(fontSize: 14, height: 1.5, color: isDarkMode ? Colors.white70 : Colors.black87),
                          ),
                          if (step['command']!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: theme.primaryColor, width: 2),
                                boxShadow: [
                                  BoxShadow(color: theme.colorScheme.secondary, offset: const Offset(3, 3))
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        step['command']!,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          color: Color(0xFF00FF66),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy, color: Colors.white, size: 20),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: step['command']!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: theme.primaryColor,
                                          content: const Text('Terminal Script successfully copied!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class Pseudo3DContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final bool isDark;
  final VoidCallback? onTap;

  const Pseudo3DContainer({
    super.key,
    required this.child,
    required this.color,
    required this.borderColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shadowColor = isDark ? Colors.white12 : Colors.black87;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(5, 5),
              blurRadius: 0,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
