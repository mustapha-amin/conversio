import 'package:conversio/models/user.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../shared/alert_dialog.dart';
import '../shared/drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConversioUser?>(
      stream: DatabaseService().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ConversioUser user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    color: context.watch<ThemeProvider>().isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                );
              }),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            drawer: HomeDrawer(user: user),
            body: StreamBuilder<List<ConversioUser>>(
                stream: DatabaseService().getUsers(),
                builder: (context, snapshot) {
                  List<ConversioUser> users = snapshot.data!;
                  return users.isEmpty
                      ? Center(
                          child: Text(
                            "No users yet",
                            style: kTextStyle(context: context, size: 20),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey,
                            );
                          },
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MessageScreen(user: users[index]);
                                  }));
                                },
                                leading: CircleAvatar(
                                  backgroundColor:
                                      context.watch<ThemeProvider>().isDark
                                          ? Colors.grey[900]!
                                          : Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    color: context.watch<ThemeProvider>().isDark
                                        ? Colors.grey
                                        : Colors.grey[700],
                                  ),
                                ),
                                title: Text(
                                  users[index].name!,
                                  style: kTextStyle(
                                    context: context,
                                    size: 13.sp,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
