import 'package:books/src/logic/firebase/categories_bloc.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/ui/widgets/widget_card_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Books extends StatefulWidget {
  final String category;
  const Books({Key key, this.category}) : super(key: key);

  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {
  LibraryRespoitory _books = LibraryRespoitory();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ketabk"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _books.getBooks(category: widget.category),
        // ignore: missing_return
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return _buildListView(size, snapshot.data.docs);
          } else if (snapshot.hasError) {
            return _buildWidgetError(snapshot.error);
          } else {
            return _buildLoading(size);
          }
        },
      ),
    );
  }

  _buildListView(
    size,
    List<QueryDocumentSnapshot> docs,
  ) {
    if (docs.length > 0) {
      return ListView.builder(
        itemCount: docs.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          BookModel book = BookModel.withJson(docs[index].data());
          return WidgetCardBook(
            book: book,
          );
        },
      );
    } else {
      return Center(
        child: Text("Not Books"),
      );
    }
  }

  Widget _buildLoading(Size size) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildWidgetError(error) {
    return Center(
      child: Text("$error"),
    );
  }

  CategoriesFirebase bloc = CategoriesFirebase();
  String value = "الإعلام واللغات والعلاقات العامة";

  dropdown() {
    return StreamBuilder(
      stream: bloc.fetchCategories().asStream(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return DropdownButton(
            onChanged: (va) => setState(() => value = va),
            value: value,
            items: snapshot.data.docs
                .map(
                  (e) => DropdownMenuItem(
                    value: (e.data() as Map)['name'],
                    child: Text((e.data() as Map)['name']),
                  ),
                )
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
