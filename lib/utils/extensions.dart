import 'package:flutter/material.dart';

extension NavigationExts on BuildContext {
  void push(Widget screen) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => screen));
  void pop() => Navigator.pop(this);
  void replace(Widget screen) => Navigator.pushReplacement(
    this,
    MaterialPageRoute(builder: (context) => screen),
  );
}
