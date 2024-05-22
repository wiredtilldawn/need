import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need/components/comment_button.dart';
import 'package:need/helper/helper_methods.dart';
import 'comment.dart';
import 'package:need/components/like_button.dart';
import 'delete_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({super.key, required this.message, required this.user, required this.postId, required this.likes, required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final commentTextController = TextEditingController();

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

  //add a comment
  void addComment(String commentText) {
    FirebaseFirestore.instance.collection("UserPost").doc(widget.postId).collection("Comments").add(
        {
          "CommentText": commentText,
          "CommentedBy": currentUser.email,
          "CommentTime": Timestamp.now(), //remember to format this when displaying
        });
  }

  //show dialog box for adding comment
  void showCommentDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        controller: commentTextController,
        decoration: InputDecoration(
          hintText: "Write a comment",
        ),
      ),

      actions: [
        //cancel button
        TextButton(onPressed: () { Navigator.pop(context); commentTextController.clear();}, child: Text("Cancel",  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),),

        //Post button
        TextButton(onPressed: () { addComment(commentTextController.text); Navigator.pop(context); commentTextController.clear();}, child: Text("Post",  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),),

      ],
    ),);
  }

  //delete post
  void deletePost(){
    //show a dialog box asking for confirmation
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Delete Post"),
      content: const Text("Are you sure you want to delete this post?"),
      actions: [
        //cancel button
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel",  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),),

        //delete button
          TextButton(
            onPressed: () async {
            // Implement the deletion logic here
              final commentDocs = await FirebaseFirestore.instance.collection("UserPost").doc(widget.postId).collection("Comments").get();
               for(var doc in commentDocs.docs) {
                 await FirebaseFirestore.instance.collection("UserPost").doc(widget.postId).collection("Comments").doc(doc.id).delete();
               }

               FirebaseFirestore.instance.collection("UserPost").doc(widget.postId).delete().then((value) => print("Post Deleted")).catchError((error) => print("Failed to delete post: $error"));

               Navigator.pop(context);
               },   child: Text("Delete", style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
             ),
      ],
    ),);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //need post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //group of texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //message
                  Text(widget.message),
                  const SizedBox(height: 5,),
                  //user
                  Row(
                    children: [
                      Text(widget.user, style: TextStyle(color: Colors.grey[400]),),
                      Text(" · ", style: TextStyle(color: Colors.grey[400]),),
                      Text(widget.time, style: TextStyle(color: Colors.grey[400]),),
                    ],
                  ),
                ],
              ),

              //delete button
              if(widget.user == currentUser.email)
               DeleteButton(onTap: deletePost,)

            ],
          ),

          const SizedBox(height: 20,),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //buttons
              //like
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

              const SizedBox(width: 10,),

              //comment
              Column(
                children: [
                  //comment button
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5,),

                  //comment count
                  Text("0",
                    style: TextStyle(
                      color: Colors.grey,
                    ),),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20,),

          //comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("UserPost").doc(widget.postId).collection("Comments").orderBy("CommentTime", descending: true).snapshots(),
            builder: (context, snapshot) {
              //show loading circle if no data yet
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment from firebase
                    final commentData = doc.data() as Map<String, dynamic>;

                  //return the comment
                  return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),

              );
          },)
        ],
      ),
    );
  }
}
