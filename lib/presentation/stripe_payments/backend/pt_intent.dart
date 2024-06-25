import 'dart:convert';
import 'package:http/http.dart' as http;

createPaymentIntent(String amount, String currency) async {
  try {
    //Request body
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
    };

    //Make post request to Stripe
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer sk_test_51OWa4PChWMGL36pE3r30Seix4YBfCqmic6Q4lQE4Q0DIjMibImLgfdTAIsIDYZ7Gk1A4ebnRDuVwRSnJjeJS4r9Y00XSEoyCUm',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    return json.decode(response.body);
  } catch (err) {
    throw Exception(err.toString());
  }
}

//calculate Amount
calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 100;
  return calculatedAmount.toString();
}
