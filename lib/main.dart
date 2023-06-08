import 'package:conversio/pallette.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/theme_prefs.dart';
import 'package:conversio/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'screens/auth/wrapper.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Themeprefs.initThemeSettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        StreamProvider<User?>.value(
          value: AuthService().authStateChanges,
          initialData: null,
        )
      ],
      child: Sizer(
        builder: (context, _, __) {
          var themeStatus = Provider.of<ThemeProvider>(context).isDark;
          return MaterialApp(
            home: Wrapper(),
            theme: AppTheme.themeData(themeStatus, context),
          );
        },
      ),
    ),
  );
}
