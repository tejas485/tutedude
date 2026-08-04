import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

class UserSearchDelegate extends StatefulWidget {
  const UserSearchDelegate({super.key});

  @override
  State<UserSearchDelegate> createState() => _UserSearchDelegateState();
}

class _UserSearchDelegateState extends State<UserSearchDelegate> {
  final DatabaseService _dbService = DatabaseService();
  final _searchController = TextEditingController();
  Map<String, dynamic>? _foundUserData;
  bool _isSearching = false;
  String? _targetUid;

  void _executeUserLookup() async {
    final inputId = _searchController.text.trim();
    if (inputId.isEmpty) return;

    setState(() {
      _isSearching = true;
      _foundUserData = null;
      _targetUid = null;
    });

    try {
      // Direct Cloud lookup check matching the user's specific unique hardware ID entry path
      final doc = await FirebaseFirestore.instance.collection('users').doc(inputId).get();
      if (doc.exists && mounted) {
        setState(() {
          _foundUserData = doc.data();
          _targetUid = doc.id;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No teammate located matching that Unique User ID.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Teammate Directory Search (Instagram Model)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter exact Unique User ID (UID)...',
                    prefixIcon: Icon(Icons.badge),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _executeUserLookup(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: _isSearching
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.search),
                onPressed: _executeUserLookup,
              ),
            ],
          ),
          if (_foundUserData != null && _targetUid != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.blue.withValues(alpha: 0.05),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.verified_user, color: Colors.blue)),
                title: const Text('Teammate Identity Matched', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('ID footprint footprint: ${_targetUid!.substring(0, 12)}...', style: const TextStyle(fontSize: 11)),
                trailing: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
                  tooltip: 'Initialize Secure P2P Direct Chat Thread',
                  onPressed: () {
                    // Triggers the direct conversation broker
                    _dbService.sendDirectChatMessage(_targetUid!, 'Hello! I located your profile string via the unique ID locator directory.', 'Teammate');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Direct chat thread created! Check your Messages tab.')),
                    );
                  },
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

