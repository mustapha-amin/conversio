import 'package:conversio/pallette.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/theme_prefs.dart';
import 'package:conversio/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'screens/auth/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Themeprefs.initThemeSettings();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Sizer(
        builder: (context, _, __) {
          var themeStatus = Provider.of<ThemeProvider>(context).isDark;
          return MaterialApp(
            home: MyApp(),
            theme: AppTheme.themeData(themeStatus, context),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}
