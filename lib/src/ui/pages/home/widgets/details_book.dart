import 'package:books/src/config/route.dart';
import 'package:books/src/logic/models/book._model.dart';
import 'package:books/src/ui/pages/pay/payment_page.dart';
import 'package:books/src/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
//page_indicator

class DetailsBook extends StatefulWidget {
  final BookModel model;
  const DetailsBook({Key key, @required this.model}) : super(key: key);

  @override
  _DetailsBookState createState() => _DetailsBookState();
}

class _DetailsBookState extends State<DetailsBook> {
  PageController controller;
  GlobalKey<PageContainerState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerC.of(context).drawer,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF333333)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sliderImage(widget.model.image, size),
          _desc(widget.model, size),
          _payment(widget.model, size),
        ],
      ),
    );
  }

  // ignore: unused_element
  get _line => Divider(
        thickness: 0.2,
        color: Color(0xFF333333),
      );

  _sliderImage(List image, size) {
    print(image);
    return Container(
      height: size.height * 0.35,
      child: PageIndicatorContainer(
        key: key,
        align:IndicatorAlign.bottom,
        length:image.length,
        padding: EdgeInsets.all(10),
        indicatorColor: Colors.teal[100],
        indicatorSelectorColor: Colors.teal[900],
        shape: IndicatorShape.circle(),
        child: PageView.builder(
          itemCount: image.length,
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: size.width * 0.9,
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],
                border:
                    Border.all(color: Colors.black.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _desc(BookModel model, Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.title,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 21,
                ),
              ),
              Container(
                width: size.width * 0.4,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF222222),
                ),
                child:
                    Text(model.location, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 50),
          Text("Description", style: TextStyle(fontWeight: FontWeight.w900)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              model.description,
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                "Phone Number : ",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              Text("${model.phoneNumber.toString()}")
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  _payment(model, size) {
    return InkWell(
      onTap: () {
        if (double.parse(model.price) == 0) {
          print("Not Payment");
        } else {
          RouterC.of(context).push(
            PaymentPage(
              price: double.parse(model.price),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: size.width * 0.25,
        height: size.height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.teal,
        ),
        alignment: Alignment.center,
        child: Text(
          double.parse(model.price) == 0 ? "Free" : "Buy : ${model.price}",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
