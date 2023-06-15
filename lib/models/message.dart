import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? content;
  String? senderId;
  String? receiverId;
  DateTime? timeSent;

  Message(
      {String? id, this.content, this.senderId, this.receiverId, this.timeSent})
      : id = DateTime.now().microsecondsSinceEpoch.toString();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      timeSent: (json['timeSent'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeSent': timeSent,
    };
  }

  Message copyWith({
    String? id,
    String? content,
    String? senderId,
    String? receiverId,
    DateTime? timeSent,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timeSent: timeSent ?? this.timeSent,
    );
  }
}
