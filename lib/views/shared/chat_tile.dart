import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/views/screens/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/user.dart';
import '../../utils/textstyle.dart';
import '../screens/message_screen.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.user,
  });

  final ConversioUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: DatabaseService().getRecentMessage(user.id),
          builder: (context, snapshot) {
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: context.watch<ThemeProvider>().isDark
                  ? Colors.grey[900]
                  : Colors.grey[100],
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MessageScreen(user: user);
                }));
              },
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FullScreenImage(user: user, heroTag: user.id);
                  }));
                },
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: user.id!,
                  child: CircleAvatar(
                      radius: 7.w,
                      backgroundColor: context.watch<ThemeProvider>().isDark
                          ? Colors.grey[300]!
                          : Colors.grey[400],
                      backgroundImage: NetworkImage(
                        user.profileImgUrl!,
                      )),
                ),
              ),
              title: Text(
                user.name!,
                style: kTextStyle(
                  context: context,
                  size: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(snapshot.hasData ? snapshot.data!.content! : '',
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle(context: context, size: 12)),
              trailing: Text(
                snapshot.hasData
                    ? DateFormat(DateFormat.HOUR_MINUTE).format(
                        snapshot.data!.timeSent!,
                      )
                    : '',
                style: kTextStyle(context: context, size: 12),
              ),
            );
          }),
    );
  }
}
