import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String founder; // Creator Designation
  final List<String> admins;
  final List<String> coordinators;
  final List<String> members;
  final Map<String, dynamic> pendingApplications;

  GroupModel({
    required this.id,
    required this.name,
    required this.founder,
    required this.admins,
    required this.coordinators,
    required this.members,
    required this.pendingApplications,
  });

  factory GroupModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      founder: data['founder'] ?? '',
      admins: List<String>.from(data['admins'] ?? []),
      coordinators: List<String>.from(data['coordinators'] ?? []),
      members: List<String>.from(data['members'] ?? []),
      pendingApplications: Map<String, dynamic>.from(data['pendingApplications'] ?? {}),
    );
  }
}
