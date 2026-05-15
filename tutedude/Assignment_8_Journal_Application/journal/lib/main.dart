import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_entry.dart';

void main() => runApp(const JournalApp());

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff121214),
        primaryColor: Colors.cyanAccent,
      ),
      home: const JournalLandingPage(),
    );
  }
}

class JournalLandingPage extends StatelessWidget {
  const JournalLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MY PERSONAL\nJOURNAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.cyanAccent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.cyanAccent, offset: Offset(4, 4), blurRadius: 0),
                  BoxShadow(color: Colors.black, offset: Offset(-2, -2), blurRadius: 4),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const JournalHome()),
                  );
                },
                child: const Text(
                  'VIEW ALL JOURNALS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JournalHome extends StatefulWidget {
  const JournalHome({super.key});

  @override
  State<JournalHome> createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> {
  List<JournalEntry> _entries = [];
  String _searchQuery = "";
  String _sortBy = "date";
  bool _isAscending = false;

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJournalData();
  }

  void _loadJournalData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedEntriesRaw = prefs.getString('user_journals');
    if (savedEntriesRaw != null) {
      setState(() {
        _entries = JournalEntry.decode(savedEntriesRaw);
      });
    }
  }

  void _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = JournalEntry.encode(_entries);
    await prefs.setString('user_journals', encodedData);
  }

  void _addEntry() {
    if (titleController.text.trim().isEmpty ||
        authorController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.purple,
          title: const Text('Warning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text('All input fields must be filled out before saving.', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
      return;
    }

    setState(() {
      _entries.add(JournalEntry(
        id: DateTime.now().toString(),
        title: titleController.text.trim(),
        author: authorController.text.trim(),
        description: descController.text.trim(),
        date: DateTime.now(),
      ));
    });

    _saveToStorage();

    titleController.clear();
    authorController.clear();
    descController.clear();
    Navigator.of(context).pop();
  }

  void _confirmDeletion(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff222225),
        title: const Text('Confirm Delete', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to permanently delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                _entries.removeWhere((entry) => entry.id == id);
              });
              _saveToStorage();
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1a1a1c),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 30, left: 20, right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'NEW JOURNAL ENTRY',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
              const SizedBox(height: 20),
              _buildBoxedTextField(titleController, 'Entry Title', Icons.title),
              const SizedBox(height: 15),
              _buildBoxedTextField(authorController, 'Author Name', Icons.person),
              const SizedBox(height: 15),
              _buildBoxedTextField(descController, 'Write your content here...', Icons.description, maxLines: 4),
              const SizedBox(height: 25),
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.pinkAccent, offset: Offset(3, 3))],
                ),
                child: ElevatedButton(
                  onPressed: _addEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  child: const Text('SAVE TO JOURNAL', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBoxedTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.cyanAccent),
        filled: true,
        fillColor: const Color(0xff2a2a2e),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 2.5),
        ),
      ),
    );
  }

  List<JournalEntry> _getProcessedEntries() {
    List<JournalEntry> filtered = _entries.where((entry) {
      final searchLower = _searchQuery.toLowerCase();
      final titleMatch = entry.title.toLowerCase().contains(searchLower);
      final authorMatch = entry.author.toLowerCase().contains(searchLower);
      final timeStr = DateFormat.yMd().add_jm().format(entry.date).toLowerCase();
      return titleMatch || authorMatch || timeStr.contains(searchLower);
    }).toList();

    filtered.sort((a, b) {
      int compare = 0;
      if (_sortBy == "name") {
        compare = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else if (_sortBy == "author") {
        compare = a.author.toLowerCase().compareTo(b.author.toLowerCase());
      } else {
        compare = a.date.compareTo(b.date);
      }
      return _isAscending ? compare : -compare;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final processedList = _getProcessedEntries();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('JOURNAL DATABASE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search title, author or time...",
                    prefixIcon: const Icon(Icons.search, color: Colors.yellowAccent),
                    fillColor: const Color(0xff1e1e21),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: _sortBy,
                      dropdownColor: const Color(0xff222225),
                      items: const [
                        DropdownMenuItem(value: "date", child: Text("Sort by Date/Time")),
                        DropdownMenuItem(value: "name", child: Text("Sort by Title")),
                        DropdownMenuItem(value: "author", child: Text("Sort by Author")),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _sortBy = val);
                      },
                    ),
                    IconButton(
                      icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.cyanAccent),
                      onPressed: () => setState(() => _isAscending = !_isAscending),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: processedList.isEmpty
                ? const Center(child: Text("No records found.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                : ListView.builder(
              itemCount: processedList.length,
              itemBuilder: (ctx, idx) {
                final entry = processedList[idx];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xff252529),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1.5, color: Colors.black),
                    boxShadow: const [
                      BoxShadow(color: Colors.pinkAccent, offset: Offset(5, 5), blurRadius: 0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  entry.title.toUpperCase(),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.yellowAccent),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Author: ${entry.author}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.cyanAccent, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                DateFormat.yMd().add_jm().format(entry.date),
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 11, color: Colors.white60),
                              ),
                              const Divider(color: Colors.white24, height: 20),
                              Text(
                                entry.description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 28),
                          onPressed: () => _confirmDeletion(entry.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: () => _showAddModal(context),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }
}
