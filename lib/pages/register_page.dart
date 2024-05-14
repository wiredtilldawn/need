import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(Icons.lock,size: 100,),

                const SizedBox(height: 50,),

                //welcome back
                Text("Let's create an account for you",  style: TextStyle(color: Colors.grey[700]),),

                const SizedBox(height: 25,),

                //email
                MyTextField(controller: emailTextController, hintText: "Email", obscureText: false),

                const SizedBox(height: 10,),

                //password
                MyTextField(controller: passwordTextController, hintText: "Password", obscureText: true),

                const SizedBox(height: 10,),

                MyTextField(controller: confirmPasswordTextController, hintText: "Confirm Password", obscureText: true),

                const SizedBox(height: 10,),

                //sign in button
                MyButton(onTap: (){}, text: 'Sign Up',),

                const SizedBox(height: 25,),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.grey[700]),),
                    const SizedBox(width: 4,),

                    GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Login here", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue,),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),


    );
  }
}
