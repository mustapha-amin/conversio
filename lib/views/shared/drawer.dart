import 'package:conversio/services/database.dart';
import 'package:conversio/views/screens/fullscreen_image.dart';
import 'package:conversio/views/screens/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sizer/sizer.dart';

import '../../models/user.dart';
import '../../providers/theme_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/textstyle.dart';
import 'alert_dialog.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: 70.w,
      child: StreamBuilder(
        stream: DatabaseService().getUserInfo(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return switch (snapshot.connectionState) {
            ConnectionState.waiting => SizedBox(),
            _ =>
              snapshot.hasData
                  ? ListView(
                    children: [
                      DrawerHeader(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Scaffold.of(context).closeDrawer();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FullScreenImage(
                                        user: user,
                                        heroTag: user!.id,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Hero(
                                tag: user!.id!,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    user.profileImgUrl!,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              user.name!,
                              style: kTextStyle(
                                context: context,
                                size: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.bio!,
                              style: kTextStyle(context: context, size: 13),
                            ),
                          ],
                        ),
                      ),
                      SwitchListTile(
                        title: Text(
                          "Dark mode",
                          style: kTextStyle(context: context, size: 14),
                        ),
                        value: context.watch<ThemeProvider>().isDark,
                        onChanged:
                            (_) => context.read<ThemeProvider>().toggleTheme(),
                      ),
                      ListTile(
                        title: Text(
                          "Edit profile",
                          style: kTextStyle(context: context, size: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UpdateProfile(user: user);
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Log out",
                          style: kTextStyle(context: context, size: 14),
                        ),
                        onTap: () async {
                          alertDialog(
                            context,
                            "Log out",
                            "Do you want to log out",
                            [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await AuthService.firebaseAuth.signOut();
                                  await Restart.restartApp();
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )
                  : Text("An error occured"),
          };
        },
      ),
    );
  }
}
