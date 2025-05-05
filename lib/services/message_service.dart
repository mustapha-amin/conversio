import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/models/chat.dart';
import 'package:conversio/models/message.dart';
import 'package:uuid/uuid.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final MessageService _instance = MessageService._internal();

  MessageService._internal();

  factory MessageService() {
    return _instance;
  }

  Future<String> sendMessage(Message message, String? chatId) async {
    Chat? newChat;
    try {
      if (chatId == null) {
        final chat = Chat(
          id: Uuid().v4(),
          isGroup: false,
          members: [message.senderId!, message.receiverId!],
        );
        newChat = await createChat(chat);
      }
      await _firestore.runTransaction((transaction) async {
        transaction.set(
          _firestore
              .collection("chats")
              .doc(chatId ?? newChat!.id)
              .collection("messages")
              .doc(message.id),
          message.toJson(),
        );

        transaction.update(
          _firestore.collection("chats").doc(chatId ?? newChat!.id),
          {
            'lastMessage': message.message,
            'lastMessageTimestamp': message.timeSent,
          },
        );
      });
      return chatId ?? newChat!.id;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> deleteMessage(String messageId, String chatId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        transaction.delete(
          _firestore
              .collection("chats")
              .doc(chatId)
              .collection("messages")
              .doc(messageId),
        );

        final chatRef = _firestore.collection("chats").doc(chatId);
        final chatSnapshot = await transaction.get(chatRef);

        if (chatSnapshot.exists &&
            chatSnapshot.data()?['lastMessageTimestamp'] != null &&
            chatSnapshot.data()?['lastMessage'] != null) {
          final messagesQuery =
              await _firestore
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy('timeSent', descending: true)
                  .limit(1)
                  .get();

          if (messagesQuery.docs.isNotEmpty) {
            final newLastMessage = Message.fromJson(
              messagesQuery.docs.first.data(),
            );
            transaction.update(chatRef, {
              'lastMessage': newLastMessage.message,
              'lastMessageTimestamp': newLastMessage.timeSent,
            });
          } else {
            transaction.update(chatRef, {
              'lastMessage': null,
              'lastMessageTimestamp': null,
            });
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  Stream<List<Message>> getMessages(
    String chatId, {
    int limit = 20,
    String? lastMessageId,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy('timeSent')
        .limit(limit);

    if (lastMessageId != null) {
      query = query.startAfter([
        _firestore
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .doc(lastMessageId)
            .get()
            .then((doc) => doc['timeSent']),
      ]);
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
    );
  }

  Future<void> markMessageAsRead(String messageId, String chatId) async {
    try {
      await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }

  Future<Chat> createChat(Chat chat) async {
    try {
      await _firestore.collection("chats").doc(chat.id).set(chat.toJson());
      return chat;
    } on Exception catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<List<Chat>?> getChats(String uid) {
    return _firestore
        .collection("chats")
        .where('members', arrayContains: uid)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList(),
        );
  }

   Stream<List<Chat>?> getGroupChats(String uid) {
    return _firestore
        .collection("chats")
        .where('members', arrayContains: uid)
        .where('isGroup', isEqualTo: true)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList(),
        );
  }

  Future<void> addParticipant(String chatId, String uid) async {
    await _firestore.collection("chats").doc(chatId).update({
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> removeParticipant(String chatId, String uid) async {
    await _firestore.collection("chats").doc(chatId).update({
      'members': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> updateChat(Chat chat) async {
    await _firestore.collection("chats").doc(chat.id).update(chat.toJson());
  }
}
