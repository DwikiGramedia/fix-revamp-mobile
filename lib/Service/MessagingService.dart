import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Model/Pushnotification/Pushnotification.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:revamp_eperpus_mobile/View/Splash/splash_view.dart';
import 'package:revamp_eperpus_mobile/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingService {
  ///  Request Notification of FirebaseCloudMessaging
  ///  FirebaseCloudMessaging need FlutterLocalNotification for using notification device
  ///  requestNotification put in Splashview / first trigering
  Future<void> requestNotification() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      criticalAlert: true,
      badge: true,
      provisional: Platform.isIOS ? false : true,
      sound: true,
    );

    print("settings.authorizationStatus: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await messaging.getInitialMessage();

      final sharedPreferences = await SharedPreferences.getInstance();
      String? token = await getFirebaseToken();
      print("TOKEN CACHE: $token");

      if (token!.isEmpty) {
        String? fcmToken = await messaging.getToken();
        print("FCM Token: \n $fcmToken");
        setFirebaseToken(fcmToken!);
      }

      String? jwtToken = sharedPreferences.getString("JWT") ?? "";
      if (jwtToken.isNotEmpty) {
        await UserService().sendNotificationKey();
      }

      if (Platform.isIOS) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      FirebaseMessaging.onMessage.listen((event) {
        print(
            "Event firebase messaging: ${event.notification?.body.toString()}");
        PushNotification pushNotification;
        print("event.data[type]: ${event.data["type"]}");
        switch (event.data["type"]) {
          case "detail":
            pushNotification = PushNotification(
              title: event.notification?.title ?? "",
              body: event.notification?.body ?? "",
              type: event.data["type"],
              dataBody: event.data["body"],
              dataTitle: event.data["title"],
              id: int.parse(event.data["watchlist_id"]),
              channel: "Waitlist",
              href: event.data["href"],
            );
            showNotification(pushNotification);
            break;
          case "auto_returned":
            pushNotification = PushNotification(
                title: event.notification?.title ?? "",
                body: event.notification?.body ?? "",
                type: event.data["type"],
                dataBody: event.data["body"],
                dataTitle: event.data["title"],
                id: event.data["borrowed_id"],
                channel: "Auto-return",
                href: event.data["href"]);
            showNotification(pushNotification);
            break;
        }
        pushNotification = PushNotification(
          title: event.notification?.title ?? "",
          body: event.notification?.body ?? "",
          type: "${event.data["type"]}",
          dataBody: "${event.notification?.body}",
          dataTitle: "${event.notification?.title}",
          id: int.parse(event.data["watchlist_id"] ?? "0"),
          channel: "Notification",
          href: "${event.data["href"]}",
        );
        showNotification(pushNotification);
      });
    } else {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await requestNotification();
    }
  }

  Future<void> backgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage((event) async {
      print("Event firebase messaging background: ${event.toString()}");
      PushNotification pushnotification;
      switch (event.data["type"]) {
        case "detail":
          pushnotification = PushNotification(
              title: event.notification?.title ?? "",
              body: event.notification?.body ?? "",
              type: event.data["type"],
              dataBody: event.data["body"],
              dataTitle: event.data["title"],
              id: event.data["watchlist_id"],
              channel: "Waitlist",
              href: event.data["href"]);
          showNotification(pushnotification);
          break;
        case "auto_returned":
          pushnotification = PushNotification(
              title: event.notification?.title ?? "",
              body: event.notification?.body ?? "",
              type: event.data["type"],
              dataBody: event.data["body"],
              dataTitle: event.data["title"],
              id: event.data["borrowed_id"],
              channel: "Auto-return",
              href: event.data["href"]);
          showNotification(pushnotification);
          break;
      }
    });
  }

  Future<void> openMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      // await debugLog(event.data);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  /// Show Notification for using FlutterLocalNotification
  /// LocalNotification triggered when triggered FirebaseMessage.onMessage
  Future<void> showNotification(
    PushNotification pushNotification,
  ) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    bool? isAllowedAndroid = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    bool? isAllowedIos = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("colibrio_logo");
    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      pushNotification.id.toString(),
      pushNotification.channel,
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    if (Platform.isIOS) {
      if (isAllowedIos ?? false == true) {
        await flutterLocalNotificationsPlugin.show(
          0,
          pushNotification.title,
          pushNotification.body,
          notificationDetails,
        );
      } else {}
    } else {
      if (isAllowedAndroid ?? false == true) {
        await flutterLocalNotificationsPlugin.show(
          0,
          pushNotification.title,
          pushNotification.body,
          notificationDetails,
        );
      } else {}
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    // await debugLog('id $id');
    // await debugLog("Payload from iOS ${payload ?? ""}");
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  void selectNotification(String? payload, BuildContext context) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashView()));
    }
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // await debugLog("Tap Background ${notificationResponse.payload}");
    // handle action
  }
}
