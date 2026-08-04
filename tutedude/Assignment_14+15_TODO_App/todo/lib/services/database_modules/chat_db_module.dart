import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_message_model.dart';
import '../../encryption/crypto_service.dart';

class ChatDbModule {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ChatMessageModel>> watchGroupChatFeed(String gId) => _db.collection('groups').doc(gId).collection('general_chats').orderBy('timestamp', descending: true).snapshots().map((s) => s.docs.map((d) => ChatMessageModel.fromDocument(d)).toList());
  Stream<List<ChatMessageModel>> watchDirectChatFeed(String rId) => _db.collection('direct_chats').doc(rId).collection('messages').orderBy('timestamp', descending: true).snapshots().map((s) => s.docs.map((d) => ChatMessageModel.fromDocument(d)).toList());
  Stream<QuerySnapshot> watchLiveChatFeed(String gId, String cUid) => _db.collection('groups').doc(gId).collection('applications').doc(cUid).collection('messages').orderBy('timestamp', descending: true).snapshots();

  Future<void> sendGroupChatMessage(String gId, String txt, String rle, String uid, String name) async => await _db.collection('groups').doc(gId).collection('general_chats').add({'senderId': uid, 'senderName': name, 'senderRole': rle, 'text': CryptoService.encrypt(txt.trim()), 'timestamp': FieldValue.serverTimestamp()});
  Future<void> sendDirectChatMessage(String roomId, String txt, String rle, String uid, String name) async => await _db.collection('direct_chats').doc(roomId).collection('messages').add({'senderId': uid, 'senderName': name, 'senderRole': rle, 'text': CryptoService.encrypt(txt.trim()), 'timestamp': FieldValue.serverTimestamp()});
  Future<void> sendLiveChatMessage({required String groupId, required String candidateUid, required String messageText, required String senderRole, required String uid, required String name}) async => await _db.collection('groups').doc(groupId).collection('applications').doc(candidateUid).collection('messages').add({'senderId': uid, 'senderName': name, 'senderRole': senderRole, 'text': CryptoService.encrypt(messageText.trim()), 'timestamp': FieldValue.serverTimestamp()});
}
