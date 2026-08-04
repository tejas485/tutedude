import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/encryption_service.dart';
import 'comment_model.dart';

class TodoModel {
  String id;
  String title;
  String description;
  DateTime startTime;
  DateTime deadline;
  String priority;
  int progressPercent;
  List<CommentModel> comments;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.deadline,
    required this.priority,
    this.progressPercent = 0,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  bool get isCompleted => progressPercent == 100;

  Map<String, dynamic> toMap() {
    return {
      'title': EncryptionService.encrypt(title),
      'description': EncryptionService.encrypt(description),
      'startTime': Timestamp.fromDate(startTime),
      'deadline': Timestamp.fromDate(deadline),
      'priority': priority,
      'progressPercent': progressPercent,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  // FIXED: Implemented try-catch format safety filters to avoid Base64 runtime exceptions on loaded tasks
  static String _safeDecrypt(dynamic value) {
    if (value == null || value.toString().isEmpty) return '';
    final rawStr = value.toString();
    // Simple verification check to ensure value is likely encrypted Base64 data
    if (rawStr.contains(' ') || rawStr.length < 4) return rawStr;
    try {
      return EncryptionService.decrypt(rawStr);
    } catch (_) {
      return rawStr; // Gracefully falls back to plain text raw string instead of throwing errors
    }
  }

  factory TodoModel.fromMap(String id, Map<String, dynamic> map) {
    var commentsList = (map['comments'] as List?) ?? [];
    return TodoModel(
      id: id,
      title: _safeDecrypt(map['title']),
      description: _safeDecrypt(map['description']),
      startTime: map['startTime'] != null ? (map['startTime'] as Timestamp).toDate() : DateTime.now(),
      deadline: map['deadline'] != null ? (map['deadline'] as Timestamp).toDate() : DateTime.now().add(const Duration(days: 1)),
      priority: map['priority'] ?? 'Low',
      progressPercent: map['progressPercent'] ?? 0,
      comments: commentsList.map((c) => CommentModel.fromMap(Map<String, dynamic>.from(c))).toList(),
    );
  }
}