import 'package:conversio/models/message.dart';
import 'package:conversio/models/user.dart';
import 'package:conversio/pallette.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: DatabaseService().getMessages(widget.user!.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].content!),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "No messages yet",
                      style: kTextStyle(context: context, size: 20.sp),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 10.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: "Type a message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      DatabaseService().sendMessage(Message(
                        content: messageController.text,
                        senderId: AuthService.userid,
                        receiverId: widget.user!.id,
                        timeSent: DateTime.now(),
                      ));
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
