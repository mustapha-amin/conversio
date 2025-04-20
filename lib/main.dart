import 'package:conversio/providers/db_provider.dart';
import 'package:conversio/services/database.dart';
import 'models/user.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/providers/auth_status.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/theme_prefs.dart';
import 'package:conversio/theme.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'views/screens/auth/wrapper.dart';

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
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthStatus(),
        ),
        StreamProvider<User?>.value(
          value: AuthService.authStateChanges,
          initialData: FirebaseAuth.instance.currentUser,
        ),
        ChangeNotifierProvider(
          create: (_) => DbProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, _, __) {
          var themeStatus = Provider.of<ThemeProvider>(context).isDark;
          return MaterialApp(
            
            debugShowCheckedModeBanner: false,
            home: const Wrapper(),
            theme: AppTheme.themeData(themeStatus, context),
          );
        },
      ),
    ),
  );
}
