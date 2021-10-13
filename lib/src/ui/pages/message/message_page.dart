import 'package:books/src/logic/models/model_message.dart';
import 'package:books/src/logic/firebase/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  final String receiveId;
  final String book;
  const MessagePage({Key key, this.receiveId, this.book}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessageFirebase _messageFirebase = MessageFirebase();
  User user = FirebaseAuth.instance.currentUser;
  TextEditingController _message = TextEditingController();

  @override
  dispose(){
    super.dispose();
    _message.clear();
    _message.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: _messageFirebase.fetchChat(userId: user.uid, receiveId: widget.receiveId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object>> snapshot) {
                  if (snapshot.hasData) {
                    List list = ( snapshot.data.docs.reversed.toList() );
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        ModelMessage modelMessage = ModelMessage.fromJson(list[index].data());
                        return _chatBubble(modelMessage,modelMessage.users.senders == user.uid, false);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
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
              SizedBox(
                height:size.height*0.12
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height:60,
        width:size.width,
        child: Row(
        children: [
          SizedBox(width:5),
          button(
            icon: Icon(Icons.send, color:Colors.white),
            onPressed: ()async{
              var data = await _messageFirebase.setMessage(
                userId: user.uid,
                receiveId: widget.receiveId,
                message: _message.text,
                title: widget.book
              );
              print(data);
              _message.clear();
            },
          ),
          SizedBox(width:5),
          Container(
            width: size.width*.85,
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

  _chatBubble(ModelMessage message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
                message.message,
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
                message.message,
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
              color: Colors.black45,
            ),
          ),
        ],
      );
    }
  }

  button({Icon icon,Function onPressed}){
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        height:50,
        decoration:BoxDecoration(
          shape: BoxShape.circle,
          color:Colors.teal,
        ),
        child:icon
      ),
    );
  }
}
