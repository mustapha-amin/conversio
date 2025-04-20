import 'dart:developer';

import 'package:conversio/pallette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:conversio/models/message.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/spacing.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/shared/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:conversio/providers/theme_provider.dart';

import 'fullscreen_image.dart';

class MessageScreen extends StatefulWidget {
  ConversioUser? user;
  MessageScreen({this.user, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController messageController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.position.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceIn,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            modalSheet(themeprovider, context);
          },
          child: Row(
            children: [
              Hero(
                tag: widget.user!.id!,
                transitionOnUserGestures: true,
                child: CircleAvatar(
                  radius: 6.w,
                  backgroundImage: NetworkImage(widget.user!.profileImgUrl!),
                ),
              ),
              addHorizontalSpacing(10),
              Text(widget.user!.name!),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("Clear chat"),
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Clear chats",
                              style: kTextStyle(context: context, size: 15),
                            ),
                            content: Text(
                              "Do you want to delete all your conversations",
                              style: kTextStyle(context: context, size: 12),
                            ),
                            actions: [
                              SizedBox(
                                width: 25.w,
                                child: OutlinedButton(
                                  onPressed: () {
                                    DatabaseService().clearChat(
                                      widget.user!.id,
                                    );
                                    log(widget.user!.id.toString());
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Yes",
                                    style: kTextStyle(
                                      context: context,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25.w,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "No",
                                    style: kTextStyle(
                                      context: context,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                ),
              ];
            },
          ),
        ],
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          StreamBuilder<List<Message>>(
            stream: DatabaseService().getMessages(widget.user!.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child:
                      snapshot.data!.isEmpty
                          ? Center(
                            child: Text(
                              "No messages yet",
                              style: kTextStyle(context: context, size: 15),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              controller: _scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return CustomChatBubble(
                                  id: snapshot.data![index].id!,
                                  message: snapshot.data![index],
                                );
                              },
                            ),
                          ),
                );
              } else {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () async {
                await Future.delayed(
                  const Duration(seconds: 1),
                  () => _scrollController.position.animateTo(
                    _scrollController.position.maxScrollExtent + 300,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                  ),
                );
              },
              style: GoogleFonts.raleway(fontSize: 14, color: Colors.black),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              controller: messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    messageController.text.isEmpty
                        ? null
                        : {
                          DatabaseService().sendMessage(
                            Message(
                              content: messageController.text,
                              senderId: AuthService.userid,
                              receiverId: widget.user!.id,
                              timeSent: DateTime.now(),
                            ),
                          ),
                          messageController.clear(),
                          await Future.delayed(
                            const Duration(seconds: 1),
                            () => _scrollController.position.animateTo(
                              _scrollController.position.maxScrollExtent + 300,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceIn,
                            ),
                          ),
                        };
                  },
                  icon: const Icon(Icons.send, color: AppColors.accent),
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalSheet(
    ThemeProvider themeprovider,
    BuildContext context,
  ) {
    return showModalBottomSheet(
      backgroundColor:
          themeprovider.isDark ? Colors.grey[900] : Colors.grey[100],
      context: context,
      builder: (context) {
        return SizedBox(
          height: 50.h,
          width: 100.w,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FullScreenImage(
                            user: widget.user,
                            heroTag: widget.user!.id,
                          );
                        },
                      ),
                    );
                  },
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: widget.user!.id!,
                    child: CircleAvatar(
                      radius: 15.w,
                      backgroundImage: NetworkImage(
                        widget.user!.profileImgUrl!,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '@${widget.user!.name!}',
                style: kTextStyle(context: context, size: 15),
              ),
              addVerticalSpacing(4.h),
              Text(
                widget.user!.bio!,
                style: kTextStyle(context: context, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
