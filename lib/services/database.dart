import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';

import '../models/message.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final usersCollection = "users";
  final messagesCollection = "messages";

  Future<void> createUser(ConversioUser? userProfile) async {
    await AuthService.user!.updateDisplayName(userProfile!.name);
    ConversioUser user = ConversioUser(
      id: userProfile.id,
      name: userProfile.name,
      email: userProfile.email,
      bio: userProfile.bio,
    );
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
    final senderMessageDoc = firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection(messagesCollection)
        .doc('messagesWith${message.receiverId}');

    final receiverMessageDoc = firestore
        .collection(usersCollection)
        .doc(message.receiverId)
        .collection(messagesCollection)
        .doc('messagesWith${message.senderId}');

    final docSnap1 = await senderMessageDoc.get();
    docSnap1.exists
        ? senderMessageDoc.update({
            'messages': FieldValue.arrayUnion([message.toJson()])
          })
        : senderMessageDoc.set({
            'messages': [message.toJson()]
          });

    final docSnap2 = await receiverMessageDoc.get();
    docSnap2.exists
        ? receiverMessageDoc.update({
            'messages': FieldValue.arrayUnion([message.toJson()])
          })
        : receiverMessageDoc.set({
            'messages': [message.toJson()]
          });
  }

  Stream<List<Message>> getMessages(String? receiverId) {
    return firestore
        .collection(usersCollection)
        .doc(AuthService.userid)
        .collection(messagesCollection)
        .doc('messagesWith$receiverId')
        .snapshots()
        .map((snap) => Message.fromJson(snap.data()!))
        .toList()
        .asStream();
  }
}
