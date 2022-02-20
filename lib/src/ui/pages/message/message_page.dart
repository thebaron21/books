import 'package:books/src/logic/firebase/messages.dart';
import 'package:books/src/logic/firebase/profile_user.dart';
import 'package:books/src/logic/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  final String userId;
  final String book;
  const MessagePage({Key key, this.userId, this.book}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessagesFirebaseRealTime _messageFirebase = MessagesFirebaseRealTime();
  User user = FirebaseAuth.instance.currentUser;
  TextEditingController _message = TextEditingController();

  @override
  dispose() {
    super.dispose();
    _message.clear();
    _message.dispose();
  }

  UserProfile obj = UserProfile();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: obj.getProfile(uuid: widget.userId),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _messageFirebase.getConversation(
                  userId: user.uid, peerId: widget.userId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object>> snapshot) {
                if (snapshot.hasData) {
                  List list = (snapshot.data.docs.reversed.toList());
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      MessageModel message =
                          MessageModel.toObject(list[index].data());
                      return _chatBubble(
                          message, user.uid == message.idForm, false);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Not Chat"),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.12)
          ],
        ),
      ),
      bottomSheet: Container(
        height: 60,
        width: size.width,
        child: Row(
          children: [
            SizedBox(width: 5),
            button(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                print(user.uid);
                print(widget.userId);
                var data = await _messageFirebase.setMessage(
                    message: MessageModel(user.uid, widget.userId, false,
                        Timestamp.now(), _message.text));
                print(data);
                _message.clear();
                setState(() {});
              },
            ),
            SizedBox(width: 5),
            Container(
              width: size.width * .85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                maxLines: 10,
                controller: _message,
                decoration: InputDecoration(
                  hintText: "Message ...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _chatBubble(MessageModel message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.content,
              ),
            ),
          ),
          Text(
            message.date.toDate().toString(),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            message.date.toDate().toString(),
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      );
    }
  }

  button({Icon icon, Function onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal,
          ),
          child: icon),
    );
  }
}
