import 'package:conversio/services/database.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:conversio/views/screens/message_screen.dart';
import 'package:conversio/views/shared/loader.dart';
import 'package:flutter/material.dart';

class ConversioUsersScreen extends StatelessWidget {
  const ConversioUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select user to chat")),
      body: StreamBuilder(
        stream: DatabaseService().getUsers(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (context, index) {
                final user = snap.data![index];
                return ListTile(
                  onTap: () => context.replace(MessageScreen(user: user)),
                  title: Text(user.name!),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImgUrl!),
                  ),
                );
              },
            );
          } else if (snap.hasError) {
            return Center(child: Text("An error occured"));
          } else {
            return Loader();
          }
        },
      ),
    );
  }
}
