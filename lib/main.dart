import 'package:books/src/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/config/LocaleLang.dart';
import 'src/config/box_hive.dart';
import 'src/ui/pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(BoxHive.APP);
  await Hive.box(BoxHive.APP).put("lang", "ar");
  String lang = Hive.box(BoxHive.APP).get("lang");
  runApp(MyApp(lang: lang));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  final String lang;

  const MyApp({Key key, this.lang}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseAuth auth = FirebaseAuth.instance;

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocale.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: Locale(widget.lang, ''),
        supportedLocales: [
          Locale('ar', ''),
          Locale('en', ''),
        ],
        localeResolutionCallback: (currentLocale, supporedLocales) {
          if (currentLocale != null) {
            for (Locale locale in supporedLocales) {
              if (currentLocale.languageCode == locale.languageCode) {
                return currentLocale;
              }
            }
          }
          return supporedLocales.first;
        },
        title: 'ketabk',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user != null ? HomePage() : LoginPage());
  }
}
