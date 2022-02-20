import 'package:flutter/material.dart';

class BookModel {
  final String title;
  final String description;
  final int price;
  final List<dynamic> image;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  final String location;
  final String phoneNumber;

  BookModel(
      {@required this.location,
      @required this.phoneNumber,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      this.isFavorite = false});

  BookModel.withJson(var json)
      : title = json["title"],
        description = json["description"],
        price = json["price"],
        image = json["image"],
        isFavorite = json["isFavorite"],
        location = json["location"],
        phoneNumber = json["phoneNumber"].toString(),
        userEmail = json["userEmail"],
        userId = json["userId"];

  toMap() => {
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
