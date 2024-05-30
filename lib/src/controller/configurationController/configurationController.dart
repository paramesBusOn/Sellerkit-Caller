import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/src/api/loginApi/loginApiNew.dart';
import 'package:sellerkitcalllog/src/pages/dasboard/widgets/authorizeSucessBox.dart';
import 'package:upgrader/upgrader.dart';
import 'package:html/dom.dart';

class ConfigurationController extends ChangeNotifier {
  ConfigurationController(BuildContext context) {
    // initializeService();
    if (Utils.network != 'none') {
      initDynamicLink(context);
    }
  }

  Future<void> initDynamicLink(BuildContext context) async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    try {
      if (initialLink != null) {
        // &username=$username&password=$password&usercode=$userCode&userid=$userId&mainurl=$mainURl&tentid=$tentId&licencekey=$licencekey"
        String authorizeId = '';

        authorizeId =
            initialLink.link.queryParameters['authorizedtoken'].toString();
        String mainUrl = initialLink.link.queryParameters['mainurl'].toString();
        String username =
            initialLink.link.queryParameters['username'].toString();
        String licencekey =
            initialLink.link.queryParameters['licencekey'].toString();
        String password =
            initialLink.link.queryParameters['password'].toString();
        String tenetId = initialLink.link.queryParameters['tentid'].toString();
        Utils.userId = initialLink.link.queryParameters['userid'].toString();
        String firstname =
            initialLink.link.queryParameters['firstname'].toString();

        //
        await HelperFunctions.saveLogginUserCodeSharedPreference(username); //
        await HelperFunctions.saveHostSP(mainUrl);
        await HelperFunctions.saveTokenSharedPreference(authorizeId);
        // await HelperFunctions.saveUserName(username);
        await HelperFunctions.saveLicenseKeySharedPreference(licencekey);
        await HelperFunctions.savePasswordSharedPreference(password);
        await HelperFunctions.saveTenetIDSharedPreference(tenetId);
        await HelperFunctions.saveFSTNameSharedPreference(firstname);

        //
        String? getToken = await HelperFunctions.getTokenSharedPreference();
        Utils.token = getToken;
        String? usercode = await HelperFunctions.getUserName();
        Utils.userNamePM = usercode;
        await HelperFunctions.getFSTNameSharedPreference().then((value) {
          if (value != null) {
            Utils.firstName = value;
          }
        });

        await showDialog<dynamic>(
            barrierDismissible: true,
            context: context,
            builder: (_) {
              return const AuthroizationSucessAlertBox();
            }).then((value) {}).then((value) {
          notifyListeners();
        }).then((value) {});
      } else {
        validateAppLogin();
        // validatelogin();
      }
    } catch (e) {
      debugPrint('No deepLink found');
    }
    notifyListeners();
  }

//
  PostLoginData postLoginData = PostLoginData();
  //fcm
  String token = '';
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getStoreVersion(String myAppBundleId) async {
    String? storeVersion;
    if (Platform.isAndroid) {
      PlayStoreSearchAPI playStoreSearchAPI = PlayStoreSearchAPI();
      Document? result2 =
          await playStoreSearchAPI.lookupById(myAppBundleId, country: 'IN');
      if (result2 != null) storeVersion = playStoreSearchAPI.version(result2);
    } else if (Platform.isIOS) {
      ITunesSearchAPI iTunesSearchAPI = ITunesSearchAPI();
      Map<dynamic, dynamic>? result =
          await iTunesSearchAPI.lookupByBundleId(myAppBundleId, country: 'IN');
      if (result != null) storeVersion = iTunesSearchAPI.version(result);
    } else {
      storeVersion = null;
    }
    return storeVersion;
  }

  Future<void> showVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Utils.appversion = packageInfo.version;

    notifyListeners();
  }

  Future<String?> getToken() async {
    return await firebaseMessaging.getToken();
  }

  checkStartingPage(
    String? pageName,
  ) async {
    bool? value = await HelperFunctions.getOnBoardSharedPreference();
    print(value);
    // String? temp = await HelperFunctions.getNaviCountSharedPreference();
    // if (temp == 'false'||temp==null) {
      if (value == true) {
        Get.offAllNamed(ConstantRoutes.splash);
      } else {
        Get.offAllNamed(ConstantRoutes.onBoard);
      }
    // }
    }

  double calculateDistance2(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742000 * asin(sqrt(a));
  }

  Future<List<String>> getLocation(String restricdata) async {
    String split1 = restricdata;
    List<String>? clist = split1.split(",");

    return clist;
  }

  Config config = Config();

  Future<List<String>> setNetwork() async {
    final info = NetworkInfo();

    List<String>? wifiinfo = ["", ""];
    var locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      // await Permission.locationWhenInUse.request();
      if (Platform.isAndroid) {
        await Permission.location.request();
      }
      //await Permission.locationAlways.request();
    }
    if (locationStatus.isGranted) {
      print("network2");
      // await Permission.locationWhenInUse.request();
      await HelperFunctions.saveLocationSharedPref('true');
      //await Permission.locationAlways.request();
    }

    if (await Permission.location.isRestricted) {
      // openAppSettings();
    }
    if (locationStatus.isPermanentlyDenied) {
      // openAppSettings();
    }

    wifiinfo[0] =
        await info.getWifiName() == null ? '' : (await info.getWifiName())!;
    wifiinfo[1] =
        await info.getWifiIP() == null ? '0' : (await info.getWifiIP())!;
    // var wifiName = await info.getWifiIP();

    return wifiinfo;
  }

  String? pagename;
  String? mobileno;

  validateAppLogin() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          final screen = notificationData['NaviScreen'];

          if (notificationData['NaviScreen'].toString().contains('Add Enq')) {
            pagename = 'Add Enquiry';
            mobileno = message.notification!.body.toString();

            // Get.offAllNamed(ConstantRoutes.newEnqpage,
            //     arguments: message.notification!.body);
          } else if (notificationData['NaviScreen']
              .toString()
              .contains('Dashboard')) {
            pagename = 'Dashboard';
            mobileno = message.notification!.body.toString();

            // Get.offAllNamed(ConstantRoutes.dashboard,
            //     arguments: message.notification!.body);
            // DashboardController.mobileno =
            //     message.notification!.body.toString();
          }
        }

        await checkLogin(pagename, mobileno);
      }
    });
    showVersion();
    String? storeversion =
        await getStoreVersion('com.busondigitalservice.sellerkit');

    checkStartingPage(pagename);
  }

  checkLogin(String? pageName, String? docEntry) async {
    PostLoginData postLoginData = PostLoginData();

    String? getUrl = await HelperFunctions.getHostDSP();
    // Utils.userNamePM = await HelperFunctions.getUserName();
    // log("getUrl $getUrl");
    // log("userNamePM ${Utils.userNamePM}");

    Utils.queryApi = 'http://${getUrl.toString()}/api/';
    String? deviceID = await HelperFunctions.getDeviceIDSharedPreference();
    String? licenseKey = await HelperFunctions.getLicenseKeySharedPreference();
    String? userCode =
        await HelperFunctions.getLogginUserCodeSharedPreference();
    String? passsword = await HelperFunctions.getPasswordSharedPreference();
    Utils.tenetID =
        (await HelperFunctions.getTenetIDSharedPreference()).toString();
    String token = (await getToken())!;
    String? firstname = await HelperFunctions.getUserName();
    Utils.firstName = firstname;
    postLoginData.deviceCode = deviceID;
    postLoginData.licenseKey = licenseKey;
    postLoginData.username = userCode;
    postLoginData.fcmToken = token;
    postLoginData.password = passsword;
    String? model = await Config.getdeviceModel();
    String? brand = await Config.getdeviceBrand();
    postLoginData.devicename = '$brand $model';

    callLoginApi2(postLoginData, pageName, docEntry);
  }

  callLoginApi2(PostLoginData postLoginData,
      [String? pageName, String? docEntry]) async {
    String meth = ConstantApiUrl.loginapi;
    await LoginPostApi.getData(postLoginData, meth).then((value) async {
      if (value.resCode! >= 200 && value.resCode! <= 210) {
        if (value.loginstatus!.toLowerCase().contains('success') &&
            value.data != null) {
          // DashBoardController.isLogout = false;
          await HelperFunctions.saveLicenseKeySharedPreference(
              value.data!.licenseKey);
          // await HelperFunctions.saveSapUrlSharedPreference(
          //     value.data!.endPointUrl);
          await HelperFunctions.saveTenetIDSharedPreference(
              value.data!.tenantId);
          await HelperFunctions.saveUserName(value.data!.userCode);
          await HelperFunctions.saveFSTNameSharedPreference(
              value.data!.urlColumn);
          await HelperFunctions.saveUserIDSharedPreference(value.data!.UserID);
          Utils.userId = value.data!.UserID;
          Utils.usercode = value.data!.userCode;
          Utils.storeid = int.parse(value.data!.storeid.toString());
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.getFSTNameSharedPreference().then((value) {
            if (value != null) {
              Utils.firstName = value;
            }
          });

          // await HelperFunctions.saveuserDB(value.data!.userDB);
          await HelperFunctions.savedbUserName(value.data!.UserID);
          //   await HelperFunctions.savedbPassword(value.data!.dbPassword);

          await HelperFunctions.saveUserType(value.data!.userType);
          await HelperFunctions.saveSlpCode(value.data!.slpcode);
          String? firstname = await HelperFunctions.getUserName();
          Utils.userNamePM = firstname;
          await checkPage(pageName, docEntry);
        } else if (value.loginstatus!.toLowerCase().contains("failed") &&
            value.data == null) {}
      } else if (value.resCode! >= 400 && value.resCode! <= 410) {
      } else {
        if (value.excep == 'No route to host') {
        } else {}
      }
    });
  }

  checkPage(String? pageName, String? docEntry) {
    if (pageName != null && docEntry != null) {
      if (pageName.contains('Add Enq')) {
        Get.offAllNamed(ConstantRoutes.newEnqpage, arguments: docEntry);
      }
    } else if (pagename!.contains("Dashboard")) {
      Get.offAllNamed(ConstantRoutes.dashboard, arguments: docEntry);
    }
  }
}
