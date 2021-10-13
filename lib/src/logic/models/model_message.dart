

import 'package:cloud_firestore/cloud_firestore.dart';

class ModelMessage {
  final String message;
  final Timestamp date;
  final Users users;

  ModelMessage({this.date, this.message, this.users});

  ModelMessage.fromJson(var json)
  :     date = json["date"],
        message = json["message"],
        users = Users.fromMap(json['users']);

  toMap() => {
    "date" : date,
    "message" : message,
    "users" : users.toMap()
  };
}

class Users{
  final String senders;
  final String receive;

  Users(this.senders, this.receive);

  Users.fromMap( var json ) :
       senders=json[0],
  receive = json[1];

  toMap2() => {
    "sender" : receive,
    "receive" : senders
  };
  toMap() =>{
    "receive" : receive,
    "sender" : senders,
  };
}