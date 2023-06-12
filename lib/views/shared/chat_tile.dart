import 'package:conversio/providers/theme_provider.dart';
import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: context.watch<ThemeProvider>().isDark ? Colors.grey[900] : Colors.grey[100],
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) {
            return MessageScreen(
                user: user);
          }));
        },
        leading: CircleAvatar(
          backgroundColor: context
                  .watch<ThemeProvider>()
                  .isDark
              ? Colors.grey[300]!
              : Colors.grey[600],
          child: Icon(
            Icons.person,
            color: context
                    .watch<ThemeProvider>()
                    .isDark
                ? Colors.grey
                : Colors.grey[700],
          ),
        ),
        title: Text(
          user.name!,
          style: kTextStyle(
            context: context,
            size: 13.sp,
          ),
        ),
      ),
    );
  }
}