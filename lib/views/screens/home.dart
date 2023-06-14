import 'package:conversio/models/user.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/chat_tile.dart';
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
                if (snapshot.hasData) {
                  List<ConversioUser> users = snapshot.data!;
                  return users.isEmpty
                      ? Center(
                          child: Text(
                          "No users yet",
                          style: kTextStyle(context: context, size: 20),
                        ))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return ChatTile(user: users[index]);
                                },
                              ),
                            ),
                          ],
                        );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
