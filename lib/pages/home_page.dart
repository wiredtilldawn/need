import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need/components/text_field.dart';
import 'package:need/components/wall_post.dart';
import 'package:need/pages/profile_page.dart';

import '../components/drawer.dart';
import '../helper/helper_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() {
    //only post if there is something on the textfield
    if(textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("UserPost").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'Timestamp': Timestamp.now(),
        'Likes': [],
      });
    }

    //clear the textfield
    setState(() {
      textController.clear();
    });
  }

  //navigate to profile page
  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text("need",
            style: TextStyle(
          color: Colors.white,
        ),),
        iconTheme: IconThemeData(color: Colors.white,),
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
          //The need

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("UserPost").orderBy("Timestamp",descending: false).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(itemCount: snapshot.data!.docs.length,itemBuilder: (context, index) {
                          //get the message
                      final post = snapshot.data!.docs[index];
                      return WallPost(message: post['Message'], user: post['UserEmail'], postId: post.id, likes: List<String>.from(post['Likes'] ?? []),
                      time: formatDate(post['Timestamp'],));
                    },
                    );
                  }

                  else if(snapshot.hasError){
                    return Center(child: Text('Error:${snapshot.error}'),);
                  }
                  return const Center(child: CircularProgressIndicator(),);
                },

              ),
            ),

          //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                    Expanded(
                        child: MyTextField(
                        controller: textController,
                          hintText: "post a need...",
                          obscureText: false,
                    ),),

                    //post button
                  IconButton(onPressed: postMessage, icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

          //logged in as
          Text("Logged in as: " + currentUser.email!,style: TextStyle(color: Colors.grey),),

            const SizedBox(height: 50,),
          ],
        ),
      ),

    );
  }
}
