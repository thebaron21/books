
import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/ui/pages/home/search_page.dart';
import 'package:books/src/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({ Key key }) : super(key: key);

  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerC(context).drawer,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
            AppLocale.of(context).getTranslated("disclaimer"), // "Ketabk",
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