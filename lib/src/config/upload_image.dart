import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImage {
  final String uri;
  UploadImage({@required this.uri});
  // Save file of Phone
  List<File> _fileImage = [];
  // create new instance
  ImagePicker _imagepicker = ImagePicker();

  /// var to Save URl Image for Store in [Storage]
  List<String> _images = [];

  // Method to Open Gallery Phone
  openGallery() async {
    // ignore: deprecated_member_use
    var _imageSource = await _imagepicker.getImage(source: ImageSource.gallery);
    if (_imageSource != null) {
      File ileImage = File(_imageSource.path);
      print(_imageSource.path);
      _fileImage.add(ileImage);
      return ileImage;
    } else {
      print("anythings");
    }
  }

  // Method to Open Camare Phone
  openCamera() async {
    // ignore: deprecated_member_use
    var _imageSource = await _imagepicker.getImage(source: ImageSource.camera);
    if (_imageSource != null) {
      var ileImage = File(_imageSource.path);
      _fileImage.add(ileImage);
      return ileImage;
    } else {
      print("anythings");
    }
  }

  /// Method to Upload Image on [FirebaseStorage]
  /// Bucket [gs://projcetchat.appspot.com]
  Future<void> uploadToStorage({@required File fileImage}) async {
    try {
      String _basenameFile = path.basename(fileImage.path);
      FirebaseStorage firebaseStorage =
          FirebaseStorage.instanceFor(bucket: "$uri");
      var ref =
          await firebaseStorage.ref("books/$_basenameFile").putFile(fileImage);
      print("Url Image ${await ref.ref.getDownloadURL()}");
      _images.add(await ref.ref.getDownloadURL());
      print("_url Image Langth : ${_images.length}");
    } catch (e) {
      print(e);
    }
  }

  List<String> get getUrlImage => _images;
  List<File> get getFile => _fileImage;
}
