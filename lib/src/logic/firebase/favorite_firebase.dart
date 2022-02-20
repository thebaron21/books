import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _data = _firestore.collection("fa");
final books = _firestore.collection("books").snapshots();

class FavoriteFirebase{

}