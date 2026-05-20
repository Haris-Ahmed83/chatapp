import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppConfig {
  AppConfig._();

  static late final FirebaseAuth auth;
  static late final FirebaseFirestore firestore;
  static late final FirebaseStorage storage;

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB4HeD05C8qE5EJRqWmtGcBD46iAHQr8ZU",
        authDomain: "chatapp-8a2d9.firebaseapp.com",
        projectId: "chatapp-8a2d9",
        storageBucket: "chatapp-8a2d9.firebasestorage.app",
        messagingSenderId: "594203207025",
        appId: "1:594203207025:web:498329a15816fe98bdc2d0",
        measurementId: "G-5XBZE8Z4X6",
      ),
    );
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
  }
}
