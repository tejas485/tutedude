import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/todo_model.dart';
import '../../encryption/crypto_service.dart';

class TaskDbModule {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTodo({
    required String title,
    String? groupId,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    required String priority,
    required String uid,
    required String name,
  }) async {
    await _db.collection('todos').add({
      'title': CryptoService.encrypt(title),
      'location': location != null ? CryptoService.encrypt(location) : null,
      'isCompleted': false,
      'createdBy': uid,
      'createdByName': CryptoService.encrypt(name),
      'groupId': groupId,
      // FIXED: Removed the unnecessary '!' assertions since variables are handled natively
      'startTime': startTime != null ? Timestamp.fromDate(startTime) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime) : null,
      'timestamp': FieldValue.serverTimestamp(),
      'comments': [],
      'priority': priority,
      'triggeredMilestones': <String>[],
    });
  }

  Future<void> addTaskComment(String todoId, String commentText, String name) async {
    if (commentText.trim().isEmpty) return;
    final commentMap = {
      'author': name,
      'text': CryptoService.encrypt(commentText.trim()),
      'time': DateTime.now().toString().substring(11, 16),
    };
    await _db.collection('todos').doc(todoId).update({
      'comments': FieldValue.arrayUnion([commentMap]),
    });
  }

  Future<void> editTaskDetails({
    required String todoId,
    required String newTitle,
    String? newLocation,
    DateTime? newStart,
    DateTime? newEnd,
    required String newPriority,
  }) async {
    await _db.collection('todos').doc(todoId).update({
      'title': CryptoService.encrypt(newTitle),
      'location': newLocation != null ? CryptoService.encrypt(newLocation) : null,
      'startTime': newStart != null ? Timestamp.fromDate(newStart) : null,
      'endTime': newEnd != null ? Timestamp.fromDate(newEnd) : null,
      'priority': newPriority,
      'triggeredMilestones': <String>[],
    });
  }

  Future<void> evaluateMilestoneTriggers(TodoModel todo, String currentUid) async {
    if (todo.startTime == null) return;
    final now = DateTime.now();
    final timeDifference = todo.startTime!.difference(now);
    List<String> newMilestones = List.from(todo.triggeredMilestones);
    String? alertText;

    if (timeDifference.inHours <= 24 && timeDifference.inHours > 12 && !newMilestones.contains('24h')) {
      alertText = "A task starts in 24 hours!";
      newMilestones.add('24h');
    } else if (timeDifference.inHours <= 12 && timeDifference.inHours > 3 && !newMilestones.contains('12h')) {
      alertText = "Task countdown notice: 12 hours remaining until start.";
      newMilestones.add('12h');
    } else if (timeDifference.inHours <= 3 && timeDifference.inMinutes > 30 && !newMilestones.contains('3h')) {
      alertText = "Urgent: Only 3 hours left until task window initialization.";
      newMilestones.add('3h');
    } else if (timeDifference.inMinutes <= 30 && timeDifference.inMinutes > 5 && !newMilestones.contains('30m')) {
      alertText = "Critical: 30 minutes to go before task start.";
      newMilestones.add('30m');
    } else if (timeDifference.inMinutes <= 5 && timeDifference.inSeconds > 0 && !newMilestones.contains('5m')) {
      alertText = "Standby: 5 minutes left to go!";
      newMilestones.add('5m');
    } else if (now.isAfter(todo.startTime!) && !newMilestones.contains('started')) {
      alertText = "Task has officially started right now!";
      newMilestones.add('started');
    }

    if (alertText != null) {
      await _db.collection('todos').doc(todo.id).update({'triggeredMilestones': newMilestones});
      await _db.collection('users').doc(currentUid).collection('notifications').add({
        'message': CryptoService.encrypt('[$alertText] Target: ${CryptoService.decrypt(todo.title)}'),
        'type': 'timeline_alert',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'isStale': false,
      });
    }
  }

  Stream<List<TodoModel>> searchTasksLocally(String? groupId, String keyword, String uid) {
    Query query = _db.collection('todos');
    if (groupId != null) {
      query = query.where('groupId', isEqualTo: groupId);
    } else {
      query = query.where('createdBy', isEqualTo: uid).where('groupId', isNull: true);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TodoModel.fromDocument(doc)).where((todo) {
        final clearTitle = CryptoService.decrypt(todo.title).toLowerCase();
        final clearLocation = CryptoService.decrypt(todo.location ?? '').toLowerCase();
        final matchTerm = keyword.trim().toLowerCase();
        return clearTitle.contains(matchTerm) || clearLocation.contains(matchTerm);
      }).toList();
    });
  }
}
