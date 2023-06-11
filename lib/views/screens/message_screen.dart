import 'package:conversio/models/message.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/pallette.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MessageScreen extends StatefulWidget {
  ConversioUser? user;
  MessageScreen({this.user, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.user!.name!),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Message>>(
          stream: DatabaseService().getMessages(widget.user!.id),
          builder: (context, snapshot) {
            return ListView(
              children: [
                ListTile()
              ],
            );
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 7.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 85.w,
                child: TextField(
                  textAlign: TextAlign.justify,
                  maxLines: 3,
                  controller: messageController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
                child: IconButton(
                  color: AppColors.accent,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    DatabaseService().sendMessage(Message(
                      content: messageController.text,
                      senderId: AuthService.userid,
                      receiverId: widget.user!.id,
                      timeSent: DateTime.now(),
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
