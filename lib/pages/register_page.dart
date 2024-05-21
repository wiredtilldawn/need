import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void signUp() async{
    //show loading circle
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),
    ),
    );

    //password match
    if(passwordTextController.text!=confirmPasswordTextController.text){
      //pop loading circle
      Navigator.pop(context);
      //show error message to user
      displayMessage("Passwords do not match!");
      return;
    }

    //try creating the user
    try {
      //create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);

      //after creating the user, create a new doc in firebase "Users"
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set(
          {
            'username' : emailTextController.text.split("@")[0], //initial username
            'bio' : 'empty bio'//initial empty bio
          });

      if(context.mounted)
        Navigator.pop(context);
    }

    on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);

      //show error to user
      displayMessage(e.code);
    }

  }

  //try creating the user


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
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Positioned.fill(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),

              //logo
              const Icon(Icons.lock,size: 100,),

              const SizedBox(height: 50,),

              //welcome back
              Center(child: Text("Let's create an account for you",  style: TextStyle(color: Colors.grey[700]),)),

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
              MyButton(onTap: signUp, text: 'Sign Up',),

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
            ],
      ),


    );
  }
}
