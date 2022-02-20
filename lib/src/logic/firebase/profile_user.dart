import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _data = _firestore.collection("users");

class UserProfile {
  ImagePicker _imagepicker = ImagePicker();

  Future<void> setProfile({String uuid, String urlImage, String name}) async {
    await _data.add({"name": name, "uuid": uuid});
  }

  Future<void> updateImage({String url, String uuid}) async {
    var doc = await _data.where("uuid", isEqualTo: uuid).get();
    await doc.docs.first.reference.update({"image": url});
    return true;
  }

  Future<QuerySnapshot> getProfile({String uuid}) async {
    var data = _data.where("uuid", isEqualTo: uuid);
    return data.get();
  }

  Future<QuerySnapshot> getName({String uuid}) async {
    var data = _data.where("uuid", isEqualTo: uuid);
    return data.get();
  }

  openCamera() async {
    XFile file = await _imagepicker.pickImage(source: ImageSource.camera);
    return File(file.path);
  }

  openGallery() async {
    XFile file = await _imagepicker.pickImage(source: ImageSource.gallery);
    return File(file.path);
  }

  Future<String> uploadToStorage({File fileImage}) async {
    try {
      String _basenameFile = path.basename(fileImage.path);
      FirebaseStorage firebaseStorage =
          FirebaseStorage.instanceFor(bucket: "gs://projcetchat.appspot.com");
      var ref =
          await firebaseStorage.ref("users/$_basenameFile").putFile(fileImage);
      var image = await ref.ref.getDownloadURL();
      return image;
    } catch (e) {
      throw e;
    }
  }
}
