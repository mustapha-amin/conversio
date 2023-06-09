import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              AuthService.firebaseAuth.signOut();
            },
            child: Text("Press")),
      ),
    );
  }
}
