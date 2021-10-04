import 'package:flutter/material.dart';

class BookModel {
  final int id;
  final String title;
  final String description;
  final int price;
  final List<dynamic> image;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  final String location;
  final int phoneNumber;

  BookModel(
      {@required this.location,
      @required this.phoneNumber,
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      this.isFavorite = false});

  BookModel.withJson(var json)
      : id = json["id"],
        title = json["title"],
        description = json["description"],
        price = json["price"],
        image = json["image"],
        isFavorite = json["isFavorite"],
        location = json["location"],
        phoneNumber = json["phoneNumber"],
        userEmail = json["userEmail"],
        userId = json["userId"];

  toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "image": image,
        "isFavorite": isFavorite,
        "userEmail": userEmail,
        "userId": userId,
        "location": location,
        "phoneNumber": phoneNumber,
      };
}
