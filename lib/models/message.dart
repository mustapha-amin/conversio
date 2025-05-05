import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  DateTime? timeSent;
  String? replyToMessageId;

  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.timeSent,
    this.replyToMessageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timeSent': timeSent,
      'replyToMessageId': replyToMessageId,
    };
  }

 factory Message.fromJson(Map<String, dynamic> json) {
  try {
    return Message(
      id: json['id'] as String?,
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      message: json['message'] as String?,
      timeSent: (json['timeSent'] as Timestamp?)?.toDate(),
      replyToMessageId: json['replyToMessageId'] as String?,
    );
  } catch (e) {
    print('Error parsing Message: $e, JSON: $json');
    rethrow;
  }
}

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? chatID,
    DateTime? timeSent,
    bool? isRead,
    String? replyToMessageId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timeSent: timeSent ?? this.timeSent,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
    );
  }

  @override
  String toString() {
    return 'Messaging(id: $id, senderId: $senderId, receiverId: $receiverId, message: $message, replyToMessageId: $replyToMessageId, timeSent: $timeSent)';
  }
}
