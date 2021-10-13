import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _data = _firestore.collection("rooms");
final CollectionReference _chat = _firestore.collection("chat");
final categories = _firestore.collection("rooms").snapshots();

class MessageFirebase {

  Future<QuerySnapshot> fetchChat({String userId,String receiveId}) async {
    var data = _data
        .where("users" , arrayContainsAny:[userId,receiveId] )
        .get();
    return data;
  }

  Future<QuerySnapshot> fetchRoom({String userId})async{
        var data = _chat.where("users",arrayContains: userId )
            .get();
        return data;
  }

  Future<bool> setMessage({@required String userId,@required String receiveId,@required String message,@required String title}) async {
    try {
      await createChat(userId: userId,receive: receiveId,title:title);
      // receive
      await _data.add({
        "users" :[
          userId,
          receiveId
        ],
        "message": message,
        "date": DateTime.now(),
      });
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future createChat({String userId,String receive,String title})async{
    print(userId);
    var iss = _chat.where("users",arrayContainsAny: [userId,receive]);
    var i = await iss.get();
    if(i.docs.length == 0){
    print(i.docs.length);
      await _chat.add(
        {
          "users" :[
            userId,
            receive
          ],
          "book" : title
        }
      );
      return true;
    }
    return false;

  }
}
