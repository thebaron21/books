import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/home.dart';
import 'package:flutter/material.dart';

class OneBookEdit extends StatefulWidget {
  final String title;
  final String desc;
  final String location;
  final String phoneNumber;
  final double price;
  final String uid;
  OneBookEdit(
      {Key key,
      @required this.title,
      @required this.desc,
      @required this.location,
      @required this.phoneNumber,
      @required this.price,
      @required this.uid})
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

  @override
  void initState() {
    super.initState();
    _title.text = widget.title;
    _description.text = widget.desc;
    _location.text = widget.location;
    _phoneNumber.text = widget.phoneNumber;
    price = widget.price;
  }

  List<String> images = [];

  num price = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          line,
          desginTextField(size, _title, "Title", false),
          line,
          desginTextField(size, _description, "description", true),
          line,
          desginTextField(size, _phoneNumber, "Phone Number", false),
          line,
          desginTextField(size, _location, "Location", false),
          line,
          Slider(
            value: price.toDouble(),
            min: 0.0,
            max: 100.0,
            divisions: 100,
            activeColor: Colors.teal,
            semanticFormatterCallback: (newValue) {
              return "Price : $newValue";
            },
            label: "$price",
            onChanged: (value) {
              setState(() => price = value);
            },
          ),
          line2,
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

  desginTextField(Size size, TextEditingController con, String s, bool isBig) {
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
        var data = await _books.updateBook(
          widget.uid,
          {
            'title': _title.text,
            'description': _description.text,
            'price': price,
            'phoneNumber': _phoneNumber.text,
            'location': _location.text,
          },
        );
        if (data == true) {
          RouterC.of(context).pushBack(HomePage());
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
          "Update",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
