import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/message.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final usersCollection = "users";
  final messagesCollection = "messagesCollection";

  Future<void> createUser(ConversioUser? userProfile) async {
    try {
      final metadata = SettableMetadata();
      final path = 'usersProfilePicture/${userProfile!.id}/profile.jpg';
      final ref = firebaseStorage.ref().child(path);
      await ref.putFile(File(userProfile.profileImgUrl!), metadata);
      final imgUrl = await ref.getDownloadURL();
      ConversioUser user = userProfile.copyWith(profileImgUrl: imgUrl);
      await firestore
          .collection(usersCollection)
          .doc(AuthService.userid)
          .set(user.toJson());
    } catch (e, stk) {
      log(e.toString());
      log(stk.toString());
      throw Exception(e.toString());
    }
  }

  void updateUserName(String? name) async {
    await firestore.collection(usersCollection).doc(AuthService.userid).update({
      'name': name,
    });
    await AuthService.user!.updateDisplayName(name);
  }

  void updateEmail(String? email) async {
    await firestore.collection(usersCollection).doc(AuthService.userid).update({
      'email': email,
    });
    await AuthService.user!.updateEmail(email!);
  }

  void updateBio(String? bio) async {
    await firestore.collection(usersCollection).doc(AuthService.userid).update({
      'bio': bio,
    });
  }

  void updateProfilePic(String imgPath) async {
    final path =
        'usersProfilePicture/${AuthService.user!.displayName}/$imgPath';
    final file = File(imgPath);
    final ref = firebaseStorage.ref().child(path);
    await ref.putFile(file);
    final imgUrl = await ref.getDownloadURL();
    await AuthService.user!.updatePhotoURL(imgUrl);
    await firestore.collection(usersCollection).doc(AuthService.userid).update({
      'profileImgUrl': imgUrl,
    });
  }

  Stream<ConversioUser> getUserInfo({String? uid}) {
    return firestore
        .collection(usersCollection)
        .doc(uid ?? AuthService.userid)
        .snapshots()
        .map((e) => ConversioUser.fromJson(e.data()!));
  }

  Stream<List<ConversioUser>> getUsers() {
    return firestore
        .collection(usersCollection)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((e) => ConversioUser.fromJson(e.data()))
                  .where((user) => user.id != AuthService.userid)
                  .toList(),
        );
  }

  
}
