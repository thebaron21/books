import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouterC {
  BuildContext context;
  RouterC(this.context);

  factory RouterC.of(context) => RouterC(context);

  push(page) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));

  pushBack(page) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));

  message(title, content) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
        ),
        
      );
}
