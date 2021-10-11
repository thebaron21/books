import 'package:books/src/home.dart';
import 'package:books/src/ui/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'src/ui/pages/theme/theme_provider.dart';
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

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;

  print(isLightTheme);
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(isLightTheme: isLightTheme),
    child: MyApp(lang: lang),
  ));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  final String lang;
  final ThemeProvider themeProvider;

  const MyApp({Key key, this.lang, this.themeProvider}) : super(key: key);
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
      locale: Locale(widget.lang, ''),
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
      title: 'ketabk',
      // ignore: unnecessary_null_comparison
      home: LandingPage()
      // home: user != null ? HomePage() : LoginPage(),
    );
  }
}
