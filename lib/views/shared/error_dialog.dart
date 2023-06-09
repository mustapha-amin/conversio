import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String? text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.end,
        content: Text(text!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          )
        ],
      );
    },
  );
}
