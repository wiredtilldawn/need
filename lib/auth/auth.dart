import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:need/auth/login_or_register.dart';
import 'package:provider/provider.dart';

import '../helper/theme_provider.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if logged in
          if(snapshot.hasData){
            return ChangeNotifierProvider(
              create: (_) => ThemeProvider(),
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) => MaterialApp(
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  home: HomePage(),
                ),
              ),
            );;
          }

          //if not logged in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
