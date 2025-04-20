import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/providers/auth_status.dart';
import 'package:conversio/views/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    bool isSignIn = Provider.of<AuthStatus>(context).isSignIn;
    if (isSignIn) {
      return const LoginScreen();
    } else {
      return const SignUpScreen();
    }
  }
}
