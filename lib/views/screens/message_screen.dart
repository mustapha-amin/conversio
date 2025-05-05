import 'dart:developer';

import 'package:conversio/models/chat.dart';
import 'package:conversio/models/message.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/providers/message_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/message_service.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/shared/chat_bubble.dart';
import 'package:conversio/views/shared/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends StatefulWidget {
  Chat? chat;
  final ConversioUser? user;
  MessageScreen({this.chat, this.user, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  MessageService messageService = MessageService();

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                widget.user?.profileImgUrl ?? '',
                width: 40,
                errorBuilder: (_, __, ___) => const Icon(Icons.person),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.user?.name ?? 'Unknown User',
              style: kTextStyle(context: context, size: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                widget.chat == null
                    ? ListView(
                      children: [Center(child: Text("No messages yet"))],
                    )
                    : StreamBuilder(
                      stream: messageService.getMessages(widget.chat!.id),
                      builder: (ctx, snap) {
                        if (snap.hasData) {
                          return ListView.builder(
                            itemCount: snap.data!.length,
                            itemBuilder: (ctx, index) {
                              final message = snap.data![index];
                              return ChatBubble(message: message);
                            },
                          );
                        } else if (!snap.hasData) {
                          return Text("No data");
                        } else {
                          return Text("Loading");
                        }
                      },
                    ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: TextField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    maxLines: 5,
                    minLines: 1,
                    controller: _messageController,
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                    },
                    onSubmitted: (text) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Type a message",
                      hintStyle: kTextStyle(
                        context: context,
                        size: 15,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final String temp = _messageController.text.trim();
                  try {
                    _messageController.clear();
                    context.read<MessageProvider>().sendMessage(
                      context,
                      Message(
                        id: Uuid().v4(),
                        senderId: AuthService.userid,
                        receiverId: widget.user!.id,
                        message: temp,
                        timeSent: DateTime.now(),
                        replyToMessageId: null,
                      ),
                      widget.chat?.id,
                    );
                    if (widget.chat == null) {
                      setState(() {
                        widget.chat = Chat(
                          id: context.read<MessageProvider>().chatId!,
                          isGroup: false,
                          members: [AuthService.userid!, widget.user!.id!],
                        );
                      });
                    }
                  } on Exception catch (e) {
                    _messageController.value = TextEditingValue(text: temp);
                    log(e.toString());
                    showErrorDialog(context, "An error occured");
                  }
                },
                icon: Consumer<MessageProvider>(
                  builder: (ctx, val, _) {
                    return val.loading
                        ? CircularProgressIndicator()
                        : Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        );
                  },
                ),
                iconSize: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
