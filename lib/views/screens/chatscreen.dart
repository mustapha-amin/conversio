import 'dart:developer';

import 'package:conversio/models/chat.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/pallette.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/services/message_service.dart';
import 'package:conversio/views/shared/chat_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  final bool isGroup;
  ChatScreen({required this.isGroup, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConversioUser?>(
      stream: DatabaseService().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ConversioUser user = snapshot.data!;
          return StreamBuilder<List<Chat>?>(
            stream:
                widget.isGroup
                    ? MessageService().getGroupChats(user.id!)
                    : MessageService().getChats(user.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log("snap exists");
                log(snapshot.data!.length.toString());
                List<Chat>? chats = snapshot.data!;
                return switch (chats.isEmpty) {
                  true => Center(
                    child: Text(
                      widget.isGroup ? "No groups yet" : "No chats yet",
                    ),
                  ),
                  false => ChatListview(isGroup: widget.isGroup, chats: chats),
                };
              } else if (snapshot.hasError) {
                return Center(child: Text("An error occured"));
              } else {
                return const Center(
                  child: SpinKitWaveSpinner(size: 80, color: AppColors.primary),
                );
              }
            },
          );
        }
        return Center(
          child: SpinKitWaveSpinner(size: 80, color: AppColors.primary),
        );
      },
    );
  }
}
