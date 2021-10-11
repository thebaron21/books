// "content": content,
//         "userId": userId,
//         "image": imageURL,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel {
  final String title;
  final String content;
  final String userId;
  final Timestamp date;
  final String imageURL;

  PostModel({@required this.content, @required this.userId, @required this.imageURL,this.title,this.date});

  PostModel.fromJson(var json)
      : content = json["content"],
        userId = json["userId"],
        imageURL = json["image"],
        title = json["title"],
        date = json["time"];
  toMap() => {
    "content": content,
    "userId" : userId,
    "imageURL" : imageURL,
    "date" : date,
    "title" : title
  };
}

class PostRepository {
  List<PostModel> posts;

  PostRepository.fromMap(List<QueryDocumentSnapshot> data)
      : posts = (data).map((e) => PostModel.fromJson(e.data())).toList();
}
