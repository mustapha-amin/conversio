import 'dart:developer';

import 'package:conversio/models/message.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomChatBubble extends StatelessWidget {
  Message message;
  String id;
  CustomChatBubble({required this.message, required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log(id.toString());
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.black
                    : Colors.white,
                children: [
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  context.watch<ThemeProvider>().isDark
                                      ? Colors.black
                                      : Colors.white,
                              title: Text(
                                "Delete message",
                                style: kTextStyle(context: context, size: 15),
                              ),
                              content: Text(
                                "Do you want to delete this message",
                                style: kTextStyle(context: context, size: 12),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                SizedBox(
                                  width: 25.w,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      DatabaseService().deleteMessage(message);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: kTextStyle(
                                          context: context, size: 10),
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
                                          context: context, size: 10),
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    title: Text(
                      "Delete",
                      style: kTextStyle(
                        context: context,
                        size: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Copy to clipboard",
                      style: kTextStyle(
                        context: context,
                        size: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: Text(
                      "cancel",
                      style: kTextStyle(
                        context: context,
                        size: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: ChatBubble(
        elevation: 0,
        clipper: ChatBubbleClipper5(
          type: message.senderId == AuthService.userid
              ? BubbleType.sendBubble
              : BubbleType.receiverBubble,
        ),
        alignment: message.senderId == AuthService.userid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: message.senderId == AuthService.userid
            ? Colors.blue
            : Colors.grey[600],
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 70.w,
          ),
          child: Text(
            message.content!,
            style: GoogleFonts.raleway(fontSize: 14.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
