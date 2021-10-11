import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/categories_bloc.dart';
import 'package:books/src/ui/pages/home/books_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        builder: (context,AsyncSnapshot<QuerySnapshot> snap){
          if( snap.hasData ){
            return ListView.separated(
              separatorBuilder: (context,i) => Divider(
                thickness: 1,
                color: Colors.teal,
              ),
              // padding: EdgeInsets.symmetric( vertical: 10 ),
              itemCount: snap.data.docs.length,
              itemBuilder:(context,int index){
                Map data = snap.data.docs[index].data();
                return InkWell(
                  onTap: (){
                    RouterC.of(context).push(Books());
                  },
                  child: ListTile(
                    title: Text( "${data['name']}" )
                  ),
                );
              }
            );
          }else if( snap.hasError ){
            return Center(
              child: Text( snap.error.toString() )
            );
          }else{
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
    );
  }
}
