import 'package:conversio/models/chat.dart';
import 'package:conversio/models/message.dart';
import 'package:conversio/services/message_service.dart';
import 'package:conversio/utils/extensions.dart';
import 'package:conversio/views/screens/message_screen.dart';
import 'package:conversio/views/shared/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageProvider extends ChangeNotifier {
  MessageService messageService = MessageService();
  bool loading = false;
  String? chatId;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  void toggleLoading(bool status) {
    loading = status;
    notifyListeners();
  }

  void sendMessage(
    BuildContext context,
    Message message,
    String? chatId,
  ) async {
    try {
      toggleLoading(true);
      chatId = await messageService.sendMessage(message, chatId);
      toggleLoading(false);
    } catch (e) {
      toggleLoading(false);
      if (context.mounted) {
        showErrorDialog(context, "Unable to send message");
      }
    }
  }

  void createGChat(BuildContext context, Chat chat) async {
    try {
      toggleLoading(true);
      final newChat = await messageService.createChat(chat);
      toggleLoading(false);
      if (context.mounted) context.replace(MessageScreen(chat: newChat));
    } catch (e) {
      toggleLoading(false);
      if (context.mounted) {
        showErrorDialog(context, "Unable to create group chat");
      }
    }
  }
}
