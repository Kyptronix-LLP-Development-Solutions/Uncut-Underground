import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import 'pt_intent.dart';

/* -------------------------------------------------------------------------- */
/*                               stripe payment                               */
/* -------------------------------------------------------------------------- */

class StripePaymentFunction {
  Map<String, dynamic>? paymentIntent;

  /* -------------------------- make payment function ------------------------- */
  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      if (paymentIntent == null) {
        // Handle the case where the payment intent wasn't created successfully.
        return;
      }

      // Initialize payment sheet
      final result = await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret:
              paymentIntent!['client_secret'], // Gotten from payment intent
          style: ThemeMode.light,
          merchantDisplayName: 'Kyptronix LLP',
          googlePay: gpay,
        ),
      );

      if (result != null) {
        debugPrint(result as String?);
        // TODO: PAYMENT DETAILS
        // print('\n\n\n\n\n\n');
        // print('Wassup');
        // await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        //   'userId': user.uid,
        //   'name': user.displayName,
        //   'email': user.email,
        //   // Add more fields as needed
        // });

        // Handle initialization error.
        return;
      }

      // Display payment sheet
      displayPaymentSheet();
    } catch (e) {
      // Handle any other unexpected errors.
      debugPrint('Error: $e');
    }
  }

  /* ---------------------------- google pay option --------------------------- */
  var gpay = const PaymentSheetGooglePay(
      merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

  /* ------------------------------ payment sheet ----------------------------- */
  displayPaymentSheet() async {
    final paymentResult = await Stripe.instance
        .presentPaymentSheet(options: const PaymentSheetPresentOptions());
    // state = NetworkState.success;

    if (paymentResult != null) {
      // Handle any payment sheet errors.
      debugPrint('Payment Sheet Error: $paymentResult');
    } else {
      // Payment was successful.

      debugPrint('Payment successful');
    }
  }
}
