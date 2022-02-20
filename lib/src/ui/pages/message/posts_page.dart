import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/models/post_model.dart';
import 'package:books/src/logic/responses/post_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'new_post_page.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryTextTheme.subtitle1.color,
        child: Icon( Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: (){
          RouterC.of(context).push(NewPostPage());
        },
      ),
      appBar: AppBar(
        title: Text(
            AppLocale.of(context).getTranslated("support")
        ),
      ),
      body: StreamBuilder(
        stream: PostLogic().getPosts().asStream(),
        builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot){
          if(snapshot.hasData){
            var posts = PostRepository.fromMap(snapshot.data);
            return ListView.builder(
              itemCount: posts.posts.length,
              itemBuilder: (context,int index){
                PostModel post = posts.posts[index];
                return CardPost(
                  post: post,
                );
              }
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text( snapshot.error.toString() ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
      ),
    );
  }
}

class CardPost extends StatelessWidget {
 final PostModel post;
  const CardPost({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color:Theme.of(context).colorScheme.primary,
          width: 5,          
        )
      ),
      child: Column(
        children: [
          Container(
            width: size.width * 0.95,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    post.imageURL ?? ""
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title ?? "Title Empty",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            post.content ?? "Content Empty",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (post.date).toDate().toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
