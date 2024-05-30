import 'dart:developer';
import 'dart:io';

//import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/encripted.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/locationDetected/LocationTrack.dart';
import 'package:sellerkitcalllog/helpers/locationDetected/LocationTrackIos.dart';
import 'package:sellerkitcalllog/helpers/nativeCode-java-swift/methodchannel.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/api/loginApi/loginApiNew.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBHelper.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBOperation.dart';
import 'package:sellerkitcalllog/src/dBModel/AuthorizationDB.dart';
import 'package:sqflite/sqflite.dart';

class SplashController extends ChangeNotifier {
  Config config = Config();
  PostLoginData postLoginData = PostLoginData();

  becameAClient(BuildContext context) {
    config.msgDialog(
        context, "Please contact our support team..!!", "support@buson.in");
  }

  loginClicked() async {
    bool result = await GetAppAvailabilityStatus.isAppInstalled(
        'com.busondigitalservice.sellerkit');
    if (result == true) {
      Get.offAllNamed(ConstantRoutes.loginwithSellerkit);
    } else {}
  }

  setURL() async {
    String? getUrl = await HelperFunctions.getHostDSP();
    log("getUrl $getUrl");
    Utils.queryApi = 'http://${getUrl.toString()}/api/';
  }

  Future<void> checkPlatFrom() async {
    if (Platform.isAndroid) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  String geturlview = '';
  String deviceIDview = '';
  String licenseKeyview = '';
  String userCodeview = '';
  String passswordview = '';
  String tokenview = '';
  String isLoggedInview = '';
  String modelview = '';
  String brandview = '';
  Future<void> checkBeforeLoginApi(BuildContext context) async {
    await checkPlatFrom();

    String? getUrl = await HelperFunctions.getHostDSP();
    Utils.userNamePM = await HelperFunctions.getUserName();

    Utils.queryApi = 'http://${getUrl.toString()}/api/';
    geturlview = getUrl.toString();
    String? deviceID = await HelperFunctions.getDeviceIDSharedPreference();
    deviceIDview = deviceID.toString();
    String? licenseKey = await HelperFunctions.getLicenseKeySharedPreference();
    licenseKeyview = licenseKey.toString();
    String? userCode =
        await HelperFunctions.getLogginUserCodeSharedPreference();
    userCodeview = userCode.toString();
    String? passsword = await HelperFunctions.getPasswordSharedPreference();
    passswordview = passsword.toString();
    Utils.tenetID =
        (await HelperFunctions.getTenetIDSharedPreference()).toString();

    bool? isLoggedIn = await HelperFunctions.getUserLoggedInSharedPreference();
    isLoggedInview = isLoggedIn.toString();
    String token = (await config.getToken())!;
    tokenview = token;
    await HelperFunctions.saveFCMTokenSharedPreference(token);
    print("FCm Token:" + token.toString());
    postLoginData.deviceCode = deviceID;
    postLoginData.licenseKey = licenseKey;
    postLoginData.username = userCode;
    postLoginData.fcmToken = token;
    postLoginData.password = passsword;
    String? model = await Config.getdeviceModel();
    String? brand = await Config.getdeviceBrand();
    modelview = model.toString();
    brandview = brand.toString();
    postLoginData.tenantId = Utils.tenetID;
    postLoginData.langtitude = Utils.langtitude;
    postLoginData.latitude = Utils.latitude;
    postLoginData.ipName = Utils.ipname;
    postLoginData.ipaddress = Utils.ipaddress;

    postLoginData.devicename = '$brand $model';

    if (deviceID == null) {
      deviceID = await Config.getdeviceId();

      await HelperFunctions.saveDeviceIDSharedPreference(deviceID!);

      checkLicenseKey(getUrl, isLoggedIn);
    } else {
      checkLicenseKey(getUrl, isLoggedIn);
    }
  }

  checkLicenseKey(String? URL, bool? isLoggedIn) async {
    String? gettoken = await HelperFunctions.getTokenSharedPreference();

    if (URL == null && gettoken == null) {
      bool result = await GetAppAvailabilityStatus.isAppInstalled(
          'com.busondigitalservice.sellerkit');
      if (result == true) {
        Get.offAllNamed(ConstantRoutes.loginwithSellerkit);
      } else {
        Get.offAllNamed(ConstantRoutes.login);
      }
      // Get.offAllNamed(ConstantRoutes.loginwithSellerkit);
    } else if (URL != null || gettoken != null) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        isLoading = false;
        exceptionOnApiCall = 'Please Check Internet Connection..!!';
      } else {
        callLoginApi();
      }
    }
  }

  String exceptionOnApiCall = '';
  String get getexceptionOnApiCall => exceptionOnApiCall;
  bool isLoading = true;
  bool get getisLoading => isLoading;

  callLoginApi([String? pageName, int? docEntry]) async {
    await checkLoc();
    String meth = ConstantApiUrl.loginapi;
    await LoginPostApi.getData(postLoginData, meth).then((value) async {
      if (value.resCode! >= 200 && value.resCode! <= 210) {
        if (value.loginstatus!.toLowerCase().contains('success') &&
            value.data != null) {
          await getloginDetails(value);
        } else if (value.loginstatus!.toLowerCase().contains("failed") &&
            value.data == null) {
          isLoading = false;
          exceptionOnApiCall = value.loginMsg!;
          notifyListeners();
        }
      } else if (value.resCode! >= 400 && value.resCode! <= 410) {
        isLoading = false;
        exceptionOnApiCall = value.excep!;
        notifyListeners();
      } else {
        if (value.excep == 'No route to host') {
          isLoading = false;
          isLoading = false;
          exceptionOnApiCall = "Check your internet connectivity..!!";
        } else {
          isLoading = false;
          isLoading = false;
          exceptionOnApiCall =
              "${value.resCode!}..!!Network Issue..\nTry again Later..!!";
        }
        notifyListeners();
      }
    });
  }

  getloginDetails(LoginPostApi value) async {
    final Database db = (await DBHelper.getInstance())!;
    await DBOperation.truncateLoginVerficationDB(db);
    // DashBoardController.isLogout = false;
    await HelperFunctions.saveLicenseKeySharedPreference(
        value.data!.licenseKey);
    await HelperFunctions.saveFSTNameSharedPreference(value.data!.urlColumn);
    await HelperFunctions.saveTenetIDSharedPreference(value.data!.tenantId);
    await HelperFunctions.saveUserIDSharedPreference(value.data!.UserID);
    Utils.userId = value.data!.UserID;
    Utils.usercode = value.data!.userCode;
    Utils.storeid = int.parse(value.data!.storeid.toString());
    Utils.storecode = value.data!.storecode.toString();
    await HelperFunctions.saveUserLoggedInSharedPreference(true);
    await HelperFunctions.getFSTNameSharedPreference().then((value) {
      if (value != null) {
        Utils.firstName = value;

        notifyListeners();
      }
    });

    await HelperFunctions.savedbUserName(value.data!.UserID);

    await HelperFunctions.saveUserType(value.data!.userType);
    await HelperFunctions.saveSlpCode(value.data!.slpcode);

    List<LoginVerificationList>? loginVerifiList2 = [];
    List<VerificationData> values = [];
    loginVerifiList2 = value.loginVerifiList;

    if (loginVerifiList2 != null && loginVerifiList2!.isNotEmpty) {
      for (int i = 0; i < loginVerifiList2!.length; i++) {
        values.add(VerificationData(
            id: loginVerifiList2[i].id,
            code: loginVerifiList2[i].code,
            restrictionData: loginVerifiList2[i].restrictionData,
            restrictionType: loginVerifiList2[i].restrictionType,
            remarks: loginVerifiList2[i].remarks));
      }
    }

    await DBOperation.insertLoginVerifiDetails(values, db);
    if (loginVerifiList2 != null && loginVerifiList2.isNotEmpty) {
      await checkLoginVerification();
    } else {
      // String? temp = await HelperFunctions.getNaviCountSharedPreference();
      // if (temp == "false" || temp == null) {
        Get.offAllNamed(ConstantRoutes.download);
      // }
    }
    notifyListeners();
  }

  checkLoginVerification() async {
    final Database db = (await DBHelper.getInstance())!;

    String? getUrl = await HelperFunctions.getHostDSP();
    if (getUrl != null && getUrl != 'null' && getUrl != '') {
      List<Map<String, Object?>> VerificationDataDBData =
          await DBOperation.getLoginVerifiDBData(db);
      if (VerificationDataDBData.isNotEmpty) {
        bool anyConditionSatisfied = false;

        for (int i = 0; i < VerificationDataDBData.length; i++) {
          if (VerificationDataDBData[i]['RestrictionType'].toString() == '1') {
            if (VerificationDataDBData[i]['RestrictionData'].toString() ==
                Utils.ipaddress) {
              anyConditionSatisfied = true;
              break;
            }
          } else if (VerificationDataDBData[i]['RestrictionType'].toString() ==
              '2') {
            if (Platform.isAndroid) {
              await LocationTrack.determinePosition();
            } else {
              await LocationTrack2.determinePosition();
            }
            List<String>? locatoindetals = await getLocation(
                VerificationDataDBData[i]['RestrictionData'].toString());

            double totaldis = calculateDistance2(
                double.parse(locatoindetals[0]),
                double.parse(locatoindetals[1]),
                double.parse(Utils.latitude.toString()),
                double.parse(Utils.langtitude.toString()));
            int apiDis = int.parse(locatoindetals[2].toString());
            if (totaldis < apiDis.toDouble()) {
              anyConditionSatisfied = true;
              break;
            }
          } else if (VerificationDataDBData[i]['RestrictionType'].toString() ==
              '3') {
            String ipname = Utils.ipname.replaceAll('"', '');
            if (VerificationDataDBData[i]['RestrictionData'].toString() ==
                ipname.toString()) {
              anyConditionSatisfied = true;
              break;
            }
          }
        }

        if (!anyConditionSatisfied) {
          Get.offAllNamed(ConstantRoutes.restrictionValue);
        } else {
          Get.offAllNamed(ConstantRoutes.download);
        }
      }
    }
  }

  checkLoc() async {
    if (Platform.isAndroid) {
      await LocationTrack.determinePosition();
    } else {
      await LocationTrack2.determinePosition();
    }

    await Future.delayed(Duration(seconds: 3));
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result.name == 'none') {
        Utils.ipaddress = '';
        Utils.ipname = '';
      } else if (result.name == 'mobile') {
        if (Platform.isAndroid) {
          final MobileNetworkInfo mobileNetworkInfo = MobileNetworkInfo();
          final String? name = await Config.getipaddress();

          final String? data = await mobileNetworkInfo.getMobileNetworkName();

          Utils.ipaddress = name == null ? 'null' : name;
          Utils.ipname = data == null ? 'null' : data;
        } else if (Platform.isIOS) {
          List<String>? wifiiInfo = await config.getIosNetworkInfo();
          Utils.ipaddress = wifiiInfo[1];
          Utils.ipname = wifiiInfo[0];
        }
      } else if (result.name == 'wifi') {
        String? name = await Config.getipaddress();
        List<String>? wifiiInfo = await config.setNetwork();
        Utils.ipaddress = name ?? 'null';
        Utils.ipname = wifiiInfo[0];
      }
      Utils.latitude =
          LocationTrack.lat.isEmpty ? "${Utils.latitude}" : LocationTrack.lat;
      Utils.langtitude = LocationTrack.long.isEmpty
          ? "${Utils.langtitude}"
          : LocationTrack.long;

      if (Utils.langtitude!.isEmpty || Utils.langtitude == '') {
        Utils.langtitude = '0.000';
      }
      if (Utils.latitude!.isEmpty || Utils.latitude == '') {
        Utils.latitude = '0.000';
      }
      Utils.headerSetup =
          "${Utils.latitude};${Utils.langtitude};${Utils.ipname};${Utils.ipaddress}";

      EncryptData enc = EncryptData();
      String? encryValue = enc.encryptAES("${Utils.headerSetup}");

      Utils.encryptedSetup = encryValue;
    });
  }
}
