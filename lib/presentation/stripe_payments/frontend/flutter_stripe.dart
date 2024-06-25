import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import '../backend/stripe_payment_function.dart';

class FlutterStripe extends StatefulWidget {
  const FlutterStripe({Key? key}) : super(key: key);

  @override
  State<FlutterStripe> createState() => _FlutterStripeState();
}

class _FlutterStripeState extends State<FlutterStripe> {
  // final TextEditingController _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 16.0),
              //     child: Text(
              //       'Enter Amount',
              //       style: TextStyle(
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: TextField(
              //         controller: _amount,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           border:
              //               UnderlineInputBorder(borderSide: BorderSide.none),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // StripePaymentFunction().makePayment(_amount.text.trim());
                    StripePaymentFunction().makePayment('99');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
