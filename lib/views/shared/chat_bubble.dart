import 'package:conversio/models/message.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomChatBubble extends StatelessWidget {
  Message message;
  CustomChatBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
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
    );
  }
}
