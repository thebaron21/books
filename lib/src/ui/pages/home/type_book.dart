import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/ui/pages/home/books_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'new_book.dart';

class TypeBookAndPost extends StatelessWidget {
  final String category;
  TypeBookAndPost({Key key, this.category}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.1),
          Text(
            category,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.tajawal(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox( height: size.height * 0.05 ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // _libraryRepository.getBookOfType(type: "book", category: category);
            children: [
              _card(size, "كتب", context , TypeForm.book),
              _card(size, "ملخصات", context,TypeForm.post),
            ],
          ),
        ],
      ),
    );
  }

    _card(Size size, String s, context, TypeForm type) {
    return GestureDetector(
      onTap: (){
        switch(type){
          case TypeForm.book:
            RouterC.of(context).push(
              Books(
                type: "book",
              )
            );
            break;
          case TypeForm.post:
            RouterC.of(context).push(
                Books(
                  type: "post",
                )
            );
            break;
        }
      },
      child: Container(
        width: 180,
        height: 180,
        alignment: Alignment.center,
        margin: EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          s,
          style: GoogleFonts.tajawal(
            color: Theme.of(context).colorScheme.background,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
