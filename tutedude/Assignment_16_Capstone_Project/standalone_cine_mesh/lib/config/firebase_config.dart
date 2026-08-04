// D:\standalone_cine_mesh\lib\config\firebase_config.dart
import 'package:firebase_core/firebase_core.dart';

class CinemaFirebaseConfig {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: "AIzaSyBrQix5g3wohagp6J5ZxJsjBx6alo5CnUI",
    authDomain: "cinema-mesh-auth.firebaseapp.com", // ◄── CRITICAL CORRECTION
    projectId: "cinema-mesh-auth",
    storageBucket: "cinema-mesh-auth.firebasestorage.app",
    messagingSenderId: "495560371302",
    appId: "1:495560371302:web:d37d1fe87e942e95a791a7",
    measurementId: "G-S4EBL0J6B4",
  );
}
