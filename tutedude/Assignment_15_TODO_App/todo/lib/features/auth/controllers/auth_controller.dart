import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  String _currentUsername = '';
  bool _isPurging = false;

  User? get currentUser => _currentUser;
  String get currentUsername => _currentUsername;
  bool get isPurging => _isPurging;

  AuthController() {
    _auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      if (user != null) {
        await checkCurrentUser();
      } else {
        _currentUsername = '';
        notifyListeners();
      }
    });
  }

  Future<void> checkCurrentUser() async {
    if (_isPurging) return;
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final doc = await _firestore.collection('usernames_registry').doc(user.uid).get();
      if (doc.exists) {
        _currentUsername = doc.data()?['username'] ?? '';
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> registerWithEmail(String email, String password, String username) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      await _firestore.collection('usernames_registry').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username.trim().toLowerCase(),
        'email': email.trim().toLowerCase(),
      });
      await checkCurrentUser();
    }
  }

  Future<void> signInWithEmailOrUsername(String lookupValue, String password) async {
    String finalEmail = lookupValue.trim();
    if (!lookupValue.contains('@')) {
      final query = await _firestore
          .collection('usernames_registry')
          .where('username', isEqualTo: lookupValue.trim().toLowerCase())
          .limit(1)
          .get();
      if (query.docs.isEmpty) throw FirebaseAuthException(code: 'user-not-found', message: 'Username handle not found.');
      finalEmail = query.docs.first.data()['email'] ?? '';
    }

    // FIXED: Ensured network pipelines are explicitly restored before executing a fresh login handshake
    try {
      await _firestore.enableNetwork();
    } catch (_) {}

    await _auth.signInWithEmailAndPassword(email: finalEmail, password: password);
    await checkCurrentUser();
  }

  dynamic _createInstance(dynamic targetClass, Map<Symbol, dynamic> namedArgs) {
    try {
      return Function.apply(targetClass, [], namedArgs);
    } catch (_) {
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      dynamic googleSignInInstance = _createInstance(GoogleSignIn, {#scopes: ['email']});
      if (googleSignInInstance == null) {
        try {
          final dynamic dynamicClassRef = GoogleSignIn;
          googleSignInInstance = Function.apply(dynamicClassRef.standard, []);
        } catch (_) {
          googleSignInInstance = GoogleSignIn;
        }
      }

      final dynamic googleUser = await Function.apply(googleSignInInstance.signIn, []);
      if (googleUser == null) return;

      final dynamic googleAuth = await googleUser.authentication;
      if (googleAuth == null) return;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        await _firestore.enableNetwork();
      } catch (_) {}

      await _auth.signInWithCredential(credential);
    } catch (_) {}
  }

  /// FIXED LOGOUT PROTOCOL: Destroys internal local variables cleanly and purges persistence cache
  /// without locking down the global Firebase network streaming pipeline.
  Future<void> completeHardPurgeLogout() async {
    if (_isPurging) return;

    _isPurging = true;
    notifyListeners();

    try {
      // 1. Terminate authentication states natively
      await _auth.signOut();

      dynamic logoutInstance = _createInstance(GoogleSignIn, {#scopes: ['email']});
      if (logoutInstance != null) {
        await Function.apply(logoutInstance.signOut, []);
      }

      // 2. Clear out local disk database cache files smoothly
      try {
        await _firestore.clearPersistence();
      } catch (_) {}
    } catch (_) {
    } finally {
      // 3. Purge variables from local runtime memory
      _currentUser = null;
      _currentUsername = '';

      // 4. Force global background components to reset
      try {
        await _firestore.enableNetwork();
      } catch (_) {}

      _isPurging = false;
      notifyListeners();
    }
  }
}
