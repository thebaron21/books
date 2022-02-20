
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _data = _firestore.collection("books");
final books = _firestore.collection("books").snapshots();

class LibraryRespoitory {
  User _currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> getBooks({String category}) async* {
    yield* _data
        .where("category", isEqualTo: category)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyBooks() async* {
    yield* _data.where("userId", isEqualTo: _currentUser.uid).snapshots();
  }
  Stream<QuerySnapshot> getBookOfType({String type})async*{
    yield* _data
        .where( "type" , isEqualTo: type)      
        .snapshots();
  }

  Stream<QuerySnapshot> seoBook({String type,String category,key})async*{
    yield* _data
        .where( "type" , isEqualTo: type)
        .where("category" , isEqualTo: category)
        .where('keys', arrayContains: key)
        .snapshots();
  }

  /// [setBook] Insert new Book
  Future<bool> setBook(Map<String, dynamic> book) async {
    try {
      _data.add(book);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  bool delBook(String id) {
    try {
      _data.doc(id).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<DocumentSnapshot> getBook(String uid) async* {
    try {
      yield* _data.doc(uid).get().asStream();
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> updateBook(String uid, Map<String, dynamic> bookNew) async {
    try {
      await _data.doc(uid).update(bookNew);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot> searchBook(key) async {
    try {
      // SearchFunction _text = SearchFunction();
      // List keys = _text.searchText(key);
      var data = await _data.where('keys', arrayContains: key).get();
      return data;
    } catch (e) {
      throw e;
    }
  }
}
