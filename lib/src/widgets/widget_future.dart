import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetFuture {
  static Widget loading() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.teal,
      ),
    );
  }

  static Widget error(error) {
    return Center(
      child: Text(error.toString()),
    );
  }
}
