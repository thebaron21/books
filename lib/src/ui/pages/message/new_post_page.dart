import 'dart:io';
import 'package:books/src/config/route.dart';
import 'package:books/src/config/upload_image.dart';
import 'package:books/src/logic/responses/post_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/posts_widget.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TextEditingController content = TextEditingController();
  TextEditingController title = TextEditingController();


  File image;
  bool isLoading = false;
  PostLogic _logic = PostLogic();
  UploadImage _upload = UploadImage(uri: "gs://books-7b120.appspot.com");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              PostWidget.desginTextField(size, title, "Title", false),
              SizedBox(
                height: 10,
              ),
              PostWidget.desginTextField(size, content, "Content", true),
              SizedBox(height: 10),
             image == null ? PostWidget.uploadImage(
               size,
               onTap: () =>
                 _showPicker(context)
             ) : Center(),
              image != null
                  ? Container(
                width: size.width * 0.9,
                height: 300,
                decoration: BoxDecoration(
                  // color: Colors.teal,
                    border: Border.all(
                      color: Colors.teal,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              )
                  : Center(),
              PostWidget.newPost(
                size: size,
                busy: isLoading,
                onTap: () => onTap,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () async {
                     var file = await _upload.openGallery();
                     setState(() => image = file);
                     Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                   _upload.openCamera();
                   Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onTap() async {
    if( image == null ){
      RouterC.of(context).message("خطأ", "إملء كل العناصر");
    }else {
      FirebaseAuth user = FirebaseAuth.instance;
      setState(() => isLoading = true);
      await _upload.uploadToStorage(fileImage: image);
      String imageUrl = _upload.getUrlImage[0];
      print(imageUrl);
      var isPost = await _logic.setPost(
        content: content.text,
        title: title.text,
        imageURL: imageUrl,
        userId: user.currentUser.uid,
      );
      if (isPost == true) {
        Navigator.pop(context);
      }
      setState(() => isLoading = false);
    }
  }
}
//com.baron.book