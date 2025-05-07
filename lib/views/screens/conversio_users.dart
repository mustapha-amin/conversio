import 'dart:developer';

import 'package:conversio/pallette.dart';
import 'package:conversio/providers/message_provider.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/screens/message_screen.dart';
import 'package:conversio/views/shared/group_chat_creation_sheet.dart';
import 'package:conversio/views/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class ConversioUsersScreen extends StatefulWidget {
  const ConversioUsersScreen({super.key});

  @override
  State<ConversioUsersScreen> createState() => _ConversioUsersScreenState();
}

class _ConversioUsersScreenState extends State<ConversioUsersScreen> {
  List<String> users = [];
  bool groupSelected = false;

  void _showGroupDetailsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GroupCreationSheet(selectedUsers: users),
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<MessageProvider>().loading
        ? Scaffold(body: Loader())
        : Scaffold(
          appBar: AppBar(
            leading:
                groupSelected
                    ? InkWell(
                      onTap: () {
                        users.clear();
                        setState(() => groupSelected = false);
                      },
                      child: Icon(Icons.close),
                    )
                    : BackButton(),
            title:
                !groupSelected
                    ? Text(
                      "New message",
                      style: kTextStyle(
                        context: context,
                        size: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                    : Text.rich(
                      TextSpan(
                        text: "New group\n",
                        style: kTextStyle(
                          context: context,
                          size: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: "${users.length} selected",
                            style: kTextStyle(
                              context: context,
                              size: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
          body: StreamBuilder(
            stream: DatabaseService().getUsers(),
            builder: (ctx, snap) {
              if (snap.hasData) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          groupSelected = true;
                        });
                      },
                      leading: Icon(Iconsax.people),
                      title: Text(
                        "New Group",
                        style: kTextStyle(
                          context: context,
                          size: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snap.data!.length,
                        itemBuilder: (context, index) {
                          final user = snap.data![index];
                          return ListTile(
                            onTap: switch (groupSelected) {
                              true =>
                                () => setState(
                                  () =>
                                      users.contains(user.id)
                                          ? users.remove(user.id)
                                          : users.add(user.id!),
                                ),
                              false =>
                                () =>
                                    context.replace(MessageScreen(user: user)),
                            },
                            title: Text(user.name!),
                            leading: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user.profileImgUrl!,
                                  ),
                                ),
                                if (users.contains(user.id))
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (snap.hasError) {
                return Center(child: Text("An error occured"));
              } else {
                return Loader();
              }
            },
          ),
          floatingActionButton:
              groupSelected & users.isNotEmpty
                  ? FloatingActionButton(
                    onPressed:
                        users.isNotEmpty
                            ? () => _showGroupDetailsDialog()
                            : null,
                    child: Icon(Iconsax.arrow_circle_right_copy),
                  )
                  : SizedBox(),
        );
  }
}
