import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_page.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  MessageFirebase _messageFirebase = MessageFirebase();
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        actions: [
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () async {
               await _messageFirebase.setMessage(
                email: user.email,
                message: "Hello I'am Ahmed Khalil",
                reciveId: "wmHuRbB2iVfNoAftExc1cLLTVbn1",
                userId: user.uid,
              );
            },
            child: Text("Click Me!"),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _messageFirebase.fetchRoom(userId: user.uid).asStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    RouterC.of(context).push(MessagePage(
                      receveId: (snapshot.data.docs[index].data()
                          as Map)["receivder"],
                    ));
                  },
                  child: ListTile(
                    title: Text("fahme"),
                    leading: CircleAvatar(),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
