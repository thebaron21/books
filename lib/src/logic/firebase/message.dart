import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _data = _firestore.collection("rooms");
final categories = _firestore.collection("rooms").snapshots();

class MessageFirebase {
  Future<QuerySnapshot> fetchRoom({String userId}) async {
    var data = _data
        // .where("receivder", isEqualTo: userId)
        .where("userSender", isEqualTo: userId)
        .get();
    return data;
  }

  Future<bool> setMessage(
      {@required String userId,@required String reciveId,@required String message,@required String email}) async {
    try {
      await _data.add({
        "receivder": reciveId,
        "userSender": userId,
        "message": message,
        "email": email,
      });
      return true;
    } catch (e) {
      throw e;
    }
  }
}
