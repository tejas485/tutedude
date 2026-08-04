import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Concept Lab',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MainMenu(),
    );
  }
}

// --- GLOBAL UTILS ---
void _showMsg(BuildContext context, {int? id, String? customMsg}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(customMsg ?? "Action handled for Item $id"),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

// --- MAIN MENU ---
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 247, 250),
      appBar: AppBar(
        title: const Text("UI Concept Lab", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _categoryTile(context, "A. Advanced Widgets", Icons.layers_outlined, Colors.orangeAccent, const AdvancedWidgetsScreen()),
          const SizedBox(height: 12),
          _categoryTile(context, "B. Displaying Data", Icons.auto_awesome_motion, Colors.blueAccent, const DisplayDataScreen()),
          const SizedBox(height: 12),
          _categoryTile(context, "C. User Interaction", Icons.fingerprint, Colors.purpleAccent, const InteractionScreen()),
        ],
      ),
    );
  }

  Widget _categoryTile(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => page)),
        ),
      ),
    );
  }
}

// --- SECTION A: ADVANCED WIDGETS ---
class AdvancedWidgetsScreen extends StatelessWidget {
  const AdvancedWidgetsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Advanced Widgets")),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: ["GridView", "ListView", "Card", "ListTile"].map((String t) => Card(
          child: ListTile(
              title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ConceptDetailPage(title: t)))
          )
      )).toList(),
    ),
  );
}

// --- SECTION B: DATA TOGGLE (50 ELEMENTS) ---
class DisplayDataScreen extends StatefulWidget {
  const DisplayDataScreen({super.key});

  @override
  State<DisplayDataScreen> createState() => _DisplayDataScreenState();
}

class _DisplayDataScreenState extends State<DisplayDataScreen> {
  bool isGridView = true;
  final List<Color> _colors = List.generate(50, (int i) => Colors.primaries[i % Colors.primaries.length]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Layouts"),
        actions: [
          Switch(
            value: isGridView,
            onChanged: (bool val) => setState(() => isGridView = val),
            activeThumbColor: Colors.teal,
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: isGridView ? _buildGrid() : _buildList(),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      key: const ValueKey("grid"),
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.9),
      itemCount: 50,
      itemBuilder: (context, i) => _cardItem(context, i),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      key: const ValueKey("list"),
      padding: const EdgeInsets.all(20),
      itemCount: 50,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SizedBox(height: 100, child: _cardItem(context, i)),
      ),
    );
  }

  Widget _cardItem(BuildContext context, int i) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [_colors[i], _colors[i].withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _showMsg(context, id: i + 1),
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Text("Item ${i + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ),
    );
  }
}

// --- SECTION C: INTERACTION LABORATORY ---
class InteractionScreen extends StatelessWidget {
  const InteractionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interaction Lab")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionLabel("1. Gesture Feedback (InkWell)", Colors.purple),
          const SizedBox(height: 10),
          _buildInkWellDemo(context),
          const SizedBox(height: 30),
          _sectionLabel("2. Advanced Gestures (Detector)", Colors.deepPurple),
          const SizedBox(height: 10),
          _buildGestureDemo(context),
          const SizedBox(height: 30),
          _sectionLabel("3. Swipe-to-Dismiss", Colors.redAccent),
          const SizedBox(height: 10),
          _buildDismissibleDemo(context),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) => Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color));

  Widget _buildInkWellDemo(BuildContext context) {
    return InkWell(
      onTap: () => _showMsg(context, customMsg: "Standard Tap with Ripple Feedback!"),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(15)
        ),
        child: const Center(child: Text("Tap for Material Ripple", style: TextStyle(fontWeight: FontWeight.w500))),
      ),
    );
  }

  Widget _buildGestureDemo(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _showMsg(context, customMsg: "Double Tap Detected!"),
      onLongPress: () => _showMsg(context, customMsg: "Long Press Detected!"),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15)
        ),
        child: const Center(child: Text("Double Tap or Long Press Me", style: TextStyle(fontWeight: FontWeight.w500))),
      ),
    );
  }

  Widget _buildDismissibleDemo(BuildContext context) {
    return Dismissible(
      key: const ValueKey("swipe_item"),
      background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.delete, color: Colors.white)
      ),
      onDismissed: (direction) => _showMsg(context, customMsg: "Item successfully dismissed!"),
      child: Card(
          elevation: 2,
          child: const ListTile(
            leading: Icon(Icons.swipe, color: Colors.redAccent),
            title: Text("Swipe this card to the right"),
            subtitle: Text("Simulates a delete action"),
          )
      ),
    );
  }
}

// --- DYNAMIC DETAIL PAGE ---
class ConceptDetailPage extends StatelessWidget {
  final String title;
  const ConceptDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("Technical Logic for $title", Colors.teal),
            const SizedBox(height: 12),
            Text(_getMeticulousDesc(title), style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
            const SizedBox(height: 32),
            _sectionHeader("Live Visual Output", Colors.orange),
            const SizedBox(height: 16),
            _getLiveOutput(title),
            const SizedBox(height: 32),
            _sectionHeader("Code Blueprint", Colors.blueGrey),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
              child: Text(_getCodeExample(title), style: const TextStyle(color: Colors.lightGreenAccent, fontFamily: 'monospace', fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String text, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 24, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _getLiveOutput(String type) {
    if (type == "GridView") {
      return GridView.count(
        shrinkWrap: true, crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
        children: List.generate(3, (int i) => Card(color: Colors.teal.withValues(alpha: 0.1), child: const Icon(Icons.grid_view))),
      );
    }
    if (type == "Card") {
      return const Card(elevation: 4, child: Padding(padding: EdgeInsets.all(20), child: Text("I am a Material Design Card")));
    }
    if (type == "ListTile") {
      return const Card(child: ListTile(leading: Icon(Icons.info), title: Text("Sample Title"), subtitle: Text("Sample Subtitle")));
    }
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: const Center(child: Text("Live Demo Component")),
    );
  }

  String _getMeticulousDesc(String type) {
    if (type == "GridView") {
      return "GridView Meticulous Details:\n1. GridDelegate: Controls the layout algorithm.\n2. Lazy Loading: GridView.builder renders only visible cells to optimize RAM.\n3. CrossAxisCount: Defines column frequency.\n4. MainAxisSpacing: Defines vertical gaps.";
    }
    return "The $type widget provides a structured way to display content following Material Design guidelines, ensuring high responsiveness and clear visual hierarchy.";
  }

  String _getCodeExample(String type) => "void build() {\n  return $type(\n    // Optimized implementation\n  );\n}";
}
