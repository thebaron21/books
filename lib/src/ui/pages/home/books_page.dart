import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/categories_bloc.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/ui/pages/message/message_page.dart';
import 'package:books/src/ui/widgets/widget_card_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Books extends StatefulWidget {
  final String type;
  const Books({Key key, this.type}) : super(key: key);

  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {
  LibraryRespoitory _books = LibraryRespoitory();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _books.getBookOfType(type: widget.type),
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
          return CarTile(book: book);
          // return WidgetCardBook(
          //   book: book,
          // );
        },
      );
    } else {
      return Center(
        child: Text("Not Found"),
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

  @mustCallSuper
  dropdown() {
    return StreamBuilder(
      stream: bloc.fetchCategories().asStream(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return DropdownButton(
            style: GoogleFonts.tajawal(),
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

class CarTile extends StatelessWidget {
  final BookModel book;
  CarTile({Key key, this.book}) : super(key: key);
  var defaultImage =
      "https://images.pexels.com/photos/2852438/pexels-photo-2852438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.95,
      height: size.height * 0.25,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _imageBook(book.image, size),
          Expanded(
            child: _info(book, size, context),
          ),
        ],
      ),
    );
  }

  _imageBook(List image, Size size) {
    if (image.length == 0) image.add(defaultImage);
    return Container(
      width: size.width * 0.5,
      // height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Color(0Xff222222).withOpacity(0.1),
            blurRadius: 10,
          )
        ],
        image: DecorationImage(
          image: NetworkImage(image.first),
          fit: BoxFit.cover,
        ),
      ),
    );
    // return ListView.builder(
    //   itemCount: image.length,
    //   physics: ScrollPhysics(),
    //   shrinkWrap: true,
    //   scrollDirection: Axis.horizontal,
    //   itemBuilder: (context, i) {
    //     return
    //   },
    // );
  }

  Widget _info(BookModel book, Size size, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _favorite(book, size),
        _title(book.title),
        Expanded(
          child: _descrption(book.description, size),
        ),
        _btnChat(size, book, context: context, user: user)
      ],
    );
  }

  Widget _favorite(BookModel book, Size size) {
    return IconButton(
      icon: ValueListenableBuilder(
        valueListenable: Hive.box("favorite").listenable(),
        builder: (BuildContext context, Box value, Widget child) {
          bool isFavorite = false;
          value.values.toList().forEach((element) {
            if (element["title"] == book.title) {
              isFavorite = true;
            }
          });
          return isFavorite == true
              ? Icon(
                  Icons.favorite,
                  color: Colors.pink,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Colors.pink,
                );
        },
      ),
      onPressed: () async {
        bool isFavorite = false;
        int index;
        var i = Hive.box("favorite");
        i.toMap().forEach((key, value) {
          if (value["title"] == book.title) {
            print("True");
            isFavorite = true;
            index = key;
          }
        });

        if (isFavorite == false)
          i.add(book.toMap());
        else
          i.delete(index);
      },
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        color: Color(0xFF888888),
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _descrption(String description, Size size) {
    String desc = "";
    return Text(
      description,
      style: TextStyle(
        fontSize: 13,
        color: Color(0xFF000000),
        fontWeight: FontWeight.w300,
      ),
    );
  }

  _btnChat(Size size, BookModel book,
      {@required BuildContext context, @required User user}) {
    return book.userId != user.uid
        ? Align(
            alignment: Alignment.bottomLeft,
            child: OutlineButton(
              borderSide: BorderSide(color: Colors.teal),
              textColor: Colors.teal,
              onPressed: () {
                RouterC.of(context).push(
                  MessagePage(
                    userId: book.userId,
                    book: book.title,
                  ),
                );
              },
              child: Text(AppLocale.of(context).getTranslated("chat")),
            ),
          )
        : Center();
  }
}
