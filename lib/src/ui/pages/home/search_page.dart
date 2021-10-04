import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBar searchBar;
  String name;
  LibraryRespoitory obj = LibraryRespoitory();
  var defaultImage =
      "https://lh3.googleusercontent.com/proxy/jt8E8QcIWeRXUxY6X159gyM13jpvrZIULA3xfWH_n06U3tSG1feUCP0wHs0qZ9gDMoR71-QRD4TvRyVD-xnyhDlHd_HE";

  _SearchPageState() {
    searchBar = SearchBar(
      setState: setState,
      inBar: false,
      onChanged: (value) {
        setState(() => name = value);
      },
      onSubmitted: (value) {
        setState(() => name = null);
      },
      onCleared: () {
        setState(() => name = null);
      },
      onClosed: () {
        setState(() => name = null);
      },
      buildDefaultAppBar: buildAppBar,
    );
  }
  AppBar buildAppBar(context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.teal,
      title: Text(
        "Ketabk",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: StreamBuilder(
        stream: obj.searchBook(name).asStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object>> snapshot) {
          if (snapshot.hasData) {
            return ListBook(snapshot.data.docs);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ListBook(List<QueryDocumentSnapshot<Object>> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (BuildContext context, int index) {
        BookModel book = BookModel.withJson(docs[index].data());
        return ListTile(
          trailing: Text(book.price == 0 ? "Free" : "\$${book.price}"),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              book.image.length <= 0 ? defaultImage : book.image[0],
            ),
          ),
          title: Text(book.title),
          subtitle: Text(book.description),
        );
      },
    );
  }
}
