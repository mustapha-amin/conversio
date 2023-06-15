import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/models/story.dart';
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
    final path =
        'usersProfilePicture/${userProfile!.name}/${userProfile.name!.split('.').last}';
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
        .doc(message.senderId)
        .collection('allMessages')
        .doc('messagesWith${message.receiverId}')
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
    await firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection('allMessages')
        .doc('messagesWith${message.receiverId}')
        .collection('messages')
        .doc(message.id)
        .delete();
  }

  void clearChat(String? receiverId) async {
    final data = await firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection('allMessages')
        .doc('messagesWith$receiverId')
        .collection('messages')
        .get();
    data.docs.clear();
  }

  void uploadStory(Story? story) async {
    final path =
        'usersStories/${AuthService.user!.displayName}/${story!.imgUrl}';
    final file = File(story.imgUrl!);
    final ref = firebaseStorage.ref().child(path);
    await ref.putFile(file);
    final imgUrl = await ref.getDownloadURL();
    Story storyUpload = story.copyWith(imgUrl: imgUrl);
    firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection('stories')
        .doc(storyUpload.id)
        .set(storyUpload.toJson());
  }
}
