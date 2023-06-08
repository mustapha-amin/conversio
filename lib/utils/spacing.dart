import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget addVerticalSpacing(double height) {
  return SizedBox(
    height: height.sp,
  );
}

Widget addHorizontalSpacing(double width) {
  return SizedBox(
    width: width.sp,
  );
}
