import 'package:conversio/models/message.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' as intl;

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Row(
            mainAxisAlignment:
                message.senderId == AuthService.userid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 60.w),
                padding: const EdgeInsets.all(12.0),

                decoration: BoxDecoration(
                  color:
                      message.senderId == AuthService.userid
                          ? Colors.blue[400]
                          : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft:
                        message.senderId == AuthService.userid
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                    bottomRight:
                        message.senderId == AuthService.userid
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                  ),
                ),
                child: Text(
                  message.message!,
                  style: TextStyle(
                    color:
                        message.senderId == AuthService.userid
                            ? Colors.white
                            : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5, bottom: 2),
            child: Text(
              intl.DateFormat.Hm().format(message.timeSent!),
              style: kTextStyle(
                context: context,
                size: 10,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
