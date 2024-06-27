import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:developer' as devtools show log;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {
  static const String _projectId = 'uncut-underground';
  static const String _fcmUrl =
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final jsonCredentials = await rootBundle
          .loadString('assets/logo/uncut-underground-0ec02b1ab797.json');
      final credentials =
          auth.ServiceAccountCredentials.fromJson(jsonCredentials);

      final client = await auth.clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      final message = {
        'message': {
          'topic': topic,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
        },
      };

      final response = await client.post(
        Uri.parse(_fcmUrl),
        body: jsonEncode(message),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        devtools.log('Successfully sent message: ${responseData['name']}');
        return true;
      } else {
        devtools.log(
            'Failed to send message. StatusCode: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      devtools.log('Error sending notification: $e');
      return false;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    devtools.log('Subscribed to topic: $topic');
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    devtools.log('Unsubscribed from topic: $topic');
  }
}
