class RoomModel {
  final String lastMessage;
  final String idTo;
  final String idForm;
  final String bookTitle;
  final List<dynamic> users;

  RoomModel.toObject(Map<String, dynamic> json)
      : lastMessage = json["lastMessage"],
        idTo = json["idTo"],
        idForm = json["idForm"],
        bookTitle = json["title"],
        users = json["users"];
}
