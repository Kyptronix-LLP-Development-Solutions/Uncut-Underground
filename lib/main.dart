import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uncut_underground/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51OWa4PChWMGL36pEMKHln9s5TECNEguy3zHlbLhhFE2S8VKKQeT90KF3LLtwLlyLrHqvsIQ1aVQOowbkrMQTALcp00ClLlWzF6';

  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
