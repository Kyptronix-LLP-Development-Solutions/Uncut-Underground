import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uncut_underground/app.dart';
import 'package:uncut_underground/firebase_options.dart';
import 'package:uncut_underground/presentation/notification/send_topic_noti.dart';

import 'presentation/notification/receive_handle_noti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // firebase notification
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  // await subscribeToTopic
  NotificationService().subscribeToTopic('topic');

  // end of firebase notification
  Stripe.publishableKey =
      'pk_test_51OWa4PChWMGL36pEMKHln9s5TECNEguy3zHlbLhhFE2S8VKKQeT90KF3LLtwLlyLrHqvsIQ1aVQOowbkrMQTALcp00ClLlWzF6';

  await Stripe.instance.applySettings();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
/* 
NotificationService().sendNotificationToTopic(
topic: 'topic', title: 'title', body: 'body');
 */