import 'dart:convert';

class JournalEntry {
  final String id;
  final String title;
  final String author;
  final String description;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.date,
  });

  // Convert a JournalEntry into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  // Create a JournalEntry from a Map object
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }

  // Convert a list of entries to a JSON string
  static String encode(List<JournalEntry> entries) => json.encode(
    entries.map<Map<String, dynamic>>((e) => e.toMap()).toList(),
  );

  // Decode a JSON string back into a list of entries
  static List<JournalEntry> decode(String jsonStr) =>
      (json.decode(jsonStr) as List<dynamic>)
          .map<JournalEntry>((item) => JournalEntry.fromMap(item))
          .toList();
}
