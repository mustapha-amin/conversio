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
import 'package:conversio/views/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends StatefulWidget {
  final Chat? chat;
  final ConversioUser? user;
  const MessageScreen({this.chat, this.user, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  MessageService messageService = MessageService();
  Chat? _currentChat;

  @override
  void initState() {
    super.initState();
    _currentChat = widget.chat;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null && _currentChat == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Invalid chat or user",
            style: kTextStyle(context: context, size: 14),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.user != null) ...[
              InkWell(
                onTap: () => log(widget.user.toString()),
                child: ClipOval(
                  child: Image.network(
                    widget.user!.profileImgUrl!,
                    width: 40,
                    errorBuilder: (_, __, ___) => const Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.user?.name ?? 'Unknown User',
                style: kTextStyle(context: context, size: 20),
              ),
            ] else if (_currentChat != null) ...[
              ClipOval(
                child: Image.network(
                  _currentChat!.imageUrl ?? '',
                  width: 40,
                  errorBuilder: (_, __, ___) => const Icon(Iconsax.people),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _currentChat?.name ?? 'Group Chat',
                style: kTextStyle(context: context, size: 20),
              ),
            ],
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _currentChat == null && widget.user != null
                    ? StreamBuilder<Chat?>(
                      stream: MessageService().getChatWithUser(
                        AuthService.userid!,
                        widget.user!.id!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: Loader());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error loading chat",
                              style: kTextStyle(context: context, size: 14),
                            ),
                          );
                        }

                        final chat = snapshot.data;
                        if (chat != null) {
                          _currentChat = chat;
                          return StreamBuilder(
                            stream: messageService.getMessages(chat.id),
                            builder: (ctx, snap) {
                              if (snap.hasData) {
                                return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: snap.data!.length,
                                  itemBuilder: (ctx, index) {
                                    final message = snap.data![index];
                                    return ChatBubble(message: message);
                                  },
                                );
                              } else if (!snap.hasData) {
                                return Center(
                                  child: Text(
                                    "No messages yet",
                                    style: kTextStyle(
                                      context: context,
                                      size: 14,
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(child: Loader());
                              }
                            },
                          );
                        }

                        return Center(
                          child: Text(
                            "No chat found",
                            style: kTextStyle(context: context, size: 14),
                          ),
                        );
                      },
                    )
                    : StreamBuilder(
                      stream: messageService.getMessages(_currentChat!.id),
                      builder: (ctx, snap) {
                        if (snap.hasData) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: snap.data!.length,
                            itemBuilder: (ctx, index) {
                              final message = snap.data![index];
                              return ChatBubble(message: message);
                            },
                          );
                        } else if (!snap.hasData) {
                          return Center(
                            child: Text(
                              "No messages yet",
                              style: kTextStyle(context: context, size: 14),
                            ),
                          );
                        } else {
                          return const Center(child: Loader());
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
                  if (temp.isEmpty) return;

                  try {
                    _messageController.clear();
                    context.read<MessageProvider>().sendMessage(
                      context,
                      Message(
                        id: Uuid().v4(),
                        senderId: AuthService.userid,
                        receiverId:
                            widget.user?.id ??
                            _currentChat?.members.firstWhere(
                              (id) => id != AuthService.userid,
                            ),
                        message: temp,
                        timeSent: DateTime.now(),
                        replyToMessageId: null,
                      ),
                      _currentChat?.id,
                    );
                    if (_currentChat == null && widget.user != null) {
                      setState(() {
                        _currentChat = Chat(
                          id: context.read<MessageProvider>().chatId!,
                          isGroup: false,
                          members: [AuthService.userid!, widget.user!.id!],
                        );
                      });
                    }
                  } on Exception catch (e) {
                    _messageController.value = TextEditingValue(text: temp);
                    log(e.toString());
                    showErrorDialog(context, "An error occurred");
                  }
                },
                icon: Consumer<MessageProvider>(
                  builder: (ctx, val, _) {
                    return val.loading
                        ? const CircularProgressIndicator()
                        : Icon(
                          Iconsax.send_1,
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
