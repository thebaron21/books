import 'package:books/src/logic/firebase/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'one_edit_book.dart';

class EditBookPage extends StatefulWidget {
  final String uuid;
  final String title;
  const EditBookPage({Key key, @required this.uuid, @required this.title}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  LibraryRespoitory _books = LibraryRespoitory();
  var defaultImage =
      "https://images.pexels.com/photos/2852438/pexels-photo-2852438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF333333)),
        title: Text(widget.title, style: TextStyle(color: Color(0xFF333333))),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _books.getBook(widget.uuid),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasData) {
            return Center(child: _buildEditWidget(snapshot.data.data()));
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error);
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _buildError(error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEditWidget(data) {
    List image = [];
    image.addAll(data["image"]);
    if(image.length==0)image.add(defaultImage);

    return OneBookEdit(
      image: image.first,
      title: data["title"],
      desc: data["description"],
      location: data["location"],
      phoneNumber: data["phoneNumber"],
      uid: widget.uuid,
    );
  }

  bool isLoading = false;
}
