import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const WallPost({super.key, required this.message, required this.user, required this.postId, required this.likes});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  Future<void> toggleLike() async {
    setState(() {
      isLiked =  !isLiked;
    });

    //Access the document in firestore
    DocumentReference postRef = FirebaseFirestore.instance.collection('UserPost').doc(widget.postId);

    if(isLiked){
      //if the post is now liked, add user email to the 'Likes' field
     postRef.update(
        {
          'Likes': FieldValue.arrayUnion([currentUser.email])
        }
      );
    }

    else{
      //if the post is now unliked, remove the user email from the 'Likes' field
      postRef.update(
          {
            'Likes': FieldValue.arrayRemove([currentUser.email])
          }
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
            borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          //profile picture
          Column(
            children: [
              //like button
                LikeButton(isLiked: isLiked, onTap: toggleLike),

              const SizedBox(height: 5,),

              //like count
              Text(widget.likes.length.toString(),
              style: TextStyle(
                color: Colors.grey,
              ),),
            ],
          ),

          const SizedBox(width: 20,),

          //message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user,style: TextStyle(color: Colors.grey[500]),),
              const SizedBox(height: 10,),
              Text(widget.message),
            ],
          )
        ],
      ),
    );
  }
}
