import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/categories_bloc.dart';
import 'package:books/src/ui/pages/home/books_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'type_book.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  CategoriesFirebase bloc = CategoriesFirebase();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.fetchCategories().asStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
        if (snap.hasData) {
          return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 4 / 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              physics: ScrollPhysics(),
              itemCount: snap.data.docs.length,
              itemBuilder: (context, int index) {
                Map data = snap.data.docs[index].data();
                return InkWell(
                  onTap: () {
                    RouterC.of(context).push(TypeBookAndPost(
                      category: data['name'],
                    ));
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.2),
                          blurRadius: 10,
                        )
                      ],
                      color: Theme.of(context).colorScheme.primary

                    ),
                    child: Center(
                      child:Text(
                        data['name'],textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.background
                        ),
                      ),
                    ),
                  ),
                );
              },);
        } else if (snap.hasError) {
          return Center(child: Text(snap.error.toString()));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
