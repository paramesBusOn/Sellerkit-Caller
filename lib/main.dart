import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/allRoutes.dart';
import 'package:sellerkitcalllog/helpers/background_service_helper/flutter_background_service_utils.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/encripted.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/locationDetected/LocationTrack.dart';
import 'package:sellerkitcalllog/helpers/locationDetected/LocationTrackIos.dart';
import 'package:sellerkitcalllog/helpers/nativeCode-java-swift/methodchannel.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/messaging%20Service.dart';
import 'package:sellerkitcalllog/providers/locale_provider.dart';
import 'package:sellerkitcalllog/src/api/dynamicLinkApi/dynamiclinkCreateSelf.dart';
import 'package:sellerkitcalllog/src/controller/addCustomerController/addCustomerController.dart';
import 'package:sellerkitcalllog/src/controller/dashboardController/dashboardController.dart';
import 'package:sellerkitcalllog/src/controller/callNotificationController/callNotificationController.dart';
import 'package:sellerkitcalllog/src/controller/configurationController/configurationController.dart';
import 'package:sellerkitcalllog/src/controller/downLoadController/downloadController.dart';
import 'package:sellerkitcalllog/src/controller/enquiryController/enquiryController.dart';
import 'package:sellerkitcalllog/src/controller/loginwithSellerkitController/loginwithSellerkitController.dart';
import 'package:sellerkitcalllog/src/controller/splashController/splashController.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBHelper.dart';
import 'package:sellerkitcalllog/src/pages/Configuration/screens/ConfigurationPage.dart';
import 'package:sellerkitcalllog/src/pages/callerNotification/custom_overlayNew.dart';
import 'package:sellerkitcalllog/themes/theme_manager.dart';
import 'package:sellerkitcalllog/themes/themes_const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:system_alert_window/system_alert_window.dart';
import 'helpers/constans.dart';
import 'src/controller/callLogController/callLogController.dart';
import 'src/dBModel/NotificationModel.dart';
import 'package:timezone/data/latest.dart' as tzdata;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();

  await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// //
//   var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   var initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettingsIOs = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {});
//   var initSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

//   void onDidReceiveNotificationResponse(
//     NotificationResponse notificationResponse,
//   ) async {
//     print("payload: " + notificationResponse.payload.toString());
//     Get.toNamed(ConstantRoutes.callnotification);
//   }

//   await flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//   );

  // onReciveFCM();
  await getPermissionUser();
  await checkLocation();
  // requestPermission();
  onStart();
  String sattus = '';
  // SomeClass.printer();
  //
  // Connectivity()
  //     .onConnectivityChanged
  //     .listen((ConnectivityResult result) async {
  //       if(result.name=='none'){
  //         sattus='none';
  //         // NetChecking.statusName('none');
  //         // SomeClass someClass = SomeClass(() => 'none');
  //         print("network none");
  //       }else{
  //         // NetChecking.statusName('');
  //         // SomeClass someClass = SomeClass(() => '');
  //
  //         print("network else");
  //
  //       }
  // });
  await createDB();

  await FlutterOverlayWindow.isPermissionGranted();
  runApp(MyApp(networkStatus: sattus));
}

getalarm() {
  var alarmPlugin = FlutterAlarmBackgroundTrigger();
  alarmPlugin.requestPermission().then((isGranted) {
    if (isGranted) {
      alarmPlugin.onForegroundAlarmEventHandler((alarm) {
        Get.offAllNamed(ConstantRoutes.callnotification);
      });
    }
  });
}

String _platformVersion = 'Unknown';
SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
String _mainAppPort = 'MainApp';
final _receivePort = ReceivePort();
SendPort? homePort;
String? latestMessageFromOverlay;

isolatemethod() {
  if (homePort != null) return;
  final res = IsolateNameServer.registerPortWithName(
    _receivePort.sendPort,
    _mainAppPort,
  );
  print("$res: OVERLAY");
  _receivePort.listen((message) async {
    print("message from OVERLAY: $message");
    if (message.toString().contains('Enqui')) {
      // await AppAvailability.launchApp('com.company_name.app_name');
      // final Uri toLaunch = Uri(
      //     scheme: 'https',
      //     host: 'sellerkitcallerdsahboard.page.link',
      //     path: 'headers/');

      // config.launchInBrowser(toLaunch);
      // SystemAlertWindow.closeSystemWindow(prefMode: prefMode);

      // var openAppResult = await LaunchApp.openApp(
      //   androidPackageName: 'com.example.sellerkitcallerdashboard',
      // iosUrlScheme: 'pulsesecure://',
      // appStoreLink:
      //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
      // openStore: false
      // ).then((value) {
      //   // Get.offAllNamed(ConstantRoutes.callnotification);
      // });

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => testpage()),
      //   );
      // });
      DynamicLinkSelfCreateApi.getDynamicLinkCreateApiData('Add enquiry')
          .then((value) async {
        if (value.dynamiclinkData != null &&
            value.dynamiclinkData!.shortlink!.isNotEmpty) {
          if (value.dynamiclinkData!.shortlink!.isNotEmpty) {
            if (!await launchUrl(Uri.parse(value.dynamiclinkData!.shortlink!),
                mode: LaunchMode.externalNonBrowserApplication)) {
              throw 'Could not launch ${value.dynamiclinkData!.shortlink!}';
            }
          }
        }
      }).then((value) {});
    }
  });
}

onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await startMonitoringService();
}

@pragma("vm:entry-point")
void overlayMain() async {
  // debugPrint("Starting Alerting Window Isolate!");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  onStart();
  // await createDB();
  runApp(const Overlay());
}

class Overlay extends StatefulWidget {
  const Overlay({
    super.key,
  });

  @override
  State<Overlay> createState() => _OverlayState();
}

class _OverlayState extends State<Overlay> {
  // final _messagingService = MessagingService();
  @override
  void initState() {
    // _messagingService.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        key: navigatorKey,
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeManager()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(
              create: (_) => LoginwithSellerkitContoller(context)),
          ChangeNotifierProvider(create: (_) => DashboardController()),
          ChangeNotifierProvider(create: (_) => SplashController()),
          ChangeNotifierProvider(create: (_) => DownLoadController()),
          ChangeNotifierProvider(
              create: (_) => ConfigurationController(context)),
          ChangeNotifierProvider(create: (_) => CallNotificationController()),
        ],
        child: Consumer2<LocaleProvider, ThemeManager>(
            builder: (context, locale2, themes, Widget? child) {
          return GetMaterialApp(
              theme: themes.selectedTheme == 'merron'
                  ? merronTheme(context)
                  : themes.selectedTheme == 'blue'
                      ? blueTheme(context)
                      : orangeTheme(context),
              debugShowCheckedModeBanner: false,
              home: const CustomOverlayNew());
        }));
  }
}

// Future<bool> requestPermission() async {
//   await SystemAlertWindow.requestPermissions();
//   var status = await Permission.phone.request();

//   return switch (status) {
//     PermissionStatus.denied ||
//     PermissionStatus.restricted ||
//     PermissionStatus.limited ||
//     PermissionStatus.permanentlyDenied =>
//       false,
//     PermissionStatus.provisional || PermissionStatus.granted => true,
//   };
// }

Future myBackgroundMessageHandler() async {
  Future.delayed(const Duration(milliseconds: 200), () {
    Get.off(ConstantRoutes.callnotification);
  });
}

Config config = Config();
checkLocation() async {
  if (Platform.isAndroid) {
    await LocationTrack.determinePosition();
  } else {
    await LocationTrack2.determinePosition();
  }
  await Future.delayed(const Duration(seconds: 3));
  Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    // log("result:::" + result.name.toString());
    // Got a new connectivity status!
    if (result.name == 'none') {
      Utils.ipaddress = '';
      Utils.ipname = '';
    } else if (result.name == 'mobile') {
      if (Platform.isAndroid) {
        final MobileNetworkInfo mobileNetworkInfo = MobileNetworkInfo();
        final String name = await Config.getipaddress();

        // List<String>? wifiiInfo = await config.setNetwork();
        //
        // var ipAddress = IpAddress(type: RequestType.text);
        final String? data = await mobileNetworkInfo.getMobileNetworkName();
        // String data = await ipAddress.getIpAddress();

        Utils.ipaddress = name;
        Utils.ipname = data ?? 'null';
      } else if (Platform.isIOS) {
        List<String>? wifiiInfo = await config.getIosNetworkInfo();
        Utils.ipaddress = wifiiInfo[1];
        Utils.ipname = wifiiInfo[0];
      }
    }
    // else if (result.name == 'mobile') {
    //   List<String>? wifiiInfo = await config.s etNetwork();
    //   Utils.ipaddress = wifiiInfo[1] == null ? 'null' : wifiiInfo[1];
    //   Utils.ipname = wifiiInfo[0] == null ? 'null' : wifiiInfo[0];
    // }
    else if (result.name == 'wifi') {
      String? name = await Config.getipaddress();
      List<String>? wifiiInfo = await config.setNetwork();
      Utils.ipaddress = name;
      Utils.ipname = wifiiInfo[0];
    }
    Utils.latitude =
        LocationTrack.lat.isEmpty ? "${Utils.latitude}" : LocationTrack.lat;
    Utils.langtitude =
        LocationTrack.long.isEmpty ? "${Utils.langtitude}" : LocationTrack.long;
    //
    if (Utils.langtitude!.isEmpty || Utils.langtitude == '') {
      Utils.langtitude = '0.000';
    }
    if (Utils.latitude!.isEmpty || Utils.latitude == '') {
      Utils.latitude = '0.000';
    }
    Utils.headerSetup =
        "${Utils.latitude};${Utils.langtitude};${Utils.ipname};${Utils.ipaddress}";
    //
    EncryptData enc = EncryptData();
    String? encryValue = enc.encryptAES("${Utils.headerSetup}");
    // log("Encryped Location Header:::" + encryValue.toString());
    Utils.encryptedSetup = encryValue;
    // log("Utils.EncryptedSetup::" +
    //     Utils.EncryptedSetup.toString());
    //  await config.getSetup();
  });
  // await LocationTrack.checkcamlocation();
}

onReciveFCM() async {
  Config config = Config();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // GetAppAvailabilityStatus.isAppOpenBackground('com.example.sellerkitcallerdashboard');

    List<NotificationModel> notify = [];
    if (message.notification != null) {
      // else {
      // awa it localNotificationService.Shownoti(
      //   message: message,
      //   title: message.notification!.title ?? "",
      //   body: message.notification!.body ?? "",
      // );
      if (message.notification!.title!.contains('logout')) {
        if (int.parse(message.data['LogoutTypeId'].toString()) == 2 ||
            int.parse(message.data['LogoutTypeId'].toString()) == 4) {}
      } else if (message.notification!.title!.contains('callerapp')) {
        await Future.delayed(const Duration(seconds: 5));
        Get.offAllNamed(ConstantRoutes.callnotification);
      } else {
        if (message.notification!.android != null) {
          if (message.notification!.android!.imageUrl != null) {
            // log(message.data['DocEntry'].toString());
            // log(message.data['NaviScreen'].toString());

            notify.add(NotificationModel(
                jobid: int.parse(message.data['JobId'].toString()),
                docEntry: int.parse(message.data['DocEntry'].toString()),
                titile: message.notification!.title,
                description: message.notification!.body!,
                receiveTime: config.currentDate(),
                seenTime: '0',
                imgUrl: message.notification!.android!.imageUrl.toString(),
                naviScn: message.data['NaviScreen'].toString()));
            // DBOperation.insertNotification(notify, db);
          } else {
            // log(message.data['DocEntry'].toString());
            // log(message.data['NaviScreen'].toString());
            notify.add(NotificationModel(
                jobid: int.parse(message.data['JobId'].toString()),
                docEntry: message.data['DocEntry'] == null
                    ? 0
                    : int.parse(message.data['DocEntry'].toString()),
                titile: message.notification!.title,
                description: message.notification!.body!,
                receiveTime: config.currentDate(),
                seenTime: '0',
                imgUrl: 'null',
                naviScn: message.data['NaviScreen'].toString()));
            // DBOperation.insertNotification(notify, db);
          }
        } else {
          if (message.notification!.apple!.imageUrl != null) {
            // log(message.data['DocEntry'].toString());
            // log("message.data['NaviScreen'].toString()::" +
            //     message.notification!.apple!.imageUrl.toString());
            notify.add(NotificationModel(
                jobid: int.parse(message.data['JobId'].toString()),
                docEntry: int.parse(message.data['DocEntry'].toString()),
                titile: message.notification!.title,
                description: message.notification!.body!,
                receiveTime: config.currentDate(),
                seenTime: '0',
                imgUrl: message.notification!.apple!.imageUrl.toString(),
                naviScn: message.data['NaviScreen'].toString()));
            // DBOperation.insertNotification(notify, db);
          } else {
            // log(message.data['DocEntry'].toString());
            // log(message.data['NaviScreen'].toString());
            notify.add(NotificationModel(
                jobid: int.parse(message.data['JobId'].toString()),
                docEntry: int.parse(message.data['DocEntry'].toString()),
                titile: message.notification!.title,
                description: message.notification!.body!,
                receiveTime: config.currentDate(),
                seenTime: '0',
                imgUrl: 'null',
                naviScn: message.data['NaviScreen'].toString()));
            // DBOperation.insertNotification(notify, db);
          }
        }
      }
      // }
    }
  });
}

Future createDB() async {
  await DBHelper.getInstance().then((value) {
    print("Created...");
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await createDB();
  Config config = Config();
  List<NotificationModel> notify = [];
  if (message.notification != null) {
    if (message.notification!.title!.contains('logout')) {
      // exit(0);
    } else if (message.notification!.title!.contains('callerapp')) {
      GetAppAvailabilityStatus.isAppInstalled(
          'com.example.sellerkitcallerdashboard');
      await LaunchApp.openApp(
        androidPackageName: 'com.example.sellerkitcallerdashboard',
        iosUrlScheme: 'pulsesecure://',
        appStoreLink:
            'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
        // openStore: false
      ).then((value) async {
        // await Future.delayed(Duration(seconds: 5));
        // Get.offAllNamed(ConstantRoutes.callnotification);
        // Get.dialog(
        //     barrierDismissible: false,
        //     Dialog(
        //       backgroundColor: Colors.transparent,
        //       child: WillPopScope(
        //         onWillPop: () async => false,
        //         child: Container(
        //           padding: EdgeInsets.all(10),
        //           decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(20)),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Center(
        //                 child: Text("No Internet Connection"),
        //               ),
        //               SizedBox(
        //                 height: 10,
        //               ),
        //               // Image.asset(AppImage.internetConnection, height: 30),
        //               Padding(
        //                 padding: EdgeInsets.symmetric(horizontal: 10),
        //                 child: Text(
        //                   "Please check your connection again,or connect to wi-fi.",
        //                 ),
        //               ),
        //               Divider(
        //                 color: Colors.grey,
        //                 thickness: 1,
        //               ),
        //               GestureDetector(
        //                 onTap: () {
        //                   Get.toNamed(ConstantRoutes.callnotification);
        //                 },
        //                 child: Center(
        //                   child: Container(
        //                     height: 50,
        //                     width: 30,
        //                     alignment: Alignment.center,
        //                     decoration: const BoxDecoration(
        //                         color: Colors.white,
        //                         borderRadius:
        //                             BorderRadius.all(Radius.circular(10))),
        //                     child: const Text(
        //                       "Refresh",
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ));
      });
    } else {
      if (message.notification!.android != null) {
        if (message.notification!.android!.imageUrl != null) {
          notify.add(NotificationModel(
              jobid: int.parse(message.data['JobId'].toString()),
              docEntry: int.parse(message.data['DocEntry'].toString()),
              titile: message.notification!.title,
              description: message.notification!.body!,
              receiveTime: config.currentDate(),
              seenTime: '0',
              imgUrl: message.notification!.android!.imageUrl.toString(),
              naviScn: message.data['NaviScreen'].toString()));
          // await DBOperation.insertNotification(notify, db);
        } else {
          notify.add(NotificationModel(
              jobid: int.parse(message.data['JobId'].toString()),
              docEntry: int.parse(message.data['DocEntry'].toString()),
              titile: message.notification!.title,
              description: message.notification!.body!,
              receiveTime: config.currentDate(),
              seenTime: '0',
              imgUrl: 'null',
              naviScn: message.data['NaviScreen'].toString()));
          // await DBOperation.insertNotification(notify, db);
        }
      } else {
        if (message.notification!.apple!.imageUrl != null) {
          notify.add(NotificationModel(
              jobid: int.parse(message.data['JobId'].toString()),
              docEntry: int.parse(message.data['DocEntry'].toString()),
              titile: message.notification!.title,
              description: message.notification!.body!,
              receiveTime: config.currentDate(),
              seenTime: '0',
              imgUrl: message.notification!.android!.imageUrl.toString(),
              naviScn: message.data['NaviScreen'].toString()));
          // await DBOperation.insertNotification(notify, db);
        } else {
          notify.add(NotificationModel(
              jobid: int.parse(message.data['JobId'].toString()),
              docEntry: int.parse(message.data['DocEntry'].toString()),
              titile: message.notification!.title,
              description: message.notification!.body!,
              receiveTime: config.currentDate(),
              seenTime: '0',
              imgUrl: 'null',
              naviScn: message.data['NaviScreen'].toString()));
          // await DBOperation.insertNotification(notify, db);
        }
      }
    }
  }
}

Future<List<String>> getLocation(String restricdata) async {
  String split1 = restricdata;
  List<String>? clist = split1.split(",");

  return clist;
}

double calculateDistance2(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742000 * asin(sqrt(a));
}

String? token = '';

Future getPermissionUser() async {
  if (await Permission.phone.request().isGranted) {
  } else {
    await Permission.phone.request();
  }
  if (await Permission.contacts.request().isGranted) {
  } else {
    await Permission.contacts.request();
  }
}

// OverlayScreen? overlayScreen;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> navigatorKey2 = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.networkStatus});
  final String networkStatus;
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _messagingService = MessagingService();
  @override
  void initState() {
    super.initState();

    setState(() {
      setUrlSetup();

      Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result.name == 'none') {
          if (!mounted) return;
          setState(() {
            Utils.network = 'none';
          });
          print("network none");
        } else {
          await Future.delayed(const Duration(seconds: 5));
          if (!mounted) return;
          setState(() {
            Utils.network = '';
          });
          print("network Online");
        }
      });
    });
    _initPlatformState();
    _requestPermissions();
  }

  setUrlSetup() async {
    _messagingService.init(context);

    // await HelperFunctions.saveNavigationCountSharedPreference('0');
    String? getUrl = await HelperFunctions.getHostDSP();
    if (getUrl == null) {
      setState(() {
        if (!mounted) return;
        Utils.queryApi = 'http://${getUrl.toString()}/api/';
      });
    }
  }

  @override
  void dispose() {
    SystemAlertWindow.removeOnClickListener();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    await SystemAlertWindow.enableLogs(true);
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SystemAlertWindow.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (platformVersion != null) {
      setState(() {
        _platformVersion = platformVersion!;
      });
    }
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      key: navigatorKey,
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
            create: (_) => LoginwithSellerkitContoller(context)),
        ChangeNotifierProvider(create: (context) => DashboardController()),
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => DownLoadController()),
        ChangeNotifierProvider(create: (_) => ConfigurationController(context)),
        ChangeNotifierProvider(create: (_) => CallNotificationController()),
        ChangeNotifierProvider(create: (_) => NewEnqController()),
        ChangeNotifierProvider(create: (_) => NewCustomerContoller()),
        ChangeNotifierProvider(create: (_) => CallLogController())
      ],
      child: Consumer2<LocaleProvider, ThemeManager>(
          builder: (context, locale2, themes, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Seller kit',
          theme:
              // themes.selectedTheme == 'merron'
              //     ?
              merronTheme(context)
          // : themes.selectedTheme == 'blue'
          //     ? blueTheme(context)
          //     : orangeTheme(context)
          ,
          home: const ConfigurationPage(),
          getPages: Routes.allRoutes,
          locale: locale2.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      }),
    );
  }
}

class NoInternet extends StatefulWidget {
  const NoInternet({super.key, required this.network});
  final String network;
  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _controller = AnimationController(
        vsync: this,
      );
      _controller.value = 0.5;

      connectivitycheck();
    });
  }

  connectivitycheck() async {
    await Future.delayed(const Duration(seconds: 5));

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result.name == 'none') {
        setState(() {
          _controller.stop();
        });
        print("network none");
      } else {
        setState(() {
          _controller.forward();
        });
        await Future.delayed(const Duration(seconds: 10));

        print("network Online Animation");
      }
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Lottie.asset(
                  fit: BoxFit.fill,
                  repeat: false,
                  controller: _controller,
                  Assets.networkCheck2,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                  reverse: true,

                  // repeat: false,
                  // animate: widget.network == 'none' ? false : true
                ),
                Positioned(
                  bottom: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No Internet Connection",
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: Screens.width(context),
                        // height: Screens.bodyheight(context),
                        child: Text(
                          "Please check your connection and try again.",
                          style: theme.textTheme.titleMedium!.copyWith(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
