import 'package:books/src/logic/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesFirebaseRealTime {
  /// Get Hash Code Of Chat
  String _getConversationID(String userID, String peerID) {
    return (userID.hashCode + peerID.hashCode).toString();
  }

  /// Set New Room of User And Last [Message]
  Future<DocumentSnapshot> _setRoom({String userID, String peerID, String lastMessage}) async {
    String code = _getConversationID(userID, peerID);
    FirebaseFirestore.instance
        .collection("messages")
        .doc(code.toString())
        .set({
            "idForm": userID,
            "idTo": peerID,
            "users": [userID, peerID],
            "lastMessage": lastMessage
          });
  }

  /// Get All Chat Of User By uuid
  Future<QuerySnapshot> getRoom({String userID, String peerID, String lastMessage}) async {
    String code = _getConversationID(userID, peerID);
    return FirebaseFirestore.instance
        .collection("messages")
        .where("users", arrayContains: userID)
        .get();
  }

  /// Get Message User to User by Conversation Code Number
  Future<QuerySnapshot> getConversation({String userId, String peerId}) {
    String code = _getConversationID(userId, peerId);
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(code)
        .collection(code)
        .orderBy('date', descending: true)
        .get();
  }

  // Set New Message By peerId And User ID
  setMessage({MessageModel message}) async {
    var code = _getConversationID(message.idForm, message.idTo);
    await FirebaseFirestore.instance.collection("messages") .doc(code).collection(code).add(message.toMap());
    await _setRoom(peerID: message.idTo, userID: message.idForm,lastMessage: message.content);
    return true;
  }

}
