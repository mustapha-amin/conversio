import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final bool isGroup;
  final List<String> members;
  final String? name;
  final String? lastMessage;
  final DateTime? lastMessageTimestamp;
  final String? createdBy;
  final DateTime? createdAt;
  final List<String>? admins;
  final String? description;
  final String? imageUrl;

  factory Chat.oneToOne({
    required String id,
    required String member1,
    required String member2,
  }) {
    return Chat(id: id, isGroup: false, members: [member1, member2]);
  }

  Chat({
    required this.id,
    required this.isGroup,
    required this.members,
    this.admins,
    this.name,
    this.lastMessage,
    this.lastMessageTimestamp,
    this.createdBy,
    this.createdAt,
    this.description,
    this.imageUrl,
  });
  factory Chat.fromJson(Map<String, dynamic> json) {
  try {
    return Chat(
      id: json['id'] as String,
      isGroup: json['isGroup'] as bool,
      members: List<String>.from(json['members'] ?? []),
      name: json['name'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageTimestamp: (json['lastMessageTimestamp'] as Timestamp?)?.toDate(),
      createdBy: json['createdBy'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(), // Fixed parsing
      admins: json['admins'] != null ? List<String>.from(json['admins']) : null,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  } catch (e) {
    print('Error parsing Chat: $e, JSON: $json');
    rethrow; // Log and rethrow for debugging
  }
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isGroup': isGroup,
      'members': members,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'admins': admins,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  Chat copyWith({
    String? id,
    bool? isGroup,
    List<String>? members,
    String? name,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
    String? createdBy,
    DateTime? createdAt,
    List<String>? admins,
    String? description,
    String? imageUrl,
  }) {
    return Chat(
      id: id ?? this.id,
      isGroup: isGroup ?? this.isGroup,
      members: members ?? this.members,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      admins: admins ?? this.admins,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
