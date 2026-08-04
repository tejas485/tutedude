import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String createdBy;
  final String createdByName;
  final String? groupId;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime timestamp;
  final List<Map<String, dynamic>> comments;
  final String priority;

  // Track reminder triggers to prevent double notification bursts
  final List<String> triggeredMilestones;

  TodoModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdBy,
    required this.createdByName,
    this.groupId,
    this.location,
    this.startTime,
    this.endTime,
    required this.timestamp,
    required this.comments,
    required this.priority,
    required this.triggeredMilestones,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'groupId': groupId,
      'location': location,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'timestamp': FieldValue.serverTimestamp(),
      'comments': comments,
      'priority': priority,
      'triggeredMilestones': triggeredMilestones,
    };
  }

  factory TodoModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawComments = data['comments'] as List<dynamic>? ?? [];
    final List<Map<String, dynamic>> parsedComments = rawComments
        .map((c) => Map<String, dynamic>.from(c as Map))
        .toList();

    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdBy: data['createdBy'] ?? '',
      createdByName: data['createdByName'] ?? 'Anonymous Member',
      groupId: data['groupId'],
      location: data['location'],
      startTime: (data['startTime'] as Timestamp?)?.toDate(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comments: parsedComments,
      priority: data['priority'] ?? 'Medium',
      triggeredMilestones: List<String>.from(data['triggeredMilestones'] ?? []),
    );
  }
}
