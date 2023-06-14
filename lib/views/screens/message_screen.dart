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
import 'dart:developer';
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

  @override
  Widget build(BuildContext context) {
    var themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showModalBottomSheet(
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FullScreenImage(
                                imgUrl: widget.user!.profileImgUrl,
                                heroTag: widget.user!.id,
                              );
                            }));
                          },
                          child: Hero(
                            transitionOnUserGestures: true,
                            tag: widget.user!.id!,
                            child: CircleAvatar(
                              radius: 15.w,
                              backgroundImage:
                                  NetworkImage(widget.user!.profileImgUrl!),
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
              addHorizontalSpacing(10.sp),
              Text(widget.user!.name!),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder<List<Message>>(
            stream: DatabaseService().getMessages(widget.user!.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: snapshot.data!.isEmpty
                      ? Center(
                          child: Text(
                            "No messages yet",
                            style: kTextStyle(context: context, size: 15),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return CustomChatBubble(
                                message: snapshot.data![index],
                              );
                            },
                          ),
                        ),
                );
              } else {
                return Center(
                  child: Text(
                    "No messages yet",
                    style: kTextStyle(context: context, size: 15),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: GoogleFonts.raleway(fontSize: 14.sp),
                suffixIcon: IconButton(
                  onPressed: () {
                    messageController.text.isEmpty
                        ? log(widget.user!.id.toString())
                        : DatabaseService().sendMessage(
                            Message(
                              content: messageController.text,
                              senderId: AuthService.userid,
                              receiverId: widget.user!.id,
                              timeSent: DateTime.now(),
                            ),
                          );
                    messageController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          )
        ],
      ),
    );
  }
}
