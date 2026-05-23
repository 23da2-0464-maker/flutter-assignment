import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  // These "getters" allow other screens to see the data but not change it directly
  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // This "listener" constantly watches if the user logs in or out
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // This tells all screens to rebuild if the user changes
    });
  }

  // Real Firebase Registration
  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow; // Sends the error to the UI so you can show an alert
    } finally {
      _setLoading(false);
    }
  }

  // Real Firebase Login
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}