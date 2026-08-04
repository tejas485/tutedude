// lib/components/favorites_drawer.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ui_dialogs.dart';
import '../config/theme_config.dart'; // ◄── STATIC CONFIG DEPTH RELOCATION FIXED

class FavoritesDrawerOverlay extends StatelessWidget {
  final List<Map<String, dynamic>> favoritesData;
  final Color accentColor;
  final String userUid;

  const FavoritesDrawerOverlay({
    super.key,
    required this.favoritesData,
    required this.accentColor,
    required this.userUid,
  });

  void _wipeAllCloudFavorites(BuildContext context) {
    CinemaUiDialogs.showActionConfirmation(
      context: context,
      title: "Wipe Favorites",
      message: "Are you sure you want to permanently clear all bookmarked movies from the database?",
      confirmLabel: "Clear All",
      onConfirm: () async {
        Navigator.pop(context);
        await FirebaseFirestore.instance.collection('cinema_users').doc(userUid).update({
          'bookmarks': FieldValue.delete()
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Saved Favorites Bookmarks", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accentColor)),
              Row(
                children: [
                  if (favoritesData.isNotEmpty)
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: CinemaMeshTheme.errorCrimson),
                      icon: const Icon(Icons.playlist_remove, size: 16),
                      label: const Text("Wipe Favorites", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: () => _wipeAllCloudFavorites(context),
                    ),
                  IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: favoritesData.isEmpty
                ? Center(child: Text("Your bookmark collection is empty.", style: TextStyle(color: CinemaMeshTheme.mutedSubtleGrey, fontSize: 13)))
                : ListView.builder(
              itemCount: favoritesData.length,
              itemBuilder: (context, i) {
                final item = favoritesData[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: isDark ? Colors.black26 : Colors.grey.shade100,
                  child: ListTile(
                    title: Text(item["title"] ?? "Unknown Title", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("Director: ${item["director"] ?? "N/A"}", style: const TextStyle(fontSize: 11)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: CinemaMeshTheme.errorCrimson, size: 18),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('cinema_users').doc(userUid).update({
                          'bookmarks': FieldValue.arrayRemove([item])
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
