import 'package:books/main.dart';
import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/box_hive.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/authentication.dart';
import 'package:books/src/ui/pages/auth/auth_page.dart';
import 'package:books/src/ui/pages/theme/dark.dart';
import 'package:books/src/ui/widgets/drawer_widget.dart';
import 'package:books/src/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<DrawerModel> _list(context) => [
        DrawerModel(
          Icon(Icons.theater_comedy),
          AppLocale.of(context).getTranslated("theme"),
          () {
            RouterC.of(context).push(DarkPage());
            // ThemeData.dark();
            // Theme.of(context).buttonTheme.
          },
        ),
        DrawerModel(
          Icon(Icons.language),
          AppLocale.of(context).getTranslated("lang"),
          () async {
            String lang = Hive.box(BoxHive.APP).get("lang");
            if (lang == null) {
              await Hive.box(BoxHive.APP).put("lang", "ar");
              RouterC.of(context).pushBack(MyApp(
                lang: "ar",
              ));
            } else {
              if (lang == "ar") {
                await Hive.box(BoxHive.APP).put("lang", "en");
                RouterC.of(context).pushBack(MyApp(
                  lang: "en",
                ));
              } else {
                await Hive.box(BoxHive.APP).put("lang", "ar");
                RouterC.of(context).pushBack(MyApp(
                  lang: "ar",
                ));
              }
            }
          },
        ),
        DrawerModel(
          Icon(Icons.exit_to_app),
          AppLocale.of(context).getTranslated("logout"),
          () {
            AuthenticationRepository().signOut();
            RouterC.of(context).push(LoginPage());
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerC(context).drawer,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text("كتابك الجامعي" // "Ketabk",
            ),
        actions: [
          IconButton(
            onPressed: () {
              // RouterC.of(context).push(SearchPage());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * .3,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/book.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: size.height * .5,
            child: ListView.separated(
              separatorBuilder: (context, i) => Divider(),
              itemCount: _list(context).length,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: _list(context)[i].onTap,
                  child: ListTile(
                    title: Text(_list(context)[i].title),
                    leading: _list(context)[i].icon,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
