import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String message;
  final String type; // 'application', 'approval', 'comment', or 'direct_chat'
  final DateTime timestamp;
  final bool isRead;
  final bool isStale; // Core lifecycle tracking flag mapping for archive filters

  NotificationModel({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.isStale,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': isRead,
      'isStale': isStale,
    };
  }

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return NotificationModel(
      id: doc.id,
      message: data['message'] ?? '',
      type: data['type'] ?? 'info',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      isStale: data['isStale'] ?? false, // Defaults seamlessly to active/unarchived
    );
  }
}
