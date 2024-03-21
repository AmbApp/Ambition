// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Function(dynamic notification, String type) onNotificationReceived;
  bool isNotificationRegistered = false;
  static String? _pushNotificationToken;

  factory NotificationService({required onNotificationReceived}) {
    _instance.onNotificationReceived = onNotificationReceived;
    return _instance;
  }

  NotificationService._internal();

  void registerNotification() async {
    if (isNotificationRegistered) {
      return;
    }
    try {
      isNotificationRegistered = true;
      await requestPermissions();
      await NotificationService.getToken();
      await initNotificationPlugin();
      attachForegroundNotificationHandler();
      attachBackgroundNotificationHandler();
    } catch (e) {
      isNotificationRegistered = false;
    }
  }

  Future<void> initNotificationPlugin() async {
    var androidInitialize = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      // onSelectNotification: (String? payload) async {
      //   try {
      //     if (payload != null && payload.isNotEmpty) {
      //       print('notification payload: $payload');
      //     } else {}
      //   } catch (e) {
      //     print(e);
      //   }
      //   return;
      // },
    );
  }

  static Future<void> updatePushNotificationToken(String token) async {
    _pushNotificationToken = token;

    print("Push notification token set to $_pushNotificationToken");

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('Token', _pushNotificationToken!);
  }

  static Future<String> getToken() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final String token = await messaging.getToken() ?? '';

    messaging.onTokenRefresh.listen(updatePushNotificationToken);

    debugPrint('Device Token: $token  END');

    return token;
  }

  Future<void> requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      throw Exception('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in foreground
  void attachForegroundNotificationHandler() {
    print(".........attachForegroundNotificationHandler...........");
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print(".........onMessage...........");
        print(
          "onMessage: message ${message}",
        );

        log(
          "onMessage: message DATA${message.data['data']} END",
        );

        onNotificationReceived.call(message.data['data'], message.data['type']);

        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true,
        );
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          playSound: true,
          // sound: RawResourceAndroidNotificationSound('notification'),
        );
        DarwinNotificationDetails? iosPlatformChannelSpecifics =
            const DarwinNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['title'],
        );
      },
    );
  }

  // For handling notification when the app is in background
  void attachBackgroundNotificationHandler() {
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print("Handle initial message");
    if (initialMessage != null) {
      // TODO: Handle initial message
      print("Handle initial message");
    }
  }
}
