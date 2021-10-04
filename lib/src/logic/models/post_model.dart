// "content": content,
//         "userId": userId,
//         "image": imageURL,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel {
  final String content;
  final String userId;
  final String imageURL;

  PostModel({@required this.content, @required this.userId, @required this.imageURL});

  PostModel.fromJson(var json)
      : content = json["content"],
        userId = json["userId"],
        imageURL = json["image"];
  toMap() => {
    "content": content,
    "userId" : userId,
    "imageURL" : imageURL,
  };
}

class PostRepoitory {
  List<PostModel> posts;

  PostRepoitory.fromMap(List<QueryDocumentSnapshot> data)
      : posts = (data).map((e) => PostModel.fromJson(e.data())).toList();
}
