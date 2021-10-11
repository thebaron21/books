import 'package:books/src/logic/models/post_model.dart';
import 'package:books/src/logic/responses/post_login.dart';
import 'package:books/src/widgets/widget_future.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostWidget {
  static User _user = FirebaseAuth.instance.currentUser;
  static Widget desginTextField(
      Size size, TextEditingController con, String s, bool isBig) {
    return Container(
      width: size.width * 0.9,
      height: isBig == false ? size.height * 0.07 : size.height * 0.2,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: con,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: s,
        ),
      ),
    );
  }

  static Widget uploadImage(Size size, {@required Function onTap}) {
    return Tooltip(
      message: 'Upload Image',
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.withOpacity(0.4),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  static Widget futureBuilder() => StreamBuilder(
        stream: PostLogic().getPosts().asStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.hasData) {
            var posts = PostRepository.fromMap(snapshot.data);
            return list(posts.posts);
          } else if (snapshot.hasError) {
            return WidgetFuture.error(snapshot.error);
          } else {
            return WidgetFuture.loading();
          }
        },
      );

  static Widget newPost(
          {@required Size size,
          @required Function onTap,
          @required bool busy}) =>
      InkWell(
        onTap: onTap(),
        child: Container(
          width: busy == false ? size.width * 0.8 : size.width * 0.3,
          height: 48,
          margin: EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: busy == false
              ? Text(
                  "Post",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              : CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
      );

  static Widget list(List<PostModel> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return cardPost(posts[index]);
      },
    );
  }

  static Widget cardPost(PostModel post) {
    print( post.toMap() );
    return Container(
      padding:EdgeInsets.symmetric( vertical: 30 , horizontal: 10 ),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: _user.uid == post.userId ? Colors.blue.withOpacity(0.4) : Colors.lightBlueAccent,
          borderRadius: _user.uid == post.userId ? BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
            bottomRight: Radius.circular(7),
          ) : BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
            bottomLeft: Radius.circular(7),
          )
      ),
      child: Text(post.content),
    );
  }
}
