import 'package:books/src/logic/firebase/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  final double price;
  const PaymentPage({Key key, @required this.price}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController _cardNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              _desginTextField(size, _cardNumber, "Card Number"),
              SizedBox(height: 20),
              _textPrice(widget.price),
              SizedBox(height: 20),
              _btnPayment(size),
            ],
          ),
        ),
      ),
    );
  }

  _textPrice(double price) {
    return Text(
      "Total Price : $price",
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 21,
      ),
    );
  }

  _desginTextField(Size size, TextEditingController con, String s) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.12,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.teal.withOpacity(0.1), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          )
        ],
      ),
      child: TextField(
        controller: con,
        keyboardType: TextInputType.number,
        maxLength: 16,
        // ignore: deprecated_member_use
        maxLengthEnforced: true,
        decoration: InputDecoration(
          hintText: s,
        ),
      ),
    );
  }

  _btnPayment(Size size) {
    return InkWell(
      onTap: () async {
        StripePayment obj = StripePayment();
        await obj.makeToken();
        // _pay.makePayment(
        //   payment: CheckCardEvent(
        //     "card",
        //     "4343434343434343",
        //     "6",
        //     "2025",
        //     500,
        //   ),
        // );
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
          "Buy",
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
