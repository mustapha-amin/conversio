import 'package:conversio/models/chat.dart';
import 'package:conversio/models/message.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' as intl;

class ChatBubble extends StatelessWidget {
  final Message message;
  final Chat chat;

  const ChatBubble({super.key, required this.message, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        mainAxisAlignment:
            message.senderId == AuthService.userid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          if (chat.isGroup && message.senderId != AuthService.userid)
            StreamBuilder(
              stream: DatabaseService().getUserInfo(uid: message.senderId),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircleAvatar();
                } else if (snap.hasData) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snap.data!.profileImgUrl!),
                  );
                } else {
                  return CircleAvatar(child: Icon(Iconsax.profile_circle));
                }
              },
            ),
          Stack(
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
              Positioned(
                right: message.senderId == AuthService.userid ? 10 : null,
                left: message.senderId == AuthService.userid ? null : 10,
                child: Text(
                  intl.DateFormat.Hm().format(message.timeSent!),
                  style: kTextStyle(
                    context: context,
                    size: 10,
                    color:
                        message.senderId == AuthService.userid
                            ? Colors.grey[300]
                            : Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
          if (chat.isGroup && message.senderId == AuthService.userid)
            StreamBuilder(
              stream: DatabaseService().getUserInfo(uid: message.senderId),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircleAvatar();
                } else if (snap.hasData) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snap.data!.profileImgUrl!),
                  );
                } else {
                  return CircleAvatar(child: Icon(Iconsax.profile_circle));
                }
              },
            ),
        ],
      ),
    );
  }
}
