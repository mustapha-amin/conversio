import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? content;
  String? senderId;
  String? receiverId;
  DateTime? timeSent;

  Message({String? id, this.content, this.senderId, this.receiverId, this.timeSent}) : id = DateTime.now().microsecondsSinceEpoch.toString();

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

  @override
  bool operator ==(covariant Object other) {
    return identical(this, other) ||
        other is Message &&
            id == other.id &&
            content == other.content &&
            senderId == other.senderId &&
            receiverId == other.receiverId &&
            timeSent == other.timeSent;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      senderId.hashCode ^
      receiverId.hashCode ^
      timeSent.hashCode;
}
