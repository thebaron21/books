// FavoritePage
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/ui/widgets/widget_card_book.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({@required Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المفضلة",
          style: GoogleFonts.tajawal(),
        ),
      ),
      body: WatchBoxBuilder(
        box: Hive.box("favorite"),
        builder: (context, watch) {
          return ListView.builder(
            itemCount: watch.length,
            itemBuilder: (context, int i) {
              return WidgetCardBook(
                book: BookModel.withJson(watch.values.toList()[i]),
              );
            },
          );
        },
      ),
    );
  }
}
