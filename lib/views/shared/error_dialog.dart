import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String? text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.end,
        content: Text(
          text!,
          style: kTextStyle(context: context, size: 12),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Ok",
              style: kTextStyle(context: context, size: 10),
            ),
          )
        ],
      );
    },
  );
}
