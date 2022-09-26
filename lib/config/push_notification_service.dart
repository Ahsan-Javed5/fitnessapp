import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'fcm_controller.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  void registerNotification() async {
    _fcm.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // On iOS, this helps to take the user permissions
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    ///if user logged in then update FCM
    _fcm.getToken().then((token) {
      MyHive.setFcm(token ?? '');
      if (MyHive.getUser() != null) {
        if (MyHive.getUserType() == UserType.coach &&
            MyHive.getUser()!.bankDetails?.subscriptionPrice == null) {
          return;
        }
        FCMController().updateFCM(token ?? '');
      }
    });

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'max_imp_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      playSound: true,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
        iOS: initializationSettingsIOS,
      ),
      onSelectNotification: (senderId) {
        if (senderId != null && senderId.isNotEmpty && Platform.isAndroid) {
          EasyDebounce.debounce(
              'my-debounced',
              const Duration(milliseconds: 500),
              () => Utils.open1to1Chat(
                  MyHive.getUser()?.firebaseKey ?? '', senderId, Get.context!));
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        android: androidPlatformChannelSpecifics);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      final data = message.data;
      String title =
          Utils.isRTL() ? data['title_ar'] : notification?.title ?? '';
      String body = Utils.isRTL() ? data['body_ar'] : notification?.body ?? '';

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          platformChannelSpecifics,
          payload: data['senderId'] ?? '',
        );
      }
    });

    /// When app is opened by clicking on the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = message.data;
      String? senderId = data['senderId'] ?? '';

      if (senderId != null && senderId.isNotEmpty) {
        EasyDebounce.debounce(
            'my-debounced',
            const Duration(milliseconds: 500),
            () => Utils.open1to1Chat(
                MyHive.getUser()?.firebaseKey ?? '', senderId, Get.context!));
      }
    });
  }

  void initialise() {
    registerNotification();
  }
}
