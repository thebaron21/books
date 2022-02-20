import 'dart:io';

import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/config/upload_image.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:flutter/material.dart';

class OneBookEdit extends StatefulWidget {
  final String title;
  final String desc;
  final String location;
  final int phoneNumber;
  final String uid;
  String image;
  OneBookEdit(
      {Key key,
      @required this.title,
      @required this.desc,
      @required this.location,
      @required this.phoneNumber,
      @required this.uid, this.image})
      : super(key: key);

  @override
  _OneBookEditState createState() => _OneBookEditState();
}

class _OneBookEditState extends State<OneBookEdit> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  LibraryRespoitory _books = LibraryRespoitory();
  bool _isLoading = false;
  UploadImage _upload = UploadImage(uri: "gs://books-7b120.appspot.com");

  @override
  void initState() {
    super.initState();
    _title.text = widget.title;
    _description.text = widget.desc;
    _location.text = widget.location;
    _phoneNumber.text = widget.phoneNumber.toString();
  }

  List<String> images = [];

  num price = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: size.width*0.95,
            height: 160,
            decoration: BoxDecoration(
                image:DecorationImage(
                  fit: BoxFit.cover,
                  image: images.length == 0 ? NetworkImage(
                      widget.image
                  ) : AssetImage(
                      images[0]
                  ),
                )
            ),
          ),
          line,
          designTextField(size, _title,AppLocale.of(context).getTranslated("title"), false),
          line,
          designTextField(size, _description,AppLocale.of(context).getTranslated("desc"), true),
          line,
          designTextField(size, _phoneNumber, AppLocale.of(context).getTranslated("phone_number"), false),
          line,
          designTextField(size, _location, AppLocale.of(context).getTranslated("location") , false),
          line,
          _isLoading == false
              ? _btnSave(size)
              : Center(
                  child: CircularProgressIndicator(),
                ),
          line,
        ],
      ),
    );
  }

  get line => SizedBox(
        height: 20,
      );
  get line2 => SizedBox(
        height: 10,
      );

  designTextField(Size size, TextEditingController con, String s, bool isBig) {
    return Container(
      width: size.width * 0.9,
      height: isBig == false ? size.height * 0.07 : size.height * 0.2,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: con,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: s,
        ),
      ),
    );
  }

  _btnSave(Size size) {
    return InkWell(
      onTap: () async {
        setState(() => _isLoading = true);
        if( images.isNotEmpty ){
          await _upload.uploadToStorage(fileImage: File(images[0]));
          String imageUrl = _upload.getUrlImage[0];
          widget.image=imageUrl;
        }

        var data = await _books.updateBook(
          widget.uid,
          {
            'title': _title.text,
            'description': _description.text,
            'price': price,
            'phoneNumber': int.parse(_phoneNumber.text),
            'location': _location.text,
          },
        );
        if (data == true) {
          // RouterC.of(context).pushBack(HomePage());
          Navigator.pop(context);
        } else {
          RouterC.of(context).message("خطا", "خطا غير معروف");
        }
        setState(() => _isLoading = false);
      },
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          AppLocale.of(context).getTranslated("update") ,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
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
                      List<File> image = await _upload.openGallery();
                      images.clear();
                      setState(() {
                        images.add(image[0].path);
                      });
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () async {
                    File image = await _upload.openCamera();
                    images.clear();
                    setState(() {
                      images.add(image.path);
                    });
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
}
