import 'package:books/src/config/route.dart';
import 'package:flutter/material.dart';

import 'new_post_page.dart';
import 'widgets/posts_widget.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon:Icon(Icons.add),
            onPressed: (){
              RouterC.of(context).push(NewPostPage());
            },
          )
        ],
      ),
body: Column(
  children: [
Container(
padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200),
          padding: EdgeInsets.all(16),
          child: Text("hjkhkl", style: TextStyle(fontSize: 15),),
        ),
      ),
    )
  ],
),
//      body: PostWidget.futureBuilder()
    );
  }
}