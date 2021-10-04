import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _data = _firestore.collection("categories");
final categories = _firestore.collection("categories").snapshots();

class CategoriesFirebase {
  Future<QuerySnapshot> fetchCategories() async {
    return _data.get();
  }
}
