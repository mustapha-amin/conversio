import 'package:flutter/widgets.dart';

class AuthStatus extends ChangeNotifier {
  bool _isSignIn = true;

  void toggle() {
    _isSignIn = !_isSignIn;
    notifyListeners();
  }

  bool get isSignIn => _isSignIn;
}