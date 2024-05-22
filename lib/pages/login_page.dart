import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:need/components/button.dart';
import 'package:need/components/text_field.dart';
import 'package:provider/provider.dart';

import '../helper/theme_provider.dart';



class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //sign user in
  void signIn() async{
    //show loading screen
    showDialog(context: context, builder: (context) => const Center(
        child: CircularProgressIndicator(),
    ));

    //try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
      //pop loading screen
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  //display a dialog message
  void displayMessage(String message){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.background,
       appBar: AppBar(
         actions: [
           IconButton(
             icon: Icon(
               context.watch<ThemeProvider>().isDarkMode ? Icons.brightness_3 : Icons.brightness_7,
             ),
             onPressed: () {
               context.read<ThemeProvider>().toggleTheme();
             },
           ),
         ],
       ),
       body: Stack(
       children: [
         Positioned.fill(
         child: ListView(
           padding: const EdgeInsets.symmetric(horizontal: 25.0),
           children: [


             //logo
             const Icon(Icons.lock,size: 100,),

             const SizedBox(height: 50,),

             //welcome back
             Center(child: Text("Welcome back, you have been missed",  style: TextStyle(color: Colors.grey[700]),)),

             const SizedBox(height: 25,),

             //email
             MyTextField(controller: emailTextController, hintText: "Email", obscureText: false),

             const SizedBox(height: 10,),

             //password
             MyTextField(controller: passwordTextController, hintText: "Password", obscureText: true),

             const SizedBox(height: 10,),

             //sign in button
             MyButton(onTap: signIn, text: 'Sign In',),

             const SizedBox(height: 25,),

             //go to register page
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Not a member?", style: TextStyle(color: Colors.grey[700]),),
                 const SizedBox(width: 4,),

                 GestureDetector(
                     onTap: widget.onTap,
                     child: const Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue,),))
               ],
             )
           ],
         ),
       ),],),


    );
  }
}
