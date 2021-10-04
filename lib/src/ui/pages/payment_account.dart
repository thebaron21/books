
import 'package:flutter/material.dart';

class PaymentAccount extends StatefulWidget {
  const PaymentAccount({Key key}) : super(key: key);

  @override
  _PaymentAccountState createState() => _PaymentAccountState();
}

class _PaymentAccountState extends State<PaymentAccount> {
  // PaymentRepository _paymentRepository = PaymentRepository();
  TextEditingController _cardController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _cardController,
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                // CheckCardEvent data = CheckCardEvent(
                //   "card",
                //   "4242 4242 4242 4242",
                //   "12/2",
                //   "2022",
                //   100,
                // );
                // var isPayment =
                //     await _paymentRepository.makePayment(payment: data);
                // print(isPayment);
              },
              child: Text("Payment"),
            )
          ],
        ),
      ),
    );
  }
}
