import 'package:conversio/views/screens/auth/authenticate.dart';
import 'package:conversio/views/screens/auth/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    if (user != null) {
      return const UserProfile();
    } else {
      return const Authenticate();
    }
  }
}
