import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../encryption/crypto_service.dart';

class AuthService { // Fixed: Unified class declaration name to resolve all screen compile errors
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _generateUniqueHandle(String name) {
    final cleanName = name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
    final randomSuffix = Random().nextInt(900) + 100;
    return '@${cleanName}_$randomSuffix';
  }

  Future<UserCredential?> signUp(String email, String password, String name) async {
    UserCredential creds = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (creds.user != null) {
      final String uniqueId = _generateUniqueHandle(name);
      await creds.user!.updateDisplayName(name);

      await _db.collection('users').doc(creds.user!.uid).set({
        'uniqueId': uniqueId,
        'uniqueIdHash': CryptoService.secureHash(uniqueId),
        'displayNameHash': CryptoService.secureHash(name),
        'emailHash': CryptoService.secureHash(email),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return creds;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    UserCredential creds = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (creds.user != null) {
      final userDoc = await _db.collection('users').doc(creds.user!.uid).get();
      if (!userDoc.exists || userDoc.data()?.containsKey('uniqueId') == false) {
        final String fallbackName = creds.user!.displayName ?? 'user';
        final String missingId = _generateUniqueHandle(fallbackName);

        await _db.collection('users').doc(creds.user!.uid).set({
          'uniqueId': missingId,
          'uniqueIdHash': CryptoService.secureHash(missingId),
          'displayNameHash': CryptoService.secureHash(fallbackName),
          'emailHash': CryptoService.secureHash(email),
        }, SetOptions(merge: true));
      }
    }
    return creds;
  }

  Future<void> signOut() async => await _auth.signOut();
  Future<void> sendPasswordReset(String email) async => await _auth.sendPasswordResetEmail(email: email);

  Future<void> updateAccountEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(newEmail);
      await _db.collection('users').doc(user.uid).update({'emailHash': CryptoService.secureHash(newEmail)});
    }
  }

  Future<void> updateAccountPassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }
}
