
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/ui/pages/home/widgets/edit_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class MyBooks extends StatefulWidget {
  const MyBooks({Key key}) : super(key: key);

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  LibraryRespoitory _books = LibraryRespoitory();
  var defaultImage =
      "https://images.pexels.com/photos/2852438/pexels-photo-2852438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _books.getMyBooks(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return _buildListView(
                size, snapshot.data.docs, snapshot.data.docChanges);
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error);
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  /// [Widget] of Page [UI]
  Widget _buildListView(
      size, List<QueryDocumentSnapshot> docs, List<DocumentChange> docChanges) {
    if (docs.length > 0) {
      return ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          List image = [];
          image.addAll(( docs[index].data() as Map)["image"]);
          if(image.length==0)image.add(defaultImage);
          return Dismissible(
            key: Key(index.toString()),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                _books.delBook(docChanges[index].doc.id);
              } else if (direction == DismissDirection.startToEnd) {
                _books.delBook(docChanges[index].doc.id);
              } else {
                _books.delBook(docChanges[index].doc.id);
              }
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(" ${(docs[index].data() as Map )['title']}"),
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                 image: DecorationImage(
                   fit: BoxFit.cover,
                    image: NetworkImage(
                        image.first
                    ),
                 ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _buildEditButton(context, docChanges[index].doc.id,(docs[index].data() as Map)["title"]);
                },
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text("Not Found"),
      );
    }
  }

  Widget _buildError(error) {
    return Center(
      child: Text("$error"),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.teal,
      ),
    );
  }

  _buildEditButton(BuildContext context, String id, data) {
    RouterC.of(context).push(EditBookPage(uuid: id,title: data,));
  }
}
