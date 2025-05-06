import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/screens/chatscreen.dart';
import 'package:conversio/views/screens/conversio_users.dart';
import 'package:conversio/views/shared/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  final screens = [ChatScreen(isGroup: false), ChatScreen(isGroup: true)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Iconsax.menu,
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
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Iconsax.message), label: "Chats"),
          NavigationDestination(
            icon: Icon(Iconsax.people),
            label: "Group Chats",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(ConversioUsersScreen());
        },
        child: Icon(Iconsax.message),
      ),
    );
  }
}
