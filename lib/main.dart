import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:need/auth/login_or_register.dart';
import 'package:need/firebase_options.dart';
import 'package:need/pages/home_page.dart';
import 'package:need/pages/profile_page.dart';
import 'package:need/theme/dark_theme.dart';
import 'package:need/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'auth/auth.dart';
import 'helper/theme_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: AuthPage(),
        ),
      ),
    );
  }
}
