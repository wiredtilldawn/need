import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need/components/text_box.dart';
import 'package:provider/provider.dart';

import '../helper/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key,});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async{
      String newValue = "";
      await showDialog(context: context, builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Edit $field", style: TextStyle(color: Colors.white),),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey)
          ),

          onChanged: (value) {
            newValue = value;
          },
        ),

        actions: [
          TextButton(child: Text('Cancel',style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.pop(context),),

          TextButton(child: Text('Save',style: TextStyle(color: Colors.white),),
            onPressed: () => Navigator.of(context).pop(newValue),),
        ],
      ),);

      if(newValue.trim().length > 0)
        {
          await usersCollection.doc(currentUser.email).update({field: newValue});
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Profile Page",),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],

      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50,),

                //profile picture
                const Icon(Icons.person, size: 72,),

                const SizedBox(height: 10,),

                //user email
                Text(currentUser.email!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700]),),

                const SizedBox(height: 50,),

                //user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text("My Details", style: TextStyle(color: Colors.grey[600]),),
                ),

                //user name
                MyTextBox(text: userData["username"], sectionName: 'Username', onPressed: () => editField('username'),),

                //bio
                MyTextBox(text: userData["bio"], sectionName: 'bio', onPressed: () => editField('bio'),),

                const SizedBox(height: 20,),

                //user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text("My Posts", style: TextStyle(color: Colors.grey[600]),),
                ),
              ],
            );
          }
          else if(snapshot.hasError){
              return Center(child: Text('Error${snapshot.error}'),);
          }
          return const Center(child: CircularProgressIndicator(),);
        },),

    );
  }
}
