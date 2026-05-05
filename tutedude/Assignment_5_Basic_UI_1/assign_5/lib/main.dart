import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const Assign5App());

class Assign5App extends StatelessWidget {
  const Assign5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Concept Map"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategory(context, "A. UI Widgets", [
            _tile(context, "Scaffold", Icons.layers, const TextPage(title: "Scaffold", content: "The Scaffold is a top-level container for a Material app. It provides a default 'stage' for your UI elements. It manages the layout structure like the AppBar, Drawer, SnackBar, and BottomNavigationBar. Without a Scaffold, your app would lack the basic visual structure users expect in a mobile application.")),
            _tile(context, "AppBar", Icons.view_headline, const TextPage(title: "AppBar", content: "The AppBar is the horizontal bar usually displayed at the top of the screen. It typically contains the page title, navigation icons (like a back button or menu), and action buttons. It uses the 'PreferredSizeWidget' to ensure it fits the standard toolbar height across different devices.")),
            _tile(context, "Text", Icons.text_fields, const TextPage(title: "Text Widget", content: "The Text widget is the most basic building block for displaying strings. In Flutter, every piece of text must be wrapped in this widget. It allows you to control alignment, overflow behavior, and locale. When combined with TextStyle, it defines how the characters are rendered on screen.")),
            _tile(context, "Container", Icons.check_box_outline_blank, const TextPage(title: "Container", content: "A Container is a convenience widget that combines sizing, padding, and decoration. Think of it as a 'box' that can hold one child. You can give it a background color, borders, or rounded corners. It is the most used widget for creating custom UI shapes and spacing around elements.")),
            _tile(context, "Row & Column (Image Lab)", Icons.grid_view, const ImageUploadPage()),
          ]),
          _buildCategory(context, "B. Layout", [
            _tile(context, "Title Text", Icons.title, const TextPage(title: "Title Text Strategy", content: "Title text serves as the primary visual anchor of a page. It should be high-contrast and use a larger font size. Using titles effectively helps users immediately identify where they are in the application hierarchy. In Flutter, this is usually achieved by setting the fontWeight to bold.")),
            _tile(context, "Icons and Images", Icons.image, const TextPage(title: "Visual Assets", content: "Icons provide intuitive visual cues without needing translation, while Images provide rich content. Flutter supports Vector icons (Material Icons) and Raster images (PNG/JPG). Images can be loaded from the local 'assets' folder or from a network URL using Image.network.")),
            _tile(context, "Spacing & Alignment", Icons.format_align_center, const TextPage(title: "Alignment Logic", content: "Spacing is handled via SizedBox or Padding. Alignment ensures the UI looks professional on different screens. MainAxisAlignment and CrossAxisAlignment are the core properties used within Rows and Columns to distribute children either at the start, center, end, or spaced out evenly.")),
          ]),
          _buildCategory(context, "C. Styling", [
            _tile(context, "Color", Icons.palette, const TextPage(title: "Color Theory", content: "Colors in Flutter are managed via the Color class. You can use predefined palettes (Colors.blue) or ARGB values. Using .withValues(alpha: ...) allows you to create transparency. Consistency in color helps establish a brand identity and guides user interaction through visual feedback.")),
            _tile(context, "Padding & Margin", Icons.space_bar, const TextPage(title: "The Box Model", content: "Padding is the internal space between a container's border and its content. Margin is the external space between the container and other surrounding widgets. Proper use of EdgeInsets.all() or symmetric() ensures that UI elements don't feel crowded or touch the screen edges.")),
            _tile(context, "Font Size & Weight", Icons.text_format, const TextPage(title: "Typography", content: "Font size determines the scale of the text relative to the screen, while font weight (boldness) determines the importance. A 'w900' weight is thickest, while 'w100' is thinnest. For better readability, keep body text between 14-16 and titles between 20-28.")),
          ]),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo))),
      ...children,
      const SizedBox(height: 10),
    ]);
  }

  Widget _tile(BuildContext context, String title, IconData icon, Widget page) {
    return Card(child: ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => page)),
    ));
  }
}

// --- Page for Detailed Text ---
class TextPage extends StatelessWidget {
  final String title, content;
  const TextPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 20),
            Text(content, style: const TextStyle(fontSize: 16, height: 1.8, color: Colors.black87)),
            const SizedBox(height: 30),
            const Text("Example Use Case:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text("Developers use this concept to ensure that $title is applied correctly for better user experience.", style: const TextStyle(fontStyle: FontStyle.italic)),
            )
          ],
        ),
      ),
    );
  }
}

// --- Page for Image Upload (Row & Column) ---
class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});
  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pick() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _image = File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Row & Column Lab")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Demonstrating Row & Column using Image Shapes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: _pick, icon: const Icon(Icons.photo_library), label: const Text("Select Image")),
          if (_image != null) ...[
            const SizedBox(height: 30),
            const Text("Horizontal Row Display:"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_box(_image!, BoxShape.circle), _box(_image!, BoxShape.rectangle), _rhombus(_image!)],
            ),
            const SizedBox(height: 40),
            const Text("Vertical Column Display:"),
            const SizedBox(height: 10),
            Column(
              children: [_box(_image!, BoxShape.circle), const SizedBox(height: 15), _box(_image!, BoxShape.rectangle), const SizedBox(height: 15), _rhombus(_image!)],
            ),
          ]
        ],
      ),
    );
  }

  Widget _box(File img, BoxShape s) => Container(width: 70, height: 70, decoration: BoxDecoration(shape: s, borderRadius: s == BoxShape.circle ? null : BorderRadius.circular(10), image: DecorationImage(image: FileImage(img), fit: BoxFit.cover), border: Border.all(color: Colors.indigo)));

  Widget _rhombus(File img) => Transform.rotate(angle: 0.785, child: Container(width: 50, height: 50, decoration: BoxDecoration(image: DecorationImage(image: FileImage(img), fit: BoxFit.cover), border: Border.all(color: Colors.indigo))));
}
