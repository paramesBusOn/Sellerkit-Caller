import 'dart:async';
import 'dart:developer';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/src/pages/dasboard/screens/dashboardPage.dart';

import 'helpers/helper.dart';

class MessagingService {
  //   final BuildContext context;
  // MessagingService(this.context);

  static String? fcmToken; // Variable to store the FCM token

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    //  Timer.periodic(const Duration(seconds: 15), (timer) {
    //   for (int i = 0; i < 1000000; i++) {
    //     print(i);
    //   }
    // });
    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          // final screen = notificationData['NaviScreen'];
          if (notificationData['NaviScreen'].toString().contains('Add Enq')) {
            await HelperFunctions.saveNavigationCountSharedPreference('true');

            Get.offAllNamed(ConstantRoutes.newEnqpage, arguments: [
              {"Mobile": '${message.notification!.body}'},
              {"Screen": 'Add Enquiry'}
            ]);
          } else if (notificationData['NaviScreen']
              .toString()
              .contains('Analy')) {
            await HelperFunctions.saveNavigationCountSharedPreference('true');

            Get.offAllNamed(ConstantRoutes.dashboard, arguments: [
              {"Mobile": '${message.notification!.body}'},
              {"Screen": 'Analyse'}
            ]);
            // DashboardController.mobileno =
            //     message.notification!.body.toString();
          } else if (notificationData['NaviScreen']
              .toString()
              .contains('Add Cus')) {
            await HelperFunctions.saveNavigationCountSharedPreference('true');

            Get.offAllNamed(ConstantRoutes.newCustomer, arguments: [
              {"Mobile": '${message.notification!.body}'},
              {"Screen": 'Add Contact'}
            ]);
            // DashboardController.mobileno =
            //     message.notification!.body.toString();
          }
          DashboardPageState.test = 'AAAA';
        }
      }
    });

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // if (message.notification != null) {
  //   final notificationData = message.data;
  //
  //   if (notificationData['NaviScreen'].toString().contains('Anal')) {
  //     await HelperFunctions.saveNavigationCountSharedPreference('true');
  //
  //     Get.offAllNamed(ConstantRoutes.newEnqpage, arguments: [
  //       {"Mobile": '${message.notification!.body}'},
  //       {"Screen": 'Analyse'}
  //     ]);
  //   }
  // }
  // await LaunchApp.openApp(
  //   androidPackageName: 'com.example.sellerkitcallerdashboard',
  // iosUrlScheme: 'pulsesecure://',
  // appStoreLink:
  //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
  // openStore: false
  // );
  // Get.offAllNamed(ConstantRoutes.callnotification);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
}
