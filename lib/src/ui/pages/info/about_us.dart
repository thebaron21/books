import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/ui/pages/home/search_page.dart';
import 'package:books/src/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerC(context).drawer,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocale.of(context).getTranslated("who_are_we"), // "Ketabk",
        ),
        actions: [
          IconButton(
            onPressed: () {
              RouterC.of(context).push(SearchPage());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
