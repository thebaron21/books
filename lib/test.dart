import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter/material.dart';
import 'package:facebook_login/facebook_login.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: ()async{
// Create an instance of FacebookLogin
              FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              var fb = FacebookLogin.instance;
              var daa = await fb.login();
              print( daa.userId );

            },
            child: Text("Click Me!"),
          )
        ],
      ),
    );
  }
}
