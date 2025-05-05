import 'package:conversio/models/message.dart';
import 'package:conversio/services/message_service.dart';
import 'package:conversio/views/shared/error_dialog.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  MessageService messageService = MessageService();
  bool loading = false;
  String? chatId;

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
}
