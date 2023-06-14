import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/utils/enums.dart';

class Message {
  String? content;
  String? senderId;
  String? receiverId;
  DateTime? timeSent;

  Message({this.content, this.senderId, this.receiverId, this.timeSent});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      timeSent:  (json['timeSent'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeSent': timeSent,
    };
  }
}

class MessageList {
  List<Message>? messages;

  MessageList({this.messages});

  factory MessageList.fromJson(Map<String, dynamic> json) {
    return MessageList(messages: json['messages'] as List<Message>);
  }
}
