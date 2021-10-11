import 'package:books/src/logic/models/book._model.dart';
import 'package:flutter/material.dart';

class WidgetCardBook extends StatelessWidget {
  final BookModel book;

  WidgetCardBook({Key key, this.book}) : super(key: key);
  var defaultImage =
      "https://images.pexels.com/photos/2852438/pexels-photo-2852438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: size.width * 0.95,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0Xff222222).withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(
                      book.image.length <= 0 ? defaultImage : book.image[0]),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    book.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    book.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      country(book.location),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.teal,
                          ),
                          onPressed: () {},
                          child: Text("Show"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// {@tool snippet}
  /// The [Align] widget in this example uses one of the defined constants from
  /// [Alignment], [Alignment.topRight]. This places the [FlutterLogo] in the top
  /// right corner of the parent blue [Container].
  ///
  Widget country(String country) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Text(
        country,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
