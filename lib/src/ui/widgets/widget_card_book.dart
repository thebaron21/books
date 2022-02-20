import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/ui/pages/message/message_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WidgetCardBook extends StatefulWidget {
  final BookModel book;

  WidgetCardBook({Key key, this.book}) : super(key: key);

  @override
  State<WidgetCardBook> createState() => _WidgetCardBookState();
}

class _WidgetCardBookState extends State<WidgetCardBook> {
  User user = FirebaseAuth.instance.currentUser;

  var defaultImage =
      "https://images.pexels.com/photos/2852438/pexels-photo-2852438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: SizedBox(
        height: size.height * 0.3,
        child: Card(
          elevation: 2.0,
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  // icon: Icon( Icons.favorite ),
                  icon: ValueListenableBuilder(
                    valueListenable: Hive.box("favorite").listenable(),
                    builder: (BuildContext context, Box value, Widget child) {
                      bool isFavorite = false;
                      value.values.toList().forEach((element) {
                        if (element["title"] == widget.book.title) {
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
                      if (value["title"] == widget.book.title) {
                        print("True");
                        isFavorite = true;
                        index = key;
                      }
                    });

                    if (isFavorite == false)
                      i.add(widget.book.toMap());
                    else
                      i.delete(index);
                  },
                ),
              ),
              Container(
                color: Colors.green,
                width: size.width * 0.95,
                height: size.height * 0.121,
                child: card(widget.book.image, size),
              ),
              Container(
                alignment: Alignment.center,
                width: size.width * 0.8,
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.book.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(height: 2),
                        Text(
                          widget.book.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        country(widget.book.location),
                        widget.book.userId != user.uid
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.teal,
                                  ),
                                  onPressed: () {
                                    RouterC.of(context).push(MessagePage(
                                        userId: widget.book.userId,
                                        book: widget.book.title));
                                  },
                                  child: Text(AppLocale.of(context)
                                      .getTranslated("chat")),
                                ),
                              )
                            : Center()
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// {@tool snippet}
  /// The [Align] widget in this example uses one of the defined constants from
  /// [Alignment], [Alignment.topRight]. This places the [FlutterLogo] in the top
  /// right corner of the parent blue [Container].
  ///
  Widget country(String country) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Text(
        country,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget card(List image, size) {
    if (image.length == 0) image.add(defaultImage);
    return ListView.builder(
        itemCount: image.length,
        physics: ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Container(
            // height: s,
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0Xff222222).withOpacity(0.1),
                  blurRadius: 10,
                )
              ],
              image: DecorationImage(
                image: NetworkImage(image[i]),
                fit: BoxFit.cover,
              ),
            ),
          );
        });
  }
}
