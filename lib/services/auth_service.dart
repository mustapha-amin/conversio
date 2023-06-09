import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final firebaseAuth = FirebaseAuth.instance;
  static String? get userid => firebaseAuth.currentUser!.uid;
  static User? get user => firebaseAuth.currentUser;
  static Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
}
