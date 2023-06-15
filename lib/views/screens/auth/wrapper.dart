import 'package:conversio/services/auth_service.dart';
import 'package:conversio/views/screens/auth/authenticate.dart';
import 'package:conversio/views/screens/auth/user_profile.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }
        if (snapshot.hasData) {
          return const UserProfile();
        } else {
          return const Authenticate();
        }
      },
    );
  }
}
