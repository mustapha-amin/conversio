import 'package:conversio/models/chat.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../screens/message_screen.dart';
import 'package:intl/intl.dart' as intl;

class ChatTile extends StatelessWidget {
  ConversioUser? user;
  Chat? chat;
  ChatTile({super.key, this.user, this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(MessageScreen(chat: chat, user: user)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          chat!.isGroup ? chat!.imageUrl! : user!.profileImgUrl!,
        ),
      ),
      title: chat!.isGroup ? Text(chat!.name!) : Text(user!.name!),
      subtitle: Text(chat!.lastMessage ?? ''),
      trailing: Text(
        chat!.lastMessageTimestamp == null
            ? ''
            : intl.DateFormat.Hms().format(chat!.lastMessageTimestamp!),
      ),
    );
  }
}
