import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/book.dart';
import 'package:books/src/logic/firebase/categories_bloc.dart';
import 'package:books/src/logic/function/fillters.dart';
import 'package:books/src/logic/function/items_search.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/ui/pages/message/message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Color> colors = [
    Color(0xFF333333),
    Color(0xFFFF4468),
    Color(0xFF4caf50)
  ];

  SearchBar searchBar;
  String name;
  LibraryRespoitory obj = LibraryRespoitory();
  CategoriesFirebase bloc = CategoriesFirebase();
  FillterFunction _functionF = FillterFunction();
  ItemsSearch items = ItemsSearch();

  var defaultImage =
      "https://lh3.googleusercontent.com/proxy/jt8E8QcIWeRXUxY6X159gyM13jpvrZIULA3xfWH_n06U3tSG1feUCP0wHs0qZ9gDMoR71-QRD4TvRyVD-xnyhDlHd_HE";

  _SearchPageState() {
    searchBar = SearchBar(
      setState: setState,
      inBar: false,
      onChanged: (value) {
        setState(() => name = value);
      },
      onSubmitted: (value) {
        setState(() => name = null);
      },
      onCleared: () {
        setState(() => name = null);
      },
      onClosed: () {
        setState(() => name = null);
      },
      buildDefaultAppBar: buildAppBar,
    );
  }
  AppBar buildAppBar(context) {
    return AppBar(
      // iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        "Ketabk",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController _word = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Search"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.3),
                  width: size.width * 0.9,
                  height: 45,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlignVertical: TextAlignVertical.top,
                    controller: _word,
                    onChanged: (value) {
                      setState(() => _word.text = value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 30,
                ),
                itemCount: _functionF.fillters.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      _functionF.deleteItem(i);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[2],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _functionF.fillters[i].text,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Divider(),
              Text("الأصناف"),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _functionF.setItem(Fillter(text: "book", type: "type"));
                      setState(() {});
                    },
                    child: Container(
                      width: size.width * 0.3,
                      height: 30,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            _functionF.findItem("book") ? colors[0] : colors[1],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "كتب",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _functionF.setItem(Fillter(text: "post", type: "type"));
                      setState(() {});
                    },
                    child: Container(
                      width: size.width * 0.3,
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            _functionF.findItem("post") ? colors[0] : colors[1],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "ملخصات",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Text("الأقسام"),
              StreamBuilder(
                stream: bloc.fetchCategories().asStream(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData) {
                    return GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 30,
                      ),
                      shrinkWrap: true,
                      itemCount: snap.data.docs.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            String s =
                                (snap.data.docs[i].data() as Map)["name"];
                            setState(() {
                              _functionF
                                  .setItem(Fillter(text: s, type: "category"));
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: _functionF.findItem((snap.data.docs[i]
                                          .data() as Map)["name"]) ==
                                      true
                                  ? colors[0]
                                  : colors[1],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              ((snap.data.docs[i].data() as Map)["name"]
                                              as String)
                                          .characters
                                          .length >
                                      30
                                  ? ((snap.data.docs[i].data() as Map)["name"]
                                          as String)
                                      .substring(0, 30)
                                  : (snap.data.docs[i].data() as Map)["name"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snap.hasError) {
                    return Center(child: Text(snap.error.toString()));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Divider(),
              StreamBuilder(
                stream: obj.seoBook(
                  key: _word.text == "" ? null : _word.text,
                  type: _functionF.getType(),
                  category: _functionF.getCategory(),
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i) {
                        Map item = snapshot.data.docs[i].data();
                        print(item);
                        return InkWell(
                          onTap: () {
                            RouterC.of(context).push(MessagePage(
                                userId: item["userId"], book: item["title"]));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(item["type"].toString()[0]),
                            ),
                            title: Text(item["title"]),
                            subtitle: Text(item["category"]),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("خطأ في البحث"));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ListBook(List<QueryDocumentSnapshot<Object>> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (BuildContext context, int index) {
        BookModel book = BookModel.withJson(docs[index].data());
        String userId = book.userId;

        return InkWell(
          onTap: () {
            RouterC.of(context)
                .push(MessagePage(userId: book.userId, book: book.title));
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                book.image.length <= 0 ? defaultImage : book.image[0],
              ),
            ),
            title: Text(book.title),
            subtitle: Text(book.description),
          ),
        );
      },
    );
  }
}
