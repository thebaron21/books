import 'dart:convert';

import 'package:http/http.dart' as http;

class StripePayment {
  static const String _publicKey =
      "pk_test_51GvVoEL8dhe3fChpDhdMEpheievQxwbqWJmuYMSTUN1I3U02xluG8sHXDChmfOHb9IWCRQjoS8GTc03kCOWalZnW006a1HCFyp";
  static String secretKey =
      "sk_test_51GvVoEL8dhe3fChp6PycWwMkgx6cZA7dwmy24Nl3DtI8IaWchOYvUmEHVPcIFzbktBNyfwVuyhAJVgcpiuHaFjO400A0VnZqMc";

  /// [Token] create new sessions
  static String createTokenUrl = "https://api.stripe.com/v1/tokens";

  static const Map<String, String> _tokenHeader = {'Authorization': _publicKey};

  makeToken() async {
    try {
      var _response = await http.post(
        Uri.parse(createTokenUrl),
        headers: _tokenHeader,
        body: {
          'card': {
            'number': '4242424242424242',
            'exp_month': 8,
            'exp_year': 2022,
            'cvc': '314',
          },
        },
      );
      print(json.decode(_response.body).toString());
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
  /*
  $stripe = new \Stripe\StripeClient(
  'sk_test_51GvVoEL8dhe3fChp6PycWwMkgx6cZA7dwmy24Nl3DtI8IaWchOYvUmEHVPcIFzbktBNyfwVuyhAJVgcpiuHaFjO400A0VnZqMc'
);
$stripe->tokens->create([
  'card' => [
    'number' => '4242424242424242',
    'exp_month' => 8,
    'exp_year' => 2022,
    'cvc' => '314',
  ],
]);
  */
}
