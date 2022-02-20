import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  final String idForm;
  final String idTo;
  final bool read;
  final Timestamp date;
  final String content;

  MessageModel(this.idForm, this.idTo, this.read, this.date, this.content);

  MessageModel.toObject(Map<String,dynamic> json ) :
        idForm = json["idForm"],
        idTo=json["idTo"],
        read=json["read"],
        date=json["date"],
        content=json["content"];
  toMap() => {
    "idForm": idForm,
    "idTo":idTo,
    "read":read,
    "date":date,
    "content":content
  };

}