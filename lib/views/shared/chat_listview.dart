import 'package:conversio/models/chat.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/views/shared/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatListview extends StatelessWidget {
  bool isGroup;
  List<Chat>? chats;
  ChatListview({this.isGroup = false, this.chats, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats!.length,
      itemBuilder: (context, index) {
        final chat = chats![index];
        final someuid = chat.members.firstWhere(
          (member) => member != AuthService.userid,
          orElse: () => AuthService.userid!,
        );
        return isGroup
            ? ChatTile(chat: chat)
            : StreamBuilder(
              stream: DatabaseService().getUserInfo(uid: someuid),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  return ChatTile(user: snap.data!, chat: chats![index]);
                } else if (snap.hasError) {
                  return Text("Error");
                } else {
                  return Skeletonizer(
                    child: ChatTile(
                      user: ConversioUser(
                        id: "user123",
                        name: "Mustapha Amin",
                        email: "mustapha@example.com",
                        bio: "Flutter enthusiast and mobile app developer",
                        profileImgUrl: "https://picsum.photos/200/200",
                      ),
                      chat: Chat(
                        id: 'ed', // Auto-generated ID
                        isGroup: true,
                        name: 'Flutter Developers',
                        members: [
                          'user1',
                          'user2',
                          'user3',
                          'user4',
                        ], // At least 2 members
                        admins: [
                          'user1',
                          'user2',
                        ], // First 2 members are admins
                        createdBy: 'user1',
                        createdAt: DateTime.now(),
                        lastMessage: 'Hey everyone! Welcome to the group!',
                        lastMessageTimestamp: DateTime.now(),
                        description:
                            'A group for Flutter enthusiasts to share knowledge',
                        imageUrl: 'https://example.com/flutter-group.jpg',
                      ),
                    ),
                  );
                }
              },
            );
      },
    );
  }
}
