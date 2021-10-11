import 'package:books/src/ui/pages/home/search_page.dart';
import 'package:flutter/material.dart';
import 'config/LocaleLang.dart';
import 'config/home_logic.dart';
import 'config/route.dart';
import 'ui/pages/home/categories_page.dart';
import 'ui/pages/home/my_books.dart';
import 'ui/pages/home/new_book.dart';
import 'ui/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ControllerBookApp navigator = ControllerBookApp();
  int indexItem = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerC(context).drawer,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Ketabk",
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
      body: StreamBuilder<HOMENAV>(
        stream: navigator.getControllerBookApp,
        initialData: HOMENAV.HOME,
        // ignore: missing_return
        builder: (context, snapshot) {
          // ignore: missing_enum_constant_in_switch
          switch (snapshot.data) {
            case HOMENAV.HOME:
              return CategoriesPage();
            case HOMENAV.EDIT:
              return NewBook();
            case HOMENAV.MYBOOK:
              return MyBooks();
            default:
              return Center();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              navigator.setControllerBookApp.add(HOMENAV.EDIT);
              setState(() => indexItem = 0);
              break;
            case 1:
              navigator.setControllerBookApp.add(HOMENAV.HOME);
              setState(() => indexItem = 1);
              break;
            case 2:
              navigator.setControllerBookApp.add(HOMENAV.MYBOOK);
              setState(() => indexItem = 2);
              break;
          }
        },
        currentIndex: indexItem,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            // ignore: deprecated_member_use
            title: Text(AppLocale.of(context).getTranslated("new_book"),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            // ignore: deprecated_member_use
            title: Text(AppLocale.of(context).getTranslated("home"),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            // ignore: deprecated_member_use
            title: Text(AppLocale.of(context).getTranslated("my_books"),),
          ),
        ],
      ),
    );
  }
}