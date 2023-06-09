import 'package:conversio/views/screens/auth/authenticate.dart';
import 'package:conversio/views/screens/auth/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import 'login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    if (user != null) {
      return UserProfile();
    } else {
      return const Authenticate();
    }
  }
}
