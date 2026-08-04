class CommentModel {
  final String id;
  final String username;
  final String text;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      username: map['username'] ?? 'Anonymous',
      text: map['text'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
