import 'package:books/main.dart';
import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/box_hive.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/authentication.dart';
import 'package:books/src/ui/pages/auth/login_page.dart';
import 'package:books/src/ui/pages/message/posts_page.dart';
import 'package:books/src/ui/pages/message/rooms_page.dart';
import 'package:books/src/ui/pages/theme_page.dart';
import 'package:books/test.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DrawerC {
  BuildContext _context;
  DrawerC(this._context);

  /// [Data] of [List]
  List<DrawerModel> _list(context) => [
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
           AppLocale.of(context).getTranslated("theme"),
          () {
            RouterC.of(context).push(DarkThemePage());
            // ThemeData.dark();
            // Theme.of(context).buttonTheme.
          },
        ),
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
          AppLocale.of(context).getTranslated("lang"),
          () async {
            String lang = Hive.box(BoxHive.APP).get("lang");
            if (lang == null) {
              await Hive.box(BoxHive.APP).put("lang", "ar");
              RouterC.of(context).pushBack(MyApp(lang: "ar",));
            } else {
              if (lang == "ar") {
                await Hive.box(BoxHive.APP).put("lang", "en");
                RouterC.of(context).pushBack(MyApp(lang: "en",));
              } else {
                await Hive.box(BoxHive.APP).put("lang", "ar");
                RouterC.of(context).pushBack(MyApp(lang: "ar",));
              }
            }
          },
        ),
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
           AppLocale.of(context).getTranslated("posts"),
          () {
            RouterC.of(context).push(PostPage());
            // ThemeData.dark();
            // Theme.of(context).buttonTheme.
          },
        ),
    //
    DrawerModel(
      Icon(Icons.directions_walk_rounded),
      "TestView",
          () {
        RouterC.of(context).push(TestView());
        // ThemeData.dark();
        // Theme.of(context).buttonTheme.
      },
    ),
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
           AppLocale.of(context).getTranslated("chat"),
          () {
            RouterC.of(context).push(ChatRoom());
            // ThemeData.dark();
            // Theme.of(context).buttonTheme.
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
        // DrawerModel(Icon(Icons.profile), title, onTap)
      ];

  factory DrawerC.of(context) {
    return DrawerC(context);
  }

  _drawer() {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 30),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _list(this._context).length,
            itemBuilder: (BuildContext context, int index) {
              DrawerModel model = _list(this._context)[index];
              return InkWell(
                onTap: model.onTap,
                child: ListTile(
                  title: Text(model.title),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget get drawer => _drawer();
}

class DrawerModel {
  final Icon icon;
  final String title;
  final Function onTap;

  DrawerModel(this.icon, this.title, this.onTap);
}

/*
{
Logout
Chat
Posts
Theme
 
}

*/