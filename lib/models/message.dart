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
      timeSent: DateTime.parse(json['timeSent']),
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
