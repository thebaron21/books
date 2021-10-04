import 'package:flutter/material.dart';

class DarkThemePage extends StatefulWidget {
  @override
  _DarkThemePageState createState() => _DarkThemePageState();
}

class _DarkThemePageState extends State<DarkThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base Screen'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Material.of(context).color.red;
            },
            icon: Icon(
              Icons.brightness_5,
            ),
          ),
          Center(
            child: Text(
              'Text color will change with the theme',
            ),
          )
        ],
      ),
    );
  }
}
