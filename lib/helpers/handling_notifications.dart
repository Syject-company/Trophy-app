import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trophyapp/constants/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

const _newVersionPayload = 'new version';

Future<void> showNotification(
    FlutterLocalNotificationsPlugin plugin, RemoteMessage message) async {
  var androidDetails = AndroidNotificationDetails(
    'NEW_VERSION',
    'New version channel',
    'This channel notificates about new version of the app',
  );
  var iosDetails = IOSNotificationDetails();
  var generalNotificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );
  await plugin.show(
    0,
    message.notification.title,
    message.notification.body,
    generalNotificationDetails,
    payload: _newVersionPayload,
  );
}

Future<void> handleSelectedNotification(String payload) async {
  if (payload == _newVersionPayload) {
    final url = playMarketLink;
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

    if (Platform.isAndroid) {
      final url = playMarketLink;
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    }
  }
}
