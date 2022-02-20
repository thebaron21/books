import 'package:books/src/home.dart';
import 'package:books/src/ui/landing_page.dart';
import 'package:books/src/ui/pages/auth/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'log/log_app.dart';
import 'src/ui/pages/theme/theme_provider.dart';
import 'src/config/LocaleLang.dart';
import 'src/config/box_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(BoxHive.APP);
  await Hive.openBox("favorite");
  String lang = Hive.box(BoxHive.APP).get("lang");

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? true;
  bool isInital = settings.get("inital") ?? true;
  // log(" STARING is initial $isInital", level: 1, name: "TheBaron");
  // log(" STARING is theme dark", level: 1, name: "TheBaron");

  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(isLightTheme: isLightTheme),
    child: MyApp(lang: lang, isInital: isInital),
  ));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  final String lang;
  final ThemeProvider themeProvider;
  final bool isInital;

  const MyApp({Key key, this.lang, this.themeProvider, this.isInital})
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.themeData(),
        localizationsDelegates: [
          AppLocale.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: Locale(widget.lang ?? 'ar', ''),
        supportedLocales: [
          Locale('ar', ''),
          Locale('en', ''),
        ],
        localeResolutionCallback: (currentLocale, supportedLocales) {
          if (currentLocale != null) {
            for (Locale locale in supportedLocales) {
              if (currentLocale.languageCode == locale.languageCode) {
                return currentLocale;
              }
            }
          }
          return supportedLocales.first;
        },
        title: "كتابك الجامعي",
        home: widget.isInital == true
            ? LandingPage()
            : user != null ? HomePage() : LoginPage(),
        );
  }
}
