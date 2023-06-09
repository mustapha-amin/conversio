import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final usersCollection = "users";

  Future<void> createUser(User? userProfile) async {
    await AuthService.user!.updateDisplayName(userProfile!.name);
    User user = User(
      id: userProfile.id,
      name: userProfile.name,
      email: userProfile.email,
      bio: userProfile.bio,
    );
    firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection("information")
        .doc()
        .set(user.toJson());
  }
}