import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/message.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final usersCollection = "users";
  final messagesCollection = "messagesCollection";

  Future<void> createUser(ConversioUser? userProfile) async {
    final path = 'usersProfilePicture/${userProfile!.name}/';
    final file = File(userProfile.profileImgUrl!);
    final ref = firebaseStorage.ref().child(path);
    await ref.putFile(file);
    final imgUrl = await ref.getDownloadURL();
    await AuthService.user!.updateDisplayName(userProfile.name);
    await AuthService.user!.updatePhotoURL(imgUrl);

    ConversioUser user = userProfile.copyWith(profileImgUrl: imgUrl);
    firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .set(user.toJson());
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

  Stream<ConversioUser> getUserInfo() {
    return firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .snapshots()
        .map((e) => ConversioUser.fromJson(e.data()!));
  }

  Stream<List<ConversioUser>> getUsers() {
    return firestore.collection(usersCollection).snapshots().map((snap) => snap
        .docs
        .map((e) => ConversioUser.fromJson(e.data()))
        .where((user) => user.id != AuthService.userid)
        .toList());
  }

  Future<void> sendMessage(Message message) async {
    message.id = DateTime.now().microsecondsSinceEpoch.toString();
    // sender
    await firestore
        .collection(usersCollection)
        .doc(message.senderId)
        .collection('allMessages')
        .doc('messagesWith${message.receiverId}')
        .collection('messages')
        .doc(message.id)
        .set(message.toJson());

    // receiver
    await firestore
        .collection(usersCollection)
        .doc(message.receiverId)
        .collection('allMessages')
        .doc('messagesWith${message.senderId}')
        .collection('messages')
        .doc(message.id)
        .set(message.toJson());
  }

  Stream<List<Message>> getMessages(String? receiverId) {
    return firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection('allMessages')
        .doc('messagesWith$receiverId')
        .collection('messages')
        .snapshots()
        .map((snap) =>
            snap.docs.map((e) => Message.fromJson(e.data())).toList());
  }

  Future<void> deleteMessage(Message message) async {
    final doc = firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection('allMessages')
        .doc('messagesWith${message.receiverId}')
        .collection('messages')
        .doc(message.id);
    await doc.delete();
  }

  Future<void> clearChat(String? receiverId) async {
    final collection = await firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection('allMessages')
        .doc('messagesWith$receiverId')
        .collection('messages')
        .get();

    await Future.wait(collection.docs.map((doc) => doc.reference.delete()));
  }

  Stream<Message> getRecentMessage(String? id) {
    return firestore
        .collection('users')
        .doc(AuthService.userid)
        .collection('allMessages')
        .doc('messagesWith$id')
        .collection('messages')
        .snapshots()
        .map((snap) => Message.fromJson(snap.docs.last.data()));
  }
}
