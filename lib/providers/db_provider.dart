import 'dart:developer';

import 'package:conversio/models/user.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/views/screens/home.dart';
import 'package:flutter/material.dart';

class DbProvider extends ChangeNotifier {
  bool _loadingStatus = false;
  bool get loadingStatus => _loadingStatus;

  void setLoadingStatus(bool status) {
    _loadingStatus = status;
    log('Loading status updated to: $status');
    notifyListeners();
  }

  Future<void> createUser(
    BuildContext context,
    ConversioUser userProfile,
  ) async {
    try {
      setLoadingStatus(true);
      await DatabaseService().createUser(userProfile);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      setLoadingStatus(false);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to create user: $e")));
      }
    }
  }
}
