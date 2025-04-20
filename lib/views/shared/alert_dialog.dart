import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';

Future<void> alertDialog(BuildContext context, String? title, String? content,
    List<Widget> actions) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title!,
          style: kTextStyle(
            context: context,
            size: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content!,
          style: kTextStyle(context: context, size: 15),
        ),
        actions: actions,
      );
    },
  );
}
