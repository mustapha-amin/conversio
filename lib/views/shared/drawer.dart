import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/user.dart';
import '../../providers/theme_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/textstyle.dart';
import 'alert_dialog.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.user,
  });

  final ConversioUser user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: 70.w,
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15.w,
                ),
                Text(
                  user.name!,
                  style: kTextStyle(
                    context: context,
                    size: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.bio!,
                  style: kTextStyle(context: context, size: 15),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              "Log out",
              style: kTextStyle(context: context, size: 14.sp),
            ),
            onTap: () async {
              alertDialog(context, "Log out", "Do you want to log out", [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await AuthService.firebaseAuth.signOut();
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
              ]);
            },
          ),
          SwitchListTile(
            title: Text(
              "Dark mode",
              style: kTextStyle(context: context, size: 14.sp),
            ),
            value: context.watch<ThemeProvider>().isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
          )
        ],
      ),
    );
  }
}
