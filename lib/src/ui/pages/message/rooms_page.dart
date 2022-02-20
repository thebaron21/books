import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/message.dart';
import 'package:books/src/logic/firebase/messages.dart';
import 'package:books/src/logic/firebase/profile_user.dart';
import 'package:books/src/logic/models/message_model.dart';
import 'package:books/src/logic/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_page.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  MessagesFirebaseRealTime _messageFirebase = MessagesFirebaseRealTime();
  User user = FirebaseAuth.instance.currentUser;
  String imageDefault =
      "https://firebasestorage.googleapis.com/v0/b/projcetchat.appspot.com/o/users%2Fimage_picker1912503907955706476.jpg?alt=media&token=9921a534-d871-4f5d-8fce-3a25179678c7";

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: Center(
      //   child: FlatButton(
      //     child:Text("Click Me"),
      //     onPressed: ()async{
      //       String peerId = "ru56brjSt1gJe075psNFU8kqJcv1";
      //       // String peerId = "YWYPLyIwM2aatlUc1OsmwD3p4M53";
      //       String userId = user.uid;
      //
      //       var i = await _messageFirebase.getRoom(peerID: peerId,userID: userId);
      //       // print( i.data() );
      //       // i.reference.get().then((value) => print(value.data()));
      //
      //     },
      //   ),
      // ),
      body: body(),
    );
  }

  UserProfile obj = UserProfile();

  body() {
    return StreamBuilder(
      stream: _messageFirebase.getRoom(userID: user.uid).asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              RoomModel rooms =
                  RoomModel.toObject(snapshot.data.docs[index].data());
              print(snapshot.data.docs[index].data());
              var userId = getname(rooms.users);
              //Rtzp9gikK3ZOmnHCWtdcld1hqgH3
              return InkWell(
                onTap: () {
                  String id;
                  if (rooms.users.last != user.uid)
                    id = rooms.users.last;
                  else
                    id = rooms.users.first;
                  RouterC.of(context).push(MessagePage(
                    userId: id,
                  ));
                },
                child: ListTile(
                  title: FutureBuilder(
                    future: obj.getProfile(uuid: userId),
                    builder: (context, AsyncSnapshot<QuerySnapshot> s) {
                      if (s.hasData) {
                        if (s.data.docs.length > 0) {
                          Map userInfo = s.data.docs[0].data();
                          return Text(userInfo["name"] ?? "");
                        } else {
                          return Text("مجهول");
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  leading: FutureBuilder(
                    future: obj.getProfile(uuid: userId),
                    builder: (context, AsyncSnapshot<QuerySnapshot> s) {
                      if (s.hasData) {
                        if (s.data.docs.length > 0) {
                          Map userInfo = s.data.docs[0].data();
                          return CircleAvatar(
                            backgroundImage:
                                NetworkImage(userInfo["image"] ?? imageDefault),
                          );
                        } else {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(imageDefault),
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  subtitle: Text(rooms.lastMessage),
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
    );
  }

  String getname(List users) {
    User user = FirebaseAuth.instance.currentUser;
    for (int i = 0; i < users.length; i++) {
      if (users[i] != user.uid) {
        return users[i];
      }
    }
  }
}
