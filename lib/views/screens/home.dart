import 'package:conversio/models/user.dart';
import 'package:conversio/pallette.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.menu_rounded,
                      color:
                          context.watch<ThemeProvider>().isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  );
                },
              ),
              title: Text(
                "Conversio",
                style: kTextStyle(
                  context: context,
                  size: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                        ),
                      )
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
                    child: SpinKitWaveSpinner(
                      size: 80,
                      color: AppColors.primary,
                    ),
                  );
                }
              },
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: SpinKitWaveSpinner(size: 80, color: AppColors.primary),
          ),
        );
      },
    );
  }
}
