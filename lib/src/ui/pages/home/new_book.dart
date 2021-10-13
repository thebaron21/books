import 'dart:io';

import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/config/upload_image.dart';
import 'package:books/src/logic/firebase/categories_bloc.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/home.dart';
import 'package:books/src/logic/function/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewBook extends StatefulWidget {
  const NewBook({Key key}) : super(key: key);

  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  UploadImage _upload;
  LibraryRespoitory _libraryRespoitory;
  User _currentUser = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  List<String> images = [];
  CategoriesFirebase bloc;
  String value = "الإعلام واللغات والعلاقات العامة";
  SearchFunction _searchFunction;

  @override
  void initState() {
    super.initState();
    _upload = UploadImage(uri: "gs://books-7b120.appspot.com");
    _libraryRespoitory = LibraryRespoitory();
    bloc = CategoriesFirebase();
    _searchFunction = SearchFunction();
  }

  num price = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          line,
          desginTextField(size, _title, AppLocale.of(context).getTranslated("title"), false),
          line,
          desginTextField(size, _description, AppLocale.of(context).getTranslated("desc"), true, isRow: true),
          line,
          desginTextField(size, _phoneNumber, AppLocale.of(context).getTranslated("phone_number") , false),
          line,
          desginTextField(size, _location, AppLocale.of(context).getTranslated("location") , false),
          line,
          dropdown(),
          line2,
          _uploadImage(size),
          _buildImage(size),
          line,
          isLoading == false
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

  desginTextField(Size size, TextEditingController con, String s, bool isBig,
      {bool isRow = false}) {
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
        maxLines: isRow == true ? 10 : 1,
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
        setState(() => isLoading = true);
        print("Is Loading : $isLoading");
        for (var i in _upload.getFile) {
          await _upload.uploadToStorage(fileImage: i);
        }
        List<String> searchTitle = _searchFunction.searchText(_title.text);

        var isSet = await _libraryRespoitory.setBook(
          {
            'title': _title.text,
            'keys': searchTitle,
            'category': value,
            'description': _description.text,
            'price': price,
            'image': _upload.getUrlImage,
            'phoneNumber': int.parse(_phoneNumber.text),
            'location': _location.text,
            "userId": _currentUser.uid
          },
        );
        print("Is Seting $isSet");
        if (isSet == true) {
          RouterC.of(context).push(HomePage());
          setState(() => isLoading = false);
        } else {
          RouterC.of(context).message("خطا", "خطا غير معروف");
          setState(() => isLoading = false);
        }
        setState(() => isLoading = false);
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
          AppLocale.of(context).getTranslated("save")  ,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _uploadImage(Size size) {
    return Tooltip(
      message: 'Upload Image',
      child: InkWell(
        onTap: () async {
          _showPicker(context);
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.withOpacity(0.4),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  _buildImage(Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 60,
          childAspectRatio: 2 / 3,
          mainAxisSpacing: 2 / 5,
          crossAxisCount: 6,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5),
            child: Image.file(
              File(images[index]),
              fit: BoxFit.cover,
            ),
          );
        },
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
                      image.forEach((element) {
                        setState(() {
                          images.add(element.path);
                        });
                      });

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  title: Text('Camera'),
                  leading: Icon(Icons.photo_camera),
                  onTap: () async {
                    File image = await _upload.openCamera();
                    images.add(image.path);
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

  dropdown() {
    return StreamBuilder(
      stream: bloc.fetchCategories().asStream(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return DropdownButton(
            onChanged: (va) => setState(() => value = va),
            value: value,
            items: snapshot.data.docs
                .map(
                  (e) => DropdownMenuItem(
                    value: (e.data() as Map)['name'],
                    child: Text((e.data() as Map)['name']),
                  ),
                )
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
