import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB5qHN5cug8b0Qtd4fRqXDfCGfzVjpiwFY",
        authDomain: "fashion-store-web-921c4.firebaseapp.com",
        projectId: "fashion-store-web-921c4",
        storageBucket: "fashion-store-web-921c4.firebasestorage.app",
        messagingSenderId: "370205664872",
        appId: "1:370205664872:web:9abd1c996377fc55f33ddd",
        measurementId: "G-SMCCWVSSS1",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}