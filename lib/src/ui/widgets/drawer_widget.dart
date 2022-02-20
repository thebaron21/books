import 'package:books/main.dart';
import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/box_hive.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/authentication.dart';
import 'package:books/src/logic/firebase/profile_user.dart';
import 'package:books/src/ui/pages/auth/auth_page.dart';
import 'package:books/src/ui/pages/favorite_books.dart';
import 'package:books/src/ui/pages/info/about_us.dart';
import 'package:books/src/ui/pages/info/disclamier.dart';
import 'package:books/src/ui/pages/message/posts_page.dart';
import 'package:books/src/ui/pages/message/rooms_page.dart';
import 'package:books/src/ui/pages/setting_page.dart';
import 'package:books/src/ui/pages/theme/dark.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class DrawerC {
  BuildContext _context;
  DrawerC(this._context);

  /// [Data] of [List]
  List<DrawerModel> _list(context) => [
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
          AppLocale.of(context).getTranslated("support"),
          () {
            RouterC.of(context).push(PostPage());
          },
        ),
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
          AppLocale.of(context).getTranslated("favorite"),
          () {
            RouterC.of(context).push(FavoritePage());
          },
        ),
        DrawerModel(
          Icon(Icons.directions_walk_rounded),
          AppLocale.of(context).getTranslated("chat"),
          () async {
            RouterC.of(context).push(ChatRoom());
          },
        ),
        DrawerModel(
          Icon(Icons.settings),
          AppLocale.of(context).getTranslated("settings"),
          () {
            RouterC.of(context).push(SettingPage());
          },
        ),
        DrawerModel(
          Icon(Icons.settings),
          AppLocale.of(context).getTranslated("disclaimer"),
          () {
            RouterC.of(context).push(DisclaimerPage());
          },
        ),
        DrawerModel(
          Icon(Icons.settings),
          AppLocale.of(context).getTranslated("who_are_we"),
          () {
            RouterC.of(context).push(AboutUsPage());
          },
        ),
      ];

  factory DrawerC.of(context) {
    return DrawerC(context);
  }
  String imageDefault =
      "https://firebasestorage.googleapis.com/v0/b/projcetchat.appspot.com/o/users%2Fimage_picker1912503907955706476.jpg?alt=media&token=9921a534-d871-4f5d-8fce-3a25179678c7";
  _drawer() {
    UserProfile obj = UserProfile();
    User user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 30),
          FutureBuilder(
            future: obj.getProfile(uuid: user.uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> s) {
              if (s.hasData) {
                Map userInfo = s.data.docs[0].data();
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          var file = await obj.openGallery();
                          var uri = await obj.uploadToStorage(fileImage: file);
                          print("URi : $uri");
                          await obj.updateImage(url: uri, uuid: user.uid);
                          var data = await obj.getProfile(uuid: user.uid);
                          print(data.docs.first.data());
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userInfo["image"] ?? imageDefault),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        userInfo["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _list(this._context).length,
            itemBuilder: (BuildContext context, int index) {
              DrawerModel model = _list(this._context)[index];
              return InkWell(
                onTap: model.onTap,
                child: ListTile(
                  title: Text(
                    model.title,
                    style: GoogleFonts.tajawal(),
                  ),
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
