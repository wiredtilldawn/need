import 'package:flutter/material.dart';
import 'package:need/pages/login_page.dart';
import 'package:need/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showloginpage = true;

  void togglepages(){
    setState(() {
      showloginpage = !showloginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginpage){
      return LoginPage(onTap: togglepages);
    }

    else{
      return RegisterPage(onTap: togglepages);
    }
  }
}
