import 'package:conversio/pallette.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

kTextStyle({
  required BuildContext context,
  required double size,
  Color? color,
  FontWeight? fontWeight,
}) {
  var provider = Provider.of<ThemeProvider>(context);
  return GoogleFonts.manrope(
    color:
        color ??
        (provider.isDark ? AppColors.darktextColor : AppColors.lighttextColor),
    fontSize: size,
    fontWeight: fontWeight ?? FontWeight.normal,
  );
}
