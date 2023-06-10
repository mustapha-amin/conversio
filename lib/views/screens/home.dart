import 'package:conversio/models/user.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<User?>(context);
    return Scaffold(
        drawer: Drawer(
          elevation: 2,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          width: 70.w,
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  "Log out",
                  style: kTextStyle(context: context, size: 14.sp),
                ),
                onTap: () async {
                  await AuthService.firebaseAuth.signOut();
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
        ),
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
        body: Scaffold(
          body: StreamBuilder(
              stream: DatabaseService().getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<User> users = snapshot.data!;
                  return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: context.watch<ThemeProvider>().isDark
                                ? Colors.grey[900]
                                : Colors.grey[100],
                            leading: CircleAvatar(),
                            title: Text(
                              users[index].name!,
                              style: kTextStyle(
                                context: context,
                                size: 13.sp,
                              ),
                            ),
                          ),
                        );
                      });
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }
}
