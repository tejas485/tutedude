import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../models/todo_model.dart';

class TodoController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;
  String get _userCollection => 'users/${_auth.currentUser?.uid}/todos';

  Stream<List<TodoModel>> streamTodos() {
    if (_auth.currentUser == null) return Stream.value([]);
    return _firestore.collection(_userCollection).snapshots().map((snapshot) {
      _todos = snapshot.docs.map((doc) => TodoModel.fromMap(doc.id, doc.data())).toList();
      return _todos;
    });
  }

  double getCompletionPercentage() {
    if (_todos.isEmpty) return 0.0;
    int totalProgress = 0;
    for (var task in _todos) {
      totalProgress += task.progressPercent;
    }
    return (totalProgress / (_todos.length * 100));
  }

  Future<void> saveTodo(TodoModel todo) async {
    if (todo.id.isEmpty) {
      DocumentReference document = await _firestore.collection(_userCollection).add(todo.toMap());
      todo.id = document.id;
    } else {
      await _firestore.collection(_userCollection).doc(todo.id).update(todo.toMap());
    }

    // Pass the calculated base id hash directly into the local notification engine wrapper
    final baseId = todo.id.hashCode;
    if (todo.isCompleted) {
      await SimplifiedNotificationEngine.cancelNotificationsForTask(baseId);
    } else {
      await SimplifiedNotificationEngine.planMultiTierAlerts(
        baseId: baseId,
        taskTitle: todo.title,
        startTime: todo.startTime,
        deadline: todo.deadline,
      );
    }
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection(_userCollection).doc(id).delete();
    await SimplifiedNotificationEngine.cancelNotificationsForTask(id.hashCode);
  }
}
