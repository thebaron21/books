

class ModelMessage {
  final String email;
  final String message;
  final String receive;
  final String sender;

  ModelMessage({this.email, this.message, this.receive, this.sender});

  ModelMessage.fromJson(var json)
      : email = json["email"],
        message = json["message"],
        receive = json["receivder"],
        sender = json["userSender"];

  toMap() => {
    "email" : email,
    "sender" : sender,
    "receive" : receive,
    "message" : message
  };
}
