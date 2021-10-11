import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostLogic {
  static final _post = FirebaseFirestore.instance.collection("posts");

  DateTime _dateTime = DateTime.now();

  setPost({@required String content, @required String title, @required String imageURL, @required String userId}) async {
    try {
      await _post.doc().set({
        "time": _dateTime,
        "title" : title,
        "content": content,
        "userId": userId,
        "image": imageURL,
      });
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<List<QueryDocumentSnapshot>> getPosts() async {
    try {
      var data = await _post.get();
      print("Post -----------------------------------------");
      print(data.docs.toList().length);
      return data.docs;
    } catch (e) {
      throw e.toString();
    }
  }

  editPost({@required String docId, @required String content, @required String imageURL}) async {
    try {
      var data =
          _post.doc(docId).update({"content": content, "image": imageURL});
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  delete({@required String docId, @required String userId}) async {
    try {
      var data = _post.doc(docId)..delete();
      return data;
    } catch (e) {
      throw e.toString();
    }
  }
}
