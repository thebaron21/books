import 'package:books/src/config/route.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/ui/pages/home/widgets/details_book.dart';
import 'package:flutter/material.dart';

cardBook(Size size, BookModel model, context) {
  if (model.image.length <= 0) {
    model.image.add(
        "https://lh3.googleusercontent.com/proxy/jt8E8QcIWeRXUxY6X159gyM13jpvrZIULA3xfWH_n06U3tSG1feUCP0wHs0qZ9gDMoR71-QRD4TvRyVD-xnyhDlHd_HE");
  }
  return InkWell(
    onTap: () {
      RouterC.of(context).push(DetailsBook(model: model));
    },
    child: Container(
      width: size.width * 0.95,
      height: size.height * 0.3,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            model.image[0].toString(),
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.teal.withOpacity(0.2),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..color = Colors.teal
                        ..strokeWidth = 1.6,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    model.description,
                    style: TextStyle(
                       foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..color = Colors.teal
                        ..strokeWidth = 1.6,
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  padding: EdgeInsets.only(left: 20, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(500),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  child: Center(
                    child: Text(
                      model.price == 0
                          ? "Free"
                          : "\$${model.price}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
