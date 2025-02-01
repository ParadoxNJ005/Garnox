import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sembreaker/pages/HomePage.dart';
import '../main.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _androidchannel = const AndroidNotificationChannel(
    'high importance channel',
    'High Importance Notifications',
    description: 'This channel is used for notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    String? fCMToken = await _firebaseMessaging.getToken();
    initPushNotifications();
    initLocalNotifications();

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Handle the notification message and navigate accordingly
  void handleMessage(BuildContext context, RemoteMessage? message) {
    if (message == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Pass context to handleMessage during initial message or opened app
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Get the context from where it's being called (ensure you have it available)
        handleMessage(navigatorKey.currentContext!, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) {
        handleMessage(navigatorKey.currentContext!, message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final androidNotification = message.notification?.android;

      if (notification == null || androidNotification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidchannel.id, // Channel ID
            _androidchannel.name, // Channel name
            channelDescription: _androidchannel.description, // Channel description
            importance: Importance.max, // Set importance
            priority: Priority.high,   // Set priority
            icon: "@mipmap/ic_launcher", // Define app icon for notification
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidchannel);
  }

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final payload = notificationResponse.payload;
        if (payload != null) {
          // Decode the payload string into a Map
          final Map<String, dynamic> data = jsonDecode(payload);
          // Convert Map to RemoteMessage if necessary
          final message = RemoteMessage.fromMap(data);
          handleMessage(navigatorKey.currentContext!, message); // Pass context here
        }
      },
    );
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  }
}
