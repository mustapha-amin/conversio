import 'package:conversio/services/auth_service.dart';
import 'package:conversio/views/shared/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _loadingStatus = false;

  bool get loadingStatus => _loadingStatus;

  Future<void> createAccount(
    BuildContext context,
    String email,
    String password,
  ) async {
    _loadingStatus = true;
    notifyListeners();
    try {
      await AuthService.firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _loadingStatus = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String error = '';
      _loadingStatus = false;
      notifyListeners();
      if (e.code == 'email-already-in-use') {
        error = "email already in use";
      } else if (e.code == "network-request-failed") {
        error = "A network occured, check your internet settings";
      } else {
        error = e.message.toString();
      }
      showErrorDialog(context, error);
    }
  }

  Future<void> logIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    _loadingStatus = true;
    notifyListeners();
    try {
      await AuthService.firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _loadingStatus = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String error = '';
      _loadingStatus = false;
      notifyListeners();
      if (e.code == 'user-not-found') {
        error = "User not found";
      } else if (e.code == "wrong-password") {
        error = "Incorrect password";
      } else if (e.code == "network-request-failed") {
        error = "A network occured, check your internet settings";
      } else {
        error = e.message.toString();
      }
      showErrorDialog(context, error);
    }
  }
}
