import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:conversio/models/message.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
              backgroundColor:
                  context.watch<ThemeProvider>().isDark
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
                                  style: kTextStyle(context: context, size: 10),
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
                                  style: kTextStyle(context: context, size: 10),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Text(
                    "Delete",
                    style: kTextStyle(
                      context: context,
                      size: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: message.content!),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text("Copied to clipboard"),
                      ),
                    );
                  },
                  title: Text(
                    "Copy to clipboard",
                    style: kTextStyle(
                      context: context,
                      size: 12,
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
                      size: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Column(
        crossAxisAlignment:
            message.senderId == AuthService.userid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            elevation: 0,
            clipper: ChatBubbleClipper5(
              type:
                  message.senderId == AuthService.userid
                      ? BubbleType.sendBubble
                      : BubbleType.receiverBubble,
            ),
            alignment:
                message.senderId == AuthService.userid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 20),
            backGroundColor:
                message.senderId == AuthService.userid
                    ? Colors.blue
                    : Colors.grey[600],
            child: Container(
              constraints: BoxConstraints(maxWidth: 70.w),
              child: Text(
                message.content!,
                style: GoogleFonts.raleway(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Text(
            DateFormat(DateFormat.HOUR_MINUTE).format(message.timeSent!),
            style: kTextStyle(context: context, size: 10),
          ),
        ],
      ),
    );
  }
}
