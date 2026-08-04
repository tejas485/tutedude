import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/group_model.dart';
import '../../encryption/crypto_service.dart';

class GroupDbModule {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createGroup(String name, String uid) async {
    if (name.trim().isEmpty) return;
    await _db.collection('groups').add({
      'name': CryptoService.encrypt(name.trim()),
      'founder': uid,
      'createdBy': uid,
      'admins': [uid],
      'coordinators': <String>[],
      'members': [uid],
      'pendingApplications': <String, dynamic>{},
      'customWelcomeNote': CryptoService.encrypt('Our team will review your credentials shortly.'),
    });
  }

  Future<void> updateCustomWelcomeNote(String groupId, String note) async {
    await _db.collection('groups').doc(groupId).update({
      'customWelcomeNote': CryptoService.encrypt(note.trim()),
    });
  }

  Stream<List<GroupModel>> searchGroups(String query) {
    return _db.collection('groups').snapshots().map((s) => s.docs.map((d) {
      final data = d.data();
      return GroupModel(
        id: d.id,
        name: CryptoService.decrypt(data['name'] ?? ''),
        founder: data['founder'] ?? '',
        admins: List<String>.from(data['admins'] ?? []),
        coordinators: List<String>.from(data['coordinators'] ?? []),
        members: List<String>.from(data['members'] ?? []),
        pendingApplications: Map<String, dynamic>.from(data['pendingApplications'] ?? {}),
      );
    }).where((g) => g.name.toLowerCase() == query.trim().toLowerCase()).toList());
  }
}
