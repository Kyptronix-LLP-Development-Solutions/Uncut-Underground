import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // TODO: here is the change to be made
      String? email = FirebaseAuth.instance.currentUser!.email;

      await updateSubscriptionStatus(email!, true);
    }
  }

  Future<void> updateSubscriptionStatus(String email, bool isSubscribed) async {
    try {
      // Query for the document with the matching email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first (and should be only) matching document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Update the isSubscribed field
        await userDoc.reference.update({'isSubscribed': isSubscribed});

        debugPrint('Subscription status updated successfully');
      } else {
        debugPrint('No user found with the provided email');
      }
    } catch (e) {
      debugPrint('Error updating subscription status: $e');
    }
  }
}
