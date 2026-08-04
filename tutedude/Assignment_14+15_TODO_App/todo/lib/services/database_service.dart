import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';
import '../models/group_model.dart';
import '../models/chat_message_model.dart';
import '../encryption/crypto_service.dart';
import 'database_modules/task_db_module.dart';
import 'database_modules/group_db_module.dart';
import 'database_modules/chat_db_module.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize the sub-modules
  final TaskDbModule _taskMod = TaskDbModule();
  final GroupDbModule _groupMod = GroupDbModule();
  final ChatDbModule _chatMod = ChatDbModule();

  String get _uid => _auth.currentUser?.uid ?? '';
  String get _name => _auth.currentUser?.displayName ?? 'Anonymous';

  // Task Module Callers
  Future<void> addTodo({required String title, String? groupId, String? location, DateTime? startTime, DateTime? endTime, required String priority}) async =>
      await _taskMod.addTodo(title: title, groupId: groupId, location: location, startTime: startTime, endTime: endTime, priority: priority, uid: _uid, name: _name);

  Future<void> addTaskComment(String todoId, String commentText) async {
    await _taskMod.addTaskComment(todoId, commentText, _name);
  }
  Stream<List<TodoModel>> searchTasksLocally(String? groupId, String keyword) => _taskMod.searchTasksLocally(groupId, keyword, _uid);

  // Group Module Callers
  Future<void> createGroup(String name) async => await _groupMod.createGroup(name, _uid);
  Future<void> updateCustomWelcomeNote(String gId, String note) async => await _groupMod.updateCustomWelcomeNote(gId, note);
  Stream<List<GroupModel>> searchGroups(String query) => _groupMod.searchGroups(query);

  // Chat Module Callers
  Stream<List<ChatMessageModel>> watchGroupChatFeed(String gId) => _chatMod.watchGroupChatFeed(gId);
  Stream<List<ChatMessageModel>> watchDirectChatFeed(String rId) => _chatMod.watchDirectChatFeed(rId);
  Stream<QuerySnapshot> watchLiveChatFeed(String gId, String cUid) => _chatMod.watchLiveChatFeed(gId, cUid);
  Future<void> sendGroupChatMessage(String gId, String txt, String rle) async => await _chatMod.sendGroupChatMessage(gId, txt, rle, _uid, _name);
  Future<void> sendDirectChatMessage(String pUid, String txt, String rle) async => await _chatMod.sendDirectChatMessage(getPeerRoomId(pUid), txt, rle, _uid, _name);
  Future<void> sendLiveChatMessage({required String groupId, required String candidateUid, required String messageText, required String senderRole}) async =>
      await _chatMod.sendLiveChatMessage(groupId: groupId, candidateUid: candidateUid, messageText: messageText, senderRole: senderRole, uid: _uid, name: _name);

  // Security Alert Notifications Core Operations
  Future<void> _dispatchSystemAlert(String targetUid, String text, String type) async {
    await _db.collection('users').doc(targetUid).collection('notifications').add({
      'message': CryptoService.encrypt(text),
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'isStale': false,
    });
  }

  Future<void> sendBlindAdminMessage(String groupId, String messageText) async {
    final groupDoc = await _db.collection('groups').doc(groupId).get();
    if (!groupDoc.exists) return;
    final founderId = groupDoc.data()?['founder'] ?? '';
    await _db.collection('direct_chats').doc(getPeerRoomId(founderId)).collection('messages').add({
      'senderId': _uid, 'senderName': CryptoService.encrypt(_name), 'senderRole': CryptoService.encrypt('Applicant'),
      'text': CryptoService.encrypt('[BLIND ROUTED ENQUIRY]: $messageText'), 'timestamp': FieldValue.serverTimestamp(),
    });
    await _dispatchSystemAlert(founderId, 'New secure blind encryption enquiry received regarding one of your managed groups.', 'direct_chat');
  }

  // Baseline Fallback Framework Streams
  Stream<List<TodoModel>> get privateTodos => _db.collection('todos').where('createdBy', isEqualTo: _uid).where('groupId', isNull: true).snapshots().map((s) => s.docs.map((d) => TodoModel.fromDocument(d)).toList());
  Stream<List<TodoModel>> groupTodos(String gId) => _db.collection('todos').where('groupId', isEqualTo: gId).snapshots().map((s) => s.docs.map((d) => TodoModel.fromDocument(d)).toList());
  Stream<List<GroupModel>> get myGroups => _db.collection('groups').where('members', arrayContains: _uid).snapshots().map((s) => s.docs.map((d) {
    final data = d.data();
    return GroupModel(id: d.id, name: CryptoService.decrypt(data['name'] ?? ''), founder: data['founder'] ?? '', admins: List<String>.from(data['admins'] ?? []), coordinators: List<String>.from(data['coordinators'] ?? []), members: List<String>.from(data['members'] ?? []), pendingApplications: Map<String, dynamic>.from(data['pendingApplications'] ?? {}));
  }).toList());

  String getPeerRoomId(String pUid) { List<String> ids = [_uid, pUid]; ids.sort(); return ids.join('_'); }
  Future<void> updateProfileDisplayName(String name) async => await _db.collection('users').doc(_uid).set({'displayNameHash': CryptoService.secureHash(name)}, SetOptions(merge: true));
  Future<void> updateTodoStatus(String id, bool val) async => await _db.collection('todos').doc(id).update({'isCompleted': val});
  Future<void> deleteTodo(String id) async => await _db.collection('todos').doc(id).delete();
  Future<void> promoteToAdmin(String gId, String mUid) async => _db.collection('groups').doc(gId).update({'admins': FieldValue.arrayUnion([mUid])});
  Future<void> promoteToCoordinator(String gId, String mUid) async => _db.collection('groups').doc(gId).update({'coordinators': FieldValue.arrayUnion([mUid])});
  Future<void> demoteToMember(String gId, String mUid) async => _db.collection('groups').doc(gId).update({'admins': FieldValue.arrayRemove([mUid]), 'coordinators': FieldValue.arrayRemove([mUid])});
  Stream<DocumentSnapshot> watchApplicationStatus(String gId) => _db.collection('groups').doc(gId).snapshots();
  Future<void> instantApproveUser(String gId, String cUid) async { await _db.collection('groups').doc(gId).update({'members': FieldValue.arrayUnion([cUid]), 'pendingApplications.$cUid': FieldValue.delete()}); await _dispatchSystemAlert(cUid, 'Your access request has been approved!', 'approval'); }
  Future<void> applyToGroup(String gId) async { await _db.collection('groups').doc(gId.trim()).update({'pendingApplications.$_uid': {'email': _auth.currentUser?.email, 'displayName': _name, 'approvals': [], 'oneWayMessage': 'Awaiting verification.'}}); final groupDoc = await _db.collection('groups').doc(gId.trim()).get(); if (groupDoc.exists) await _dispatchSystemAlert(groupDoc.data()?['founder'] ?? '', 'A new applicant requested entry workspace clearance.', 'application'); }
  Future<void> editTaskDetails({required String todoId, required String newTitle, String? newLocation, DateTime? newStart, DateTime? newEnd, required String newPriority}) async =>
      await _taskMod.editTaskDetails(todoId: todoId, newTitle: newTitle, newLocation: newLocation, newStart: newStart, newEnd: newEnd, newPriority: newPriority);

  Future<void> evaluateMilestoneTriggers(TodoModel todo) async => await _taskMod.evaluateMilestoneTriggers(todo, _uid);

}
