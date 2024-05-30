// ignore_for_file: unnecessary_new, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks, unnecessary_brace_in_string_interps, unused_import, unused_local_variable, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors, prefer_if_null_operators, prefer_const_declarations, avoid_print, unnecessary_string_interpolations, unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:get/get.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/LocationDetected/LocationTrack.dart';
import 'package:sellerkitcalllog/helpers/LocationDetected/LocationTrackIos.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/encripted.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/nativeCode-java-swift/methodchannel.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/api/LoginApi/LoginApi.dart';
import 'package:sellerkitcalllog/src/api/LoginVerificationApi/LoginVerificationApi.dart';
import 'package:sellerkitcalllog/src/api/getURLApi/GetURLApi.dart';
import 'package:sellerkitcalllog/src/api/loginApi/loginApiNew.dart';
import 'package:sellerkitcalllog/src/dBHelper/DBHelper.dart';
import 'package:sellerkitcalllog/src/dBHelper/DBOperation.dart';
import 'package:sellerkitcalllog/src/dBModel/AuthorizationDB.dart';
import 'package:sellerkitcalllog/src/pages/Login/Widgets/AlreadyLoginDialog.dart';
import 'package:sellerkitcalllog/src/widgets/permissionAlertDialogbox.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class LoginController extends ChangeNotifier {
  LoginController(BuildContext context) {
    check(context);
  }
  LocationPermission? permission;
  bool? locationbool = false;
  bool? TCbool = false;

  bool? camerabool = false;
  bool? notificationbool = false;
  check(BuildContext context) async {
    // await checkLocation();

    final permission = Permission.notification;
    PermissionStatus status = await permission.status;

    var locationStatus = await Permission.location.status;
    // var cameraStatus = await Permission.camera.status;
    // var notifiStatus = await Permission.notification.status;

    print('location' + locationStatus.toString());
    // print('cameraStatus' + cameraStatus.toString());
    // print('notifiStatus2' + notifiStatus.toString());

    if (locationStatus.isGranted) {
      locationbool = true;
      notifyListeners();
    }
    // if (cameraStatus.isGranted) {
    //   camerabool = true;
    //   notifyListeners();
    // }
    // if (notifiStatus.isGranted) {
    //   notificationbool = true;
    //   notifyListeners();
    // }
    // if (Platform.isIOS) {
    if (locationbool == false
        // ||
        //     camerabool == false ||
        //     notificationbool == false
        ) {
      LocationPermission permission;

      await showDialog<dynamic>(
          context: context,
          builder: (_) {
            return PermissionShowDialog(
              locationbool: locationbool,
              camerabool: camerabool,
              notificationbool: notificationbool,
            );
          }).then((value) async {});
    }
    // }
    await getHost();
  }

  Config config = new Config();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<TextEditingController> mycontroller =
      List.generate(15, (i) => TextEditingController());
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkey2 = GlobalKey<FormState>();

  List<GlobalKey<FormState>> formkeytest =
      List.generate(15, (i) => GlobalKey<FormState>());
  bool hidePassword = true;
  bool isLoading = false;
  bool erroMsgVisble = false;
  bool settingError = false;

  String errorMsh = '';
  static bool loginPageScrn = false;

  bool get getHidepassword => hidePassword;
  bool get getIsLoading => isLoading;
  bool get geterroMsgVisble => erroMsgVisble;
  bool get getsettingError => settingError;

  String get getErrorMshg => errorMsh;

  void obsecure() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  showLoginDialog(BuildContext context) {
    config.msgDialog(context, '', '');
  }

  Future<void> getUrlApi() async {
    String? Url = "";
    //Get Url Api
    print("get Url Api call:" + mycontroller[3].text.toString());
    await GetURLApi.getData(
            ConstantApiUrl.getUrlapi(mycontroller[3].text.toString().trim()))
        .then((value) async {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.url != null) {
          Url = value.url;
          print("url method::" + Url.toString());
          await HelperFunctions.saveHostSP(Url!.trim());
          await HelperFunctions.saveTenetIDSharedPreference(
              mycontroller[3].text.toString().trim());
          setURL();
          errorMsh = "";
          erroMsgVisble = false;
          settingError = false;
          notifyListeners();
        } else {
          print("object1:" + value.exception.toString());
          erroMsgVisble = true;
          isLoading = false;
          errorMsh = value.exception.toString();
        }
      } else {
        if (value.exception == 'No route to host') {
          isLoading = false;
          erroMsgVisble = true;
          errorMsh = 'Check your Internet Connection...!!';
          notifyListeners();
        } else if (value.message == "Catch") {
          isLoading = false;
          erroMsgVisble = true;
          errorMsh = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }

  final firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> getToken() async {
    return await firebaseMessaging.getToken();
  }

  validateLogin(BuildContext context) async {
    // PermissionStatus locationStatus;

    //  locationStatus = await Permission.location.status;

    // if (locationStatus.isGranted) {
    // if(Platform.isIOS){
    //   print('testLogin');
    //   await checkLocation();
    //   await Future.delayed(Duration(seconds: 3));
    // }
    if (mycontroller[3].text.toString().trim().isEmpty) {
      errorMsh = "Complete the setup..!!";
    } else {
      if (formkey.currentState!.validate()) {
        disableKeyBoard(context);
        isLoading = true;
        await HelperFunctions.clearHost();
        String? Url = "";
        // String meth =
        //     '${ConstantApiUrl.getUrlapi}${mycontroller[3].text.toString().trim()}';
        await GetURLApi.getData(ConstantApiUrl.getUrlapi(
                mycontroller[3].text.toString().trim()))
            .then((value) async {
          if (value.stcode! >= 200 && value.stcode! <= 210) {
            if (value.url != null) {
              Url = value.url;
              print("url method::" + Url.toString());
              await HelperFunctions.saveHostSP(Url!.trim());
              await HelperFunctions.saveTenetIDSharedPreference(
                  mycontroller[3].text.toString().trim());
              setURL();

              errorMsh = "";
              erroMsgVisble = false;
              settingError = false;
              validateloginfinal(context);
              notifyListeners();
            } else {
              print("object1:" + value.exception.toString());
              erroMsgVisble = true;
              isLoading = false;
              validateloginfinal(context);
              errorMsh = value.exception.toString();
            }
          } else {
            if (value.exception == 'No route to host') {
              isLoading = false;
              erroMsgVisble = true;
              errorMsh = 'Check your Internet Connection...!!';
            } else if (value.message == "Catch") {
              isLoading = false;
              erroMsgVisble = true;
              errorMsh =
                  '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
            } else {
              isLoading = false;
              erroMsgVisble = true;
              errorMsh =
                  '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
            }
            // print("object2:" + value.exception.toString());
            // erroMsgVisble = true;
            // isLoading = false;
            // errorMsh = value.exception.toString();
          }
        });

        //
        // await getUrlApi();

        //

        // Get.offAllNamed(ConstantRoutes.dashboard);
      }
    }
    // } else {
    //   await showDialog<dynamic>(
    //         context: context,
    //         builder: (_) {
    //           return PermissionShowDialog(
    //             locationbool: locationbool,
    //             camerabool: camerabool,
    //             notificationbool: notificationbool,
    //           );
    //         }).then((value) async {
    //             permission = await Geolocator.checkPermission();

    //     });
    // }
  }

  validateloginfinal(BuildContext context) async {
    String? getUrl = await HelperFunctions.getHostDSP();
    log("getUrl::" + getUrl.toString());
    if (getUrl == null || getUrl == 'null' || getUrl == '') {
      isLoading = false;
      erroMsgVisble = true;
      errorMsh = 'Invalid Customer Id..!!';
      notifyListeners();
    } else {
      String? fcm2 = await HelperFunctions.getFCMTokenSharedPreference();
      if (fcm2 == null) {
        fcm2 = (await getToken())!;
        print("FCM Token: $fcm2");
        await HelperFunctions.saveFCMTokenSharedPreference(fcm2);
      }
      String? deviceID = await HelperFunctions.getDeviceIDSharedPreference();
      log("deviceID:::" + deviceID.toString());
      if (deviceID == null) {
        deviceID = await Config.getdeviceId();
        print("deviceID" + deviceID.toString());
        await HelperFunctions.saveDeviceIDSharedPreference(deviceID!);
        notifyListeners();
      }
      LoginVerfiReqbody reqBody = LoginVerfiReqbody();
      reqBody.fcmCode = fcm2;
      reqBody.deviceCode = deviceID;
      reqBody.password = mycontroller[1].text.toString().trim();
      reqBody.userCode = mycontroller[0].text.toString().trim();
      reqBody.tenantId = mycontroller[3].text.toString().trim();
      reqBody.logoutTypeId = 3;

      LoginVerificationApi.getData(ConstantApiUrl.loginVerificationApi, reqBody)
          .then((value) async {
        //  log("value.datalist!.devicename.toString()::"+value.datalist!.devicename.toString());
        if (value.stcode! >= 200 && value.stcode! <= 210) {
          if (value.status == true) {
            await validateFinal(context);
            isLoading = false;
            notifyListeners();
          } else {
            await showDialog<dynamic>(
                context: context,
                builder: (_) {
                  return AlreadyLoginDialogbox(
                      errormsg: '',
                      msg:
                          '${value.message} ${value.datalist!.devicename.toString()}',
                      customerId: mycontroller[3].text.toString().trim(),
                      userCode: '${mycontroller[0].text.toString().trim()}',
                      password: '${mycontroller[1].text.toString().trim()}');
                }).then((value) {
              isLoading = false;
              notifyListeners();
            });
          }
        } else if (value.stcode! >= 400 && value.stcode! <= 410) {
          await showDialog<dynamic>(
              context: context,
              builder: (_) {
                return AlreadyLoginDialogbox(
                    errormsg: '${value.message} ',
                    msg: '',
                    customerId: mycontroller[3].text.toString().trim(),
                    userCode: '${mycontroller[0].text.toString().trim()}',
                    password: '${mycontroller[1].text.toString().trim()}');
              }).then((value) {
            isLoading = false;
            notifyListeners();
          });
        } else {
          await showDialog<dynamic>(
              context: context,
              builder: (_) {
                return AlreadyLoginDialogbox(
                  errormsg:
                      '${value.stcode}..!!Network Issue..\nTry again Later. .!!',
                  msg: '',
                  customerId: mycontroller[3].text.toString().trim(),
                  userCode: '${mycontroller[0].text.toString().trim()}',
                  password: '${mycontroller[1].text.toString().trim()}',
                );
              }).then((value) {
            isLoading = false;
            notifyListeners();
          });
        }
      });
    }
    notifyListeners();
  }

  validateFinal(BuildContext context) async {
    //**** */
    //  await config.getSetup();

    //Get URL APi

    //Get Url Api

    //**** */
    log("is is is ");
    notifyListeners();
    PostLoginData postLoginData = PostLoginData();
    postLoginData.deviceCode =
        await HelperFunctions.getDeviceIDSharedPreference();
    postLoginData.licenseKey =
        await HelperFunctions.getLicenseKeySharedPreference();
    postLoginData.fcmToken =
        await HelperFunctions.getFCMTokenSharedPreference();
    // log("fcmmmm: "+postLoginData.fcmToken.toString());
    postLoginData.username = mycontroller[0].text;
    postLoginData.password = mycontroller[1].text;
    String? model = await Config.getdeviceModel();
    String? brand = await Config.getdeviceBrand();
    postLoginData.devicename = '${brand} ${model}';
    postLoginData.ipName = Utils.ipname;
    postLoginData.ipaddress = Utils.ipaddress;
    postLoginData.latitude =
        (Utils.latitude == 'null' || Utils.latitude!.isEmpty)
            ? '0'
            : Utils.latitude;
    postLoginData.langtitude =
        (Utils.langtitude == 'null' || Utils.latitude!.isEmpty)
            ? '0'
            : Utils.latitude;

    postLoginData.tenantId = mycontroller[3].text.trim();
    Utils.tenetID = await HelperFunctions.getTenetIDSharedPreference();
    // Config config=Config();
    String meth = ConstantApiUrl.loginapi;

    await LoginPostApi.getData(postLoginData, ConstantApiUrl.loginapi)
        .then((value) async {
      if (value.resCode! >= 200 && value.resCode! <= 200) {
        if (value.loginstatus!.toLowerCase().contains('success') &&
            value.data != null) {
          // DashBoardController.isLogout = false;
          isLoading = false;
          erroMsgVisble = false;
          errorMsh = '';
          await HelperFunctions.saveTokenSharedPreference(value.token!);
          Utils.token = await HelperFunctions.getTokenSharedPreference();
          Utils.userNamePM = mycontroller[0].text;
          await HelperFunctions.saveUserName(value.data!.userCode);
          await HelperFunctions.saveFSTNameSharedPreference(
              value.data!.urlColumn);
          await HelperFunctions.saveLicenseKeySharedPreference(
              value.data!.licenseKey);
          await HelperFunctions.saveLogginUserCodeSharedPreference(
              mycontroller[0].text);
          // await HelperFunctions.saveSapUrlSharedPreference(
          //     value.data!.endPointUrl);
          await HelperFunctions.saveTenetIDSharedPreference(
              value.data!.tenantId);
          await HelperFunctions.saveUserIDSharedPreference(value.data!.UserID);
          Utils.userId = value.data!.UserID;
          Utils.usercode = value.data!.userCode;
          Utils.storeid = int.parse(value.data!.storeid.toString());
          Utils.storecode = value.data!.storecode.toString();
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.savePasswordSharedPreference(
              mycontroller[1].text);
          await HelperFunctions.getFSTNameSharedPreference().then((value) {
            if (value != null) {
              Utils.firstName = value;
            }
          });
          log("message");
          // await HelperFunctions.saveuserDB(value.data!.userDB);
          await HelperFunctions.savedbUserName(value.data!.UserID);
          // await HelperFunctions.savedbPassword(value.data!.dbPassword);

          await HelperFunctions.saveUserType(value.data!.userType);
          await HelperFunctions.saveSlpCode(value.data!.slpcode);

          mycontroller[0].clear();
          mycontroller[1].clear();

          final Database db = (await DBHelper.getInstance())!;
          await DBOperation.truncateLoginVerficationDB(db);
          List<LoginVerificationList>? loginVerifiList2 = [];
          List<VerificationData> values = []; //DB VAriable
          loginVerifiList2 = value.loginVerifiList; //Api data
          //
          if (loginVerifiList2 != null && loginVerifiList2.isNotEmpty) {
            for (int i = 0; i < loginVerifiList2.length; i++) {
              values.add(VerificationData(
                  id: loginVerifiList2[i].id,
                  code: loginVerifiList2[i].code,
                  restrictionData: loginVerifiList2[i].restrictionData,
                  restrictionType: loginVerifiList2[i].restrictionType,
                  remarks: loginVerifiList2[i].remarks));
            }

            // checkLoginVerification();
          }
          await DBOperation.insertLoginVerifiDetails(values, db);
          if (loginVerifiList2 != null && loginVerifiList2.isNotEmpty) {
            await checkLoginVerification();
          } else {
            Get.offAllNamed(ConstantRoutes.download);
          }
          notifyListeners();
          // Get.offAllNamed(ConstantRoutes.download);
        } else if (value.loginstatus!.toLowerCase().contains("failed") &&
            value.data == null) {
          isLoading = false;
          erroMsgVisble = true;
          errorMsh = value.loginMsg!;
          notifyListeners();
        }
      } else {
        if (value.excep == 'No route to host') {
          isLoading = false;
          erroMsgVisble = true;
          errorMsh = 'Check your Internet Connection...!!';
        } else if (value.loginMsg == "Catch") {
          isLoading = false;
          erroMsgVisble = true;
          errorMsh =
              '${value.resCode!}..!!Network Issue..\nTry again Later..!!';
        } else {
          isLoading = false;
          erroMsgVisble = true;
          errorMsh = '${value.resCode!}..!!${value.excep!}';
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }

  checkLoginVerification() async {
    final Database db = (await DBHelper.getInstance())!;
    // Timer.periodic(const Duration(minutes: 1), (timer) async {
    bool verifibool = false;

    String? getUrl = await HelperFunctions.getHostDSP();
    print("URL1:" + getUrl.toString());
    if (getUrl != null && getUrl != 'null' && getUrl != '') {
      List<Map<String, Object?>> VerificationDataDBData =
          await DBOperation.getLoginVerifiDBData(db);
      print("VerificationDataDBData bool:" +
          VerificationDataDBData.length.toString());
      if (VerificationDataDBData.isNotEmpty) {
        bool anyConditionSatisfied = false;

        for (int i = 0; i < VerificationDataDBData.length; i++) {
          print("VerificationDataDBData[i]['RestrictionType'].toString()::" +
              VerificationDataDBData[i]['RestrictionType'].toString());

          if (VerificationDataDBData[i]['RestrictionType'].toString() == '1') {
            if (VerificationDataDBData[i]['RestrictionData'].toString() ==
                Utils.ipaddress) {
              verifibool = true;
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
            String? lat = locatoindetals[0];
            String? long = locatoindetals[1];
            String? dis = locatoindetals[2];
            double totaldis = calculateDistance2(
                double.parse(locatoindetals[0]),
                double.parse(locatoindetals[1]),
                double.parse(Utils.latitude.toString()),
                double.parse(Utils.langtitude.toString()));
            print("Total Dis:" + totaldis.toString());
            int apiDis = int.parse(locatoindetals[2].toString());
            if (totaldis < apiDis.toDouble()) {
              verifibool = true;
              anyConditionSatisfied = true;
              break;
            }
          } else if (VerificationDataDBData[i]['RestrictionType'].toString() ==
              '3') {
            String ipname = Utils.ipname.replaceAll('"', '');
            if (VerificationDataDBData[i]['RestrictionData'].toString() ==
                Utils.ipname) {
              verifibool = true;
              anyConditionSatisfied = true;
              break;
            }
          }
        }

        if (!anyConditionSatisfied) {
          Get.offAllNamed(ConstantRoutes.restrictionValue);
        } else {
          // if (RestrictionPageState.loginbool == true) {
          Get.offAllNamed(ConstantRoutes.download);
          // }else{
          //    Get.offAllNamed(ConstantRoutes.login);
          // }
        }
      }
    }
    print("verifi bool:" + verifibool.toString());
    // });
  }

  disableKeyBoard(BuildContext context) {
    FocusScopeNode focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus) {
      focus.unfocus();
    }
  }

  // testApi()async{
  //  await TestApi.getData();
  // }
  setTermsAConditionsValue(bool? val) {
    print(val);

    TCbool = (TCbool! == true) ? false : val;
    notifyListeners();
  }

  getHost() async {
    mycontroller[2].clear();
    mycontroller[3].clear();
    TCbool = false;
    await HelperFunctions.clearHost();
    await HelperFunctions.clearCheckedTennetIDSharedPref();
    await HelperFunctions.clearhostIP();
    final Database db = (await DBHelper.getInstance())!;
    await DBOperation.truncareEnqType(db);
    await DBOperation.truncarelevelofType(db);
    await DBOperation.truncareorderType(db);

    await DBOperation.truncareCusTagType(db);
    await DBOperation.trunstateMaster(db);
    await DBOperation.truncareEnqReffers(db);
    await DBOperation.truncateUserList(db);
    await DBOperation.truncateLeadstatus(db);
    await DBOperation.truncateOfferZone(db);
    await DBOperation.truncateOfferZonechild1(db);
    await DBOperation.truncateOfferZonechild2(db);
//Existing Coding below
    // String? host = await HelperFunctions.getHostDSP();
    // String? tenet = await HelperFunctions.getTenetIDSharedPreference();

    // log("host ${host}");
    // if (host != null) {
    //   settingError = false;
    //   erroMsgVisble = false;
    //   mycontroller[2].text = host;
    //   mycontroller[3].text = tenet!;
    // }
    // if (host == null) {
    erroMsgVisble = true;
    settingError = true;
    errorMsh = "Complete the setup..!!";
    notifyListeners();
    // }
  }

  bool progrestext = false;
  void settingvalidate(BuildContext context) async {
    await checkLoc();
    // await  checkLocation();
    // await LocationTrack.determinePosition();
    notifyListeners();
    if (formkey2.currentState!.validate()) {
      progrestext = true;
      errorMsh = "";
      erroMsgVisble = false;
      settingError = false;
      // setURL();
      progrestext = false;
      notifyListeners();

      Navigator.pop(context);
    }
  }

  checkLoc() async {
    if (Platform.isAndroid) {
      await LocationTrack.determinePosition();
    } else {
      await LocationTrack2.determinePosition();
    } // await Future.delayed(Duration(seconds: 3));
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      log("result:::" + result.name.toString());
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
          final String? data = await mobileNetworkInfo.getMobileNetworkName();
          //
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
        Utils.ipaddress = name == null ? 'null' : name;
        Utils.ipname = wifiiInfo[0];
      }
      print("LocationTrack.Lat2::" + LocationTrack.lat.toString());
      print("LocationTrack.Long2::" + LocationTrack.long.toString());
      print("Utils.lat::" + Utils.latitude.toString());
      print("Utils.lang::" + Utils.langtitude.toString());
      Utils.latitude = LocationTrack.lat.isEmpty
          ? "${Utils.latitude}"
          : '${LocationTrack.lat}';
      Utils.langtitude = LocationTrack.long.isEmpty
          ? "${Utils.langtitude}"
          : '${LocationTrack.long}';
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
      print("Location Header::" + Utils.headerSetup.toString());
      EncryptData enc = new EncryptData();
      String? encryValue = enc.encryptAES("${Utils.headerSetup}");
      log("Encryped Location Header:::" + encryValue.toString());
      Utils.encryptedSetup = encryValue;
      log("Utils.EncryptedSetup::" + Utils.encryptedSetup.toString());
      //  await config.getSetup();
    });

    // await LocationTrack.checkcamlocation();
  }

  // validateAlradyLogin(String customerId) async {}

  setURL() async {
    String? getUrl = await HelperFunctions.getHostDSP();
    String hostip = '';
    if (getUrl != null) {
      for (int i = 0; i < getUrl.length; i++) {
        if (getUrl[i] == ":") {
          break;
        }
        // log("for ${hostip}");
        hostip = hostip + getUrl[i];
      }
    }

    // log("for last ${hostip}");
    HelperFunctions.savehostIP(hostip);
    Utils.userNamePM = await HelperFunctions.getUserName();
    Utils.queryApi = "http://${getUrl.toString()}/api/";
  }

  Future<bool> checkloc() async {
    bool res = false;
    print('test1');
    res = await LocationTrack.checkPermission();

    return res;
  }
}

// // ignore_for_file: unnecessary_new, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks, unnecessary_brace_in_string_interps, unused_import, unused_local_variable, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors, prefer_if_null_operators

// import 'dart:developer';
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:get_ip_address/get_ip_address.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:sellerkit/Constant/AppConstant.dart';
// import 'package:sellerkit/Constant/ConstantRoutes.dart';
// import 'package:sellerkit/Constant/Encripted.dart';
// import 'package:sellerkit/Constant/Helper.dart';
// import 'package:sellerkit/Constant/LocationTrack.dart';
// import 'package:sellerkit/Constant/LocationTrackIos.dart';
// import 'package:sellerkit/Constant/methodchannel.dart';
// import 'package:sellerkit/Controller/DashBoardController/DashBoardController.dart';
// import 'package:sellerkit/Services/LoginApi/LoginApi.dart';
// import 'package:sellerkit/Services/URL/GetURLApi.dart';
// import 'package:sellerkit/Widgets/Dialogbox.dart';
// import 'package:sellerkit/main.dart';
// // import 'package:share/share.dart';
// import '../../Constant/Configuration.dart';
// import '../../Constant/ConstantSapValues.dart';
// import '../../Models/LoginModel/LoginModel.dart';
// import '../../Services/TestApi/TestApi.dart';
// import '../../Services/URL/LocalUrl.dart';
// // import 'package:local_auth/error_codes.dart' as auth_error;
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

// class LoginController extends ChangeNotifier {
//   LoginController(BuildContext context) {
//     check(context);
//   }
//   LocationPermission? permission;
//   bool? locationbool = false;
//   bool? TCbool = false;

//   bool? camerabool = false;
//   bool? notificationbool = false;
//   check(BuildContext context) async {
//     // await checkLocation();

//     final permission = Permission.notification;
//     PermissionStatus status = await permission.status;

//     var locationStatus = await Permission.location.status;
//     // var cameraStatus = await Permission.camera.status;
//     // var notifiStatus = await Permission.notification.status;

//     print('location' + locationStatus.toString());
//     // print('cameraStatus' + cameraStatus.toString());
//     // print('notifiStatus2' + notifiStatus.toString());

//     if (locationStatus.isGranted) {
//       locationbool = true;
//       notifyListeners();
//     }
//     // if (cameraStatus.isGranted) {
//     //   camerabool = true;
//     //   notifyListeners();
//     // }
//     // if (notifiStatus.isGranted) {
//     //   notificationbool = true;
//     //   notifyListeners();
//     // }
//     // if (Platform.isIOS) {
//     if (locationbool == false
//         // ||
//         //     camerabool == false ||
//         //     notificationbool == false
//         ) {
//       LocationPermission permission;

//       await showDialog<dynamic>(
//           context: context,
//           builder: (_) {
//             return PermissionShowDialog(
//               locationbool: locationbool,
//               camerabool: camerabool,
//               notificationbool: notificationbool,
//             );
//           }).then((value) async {
//         await Geolocator.requestPermission().then((value) async {
//           // permission = await Geolocator.checkPermission();
//           // if (LocationPermission.always != value) {
//           //  await Geolocator.requestPermission();
//           // }
//         });
//       });
//     }
//     // }
//     await getHost();
//     notifyListeners();
//   }

//   Config config = new Config();
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   List<TextEditingController> mycontroller =
//       List.generate(15, (i) => TextEditingController());
//   GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   GlobalKey<FormState> formkey2 = GlobalKey<FormState>();
//   bool hidePassword = true;
//   bool isLoading = false;
//   bool erroMsgVisble = false;
//   bool settingError = false;

//   String errorMsh = '';
//   static bool loginPageScrn = false;

//   bool get getHidepassword => hidePassword;
//   bool get getIsLoading => isLoading;
//   bool get geterroMsgVisble => erroMsgVisble;
//   bool get getsettingError => settingError;

//   String get getErrorMshg => errorMsh;

//   void obsecure() {
//     hidePassword = !hidePassword;
//     notifyListeners();
//   }

//   showLoginDialog(BuildContext context) {
//     config.msgDialog(context, '', '');
//   }

//   Future<void> getUrlApi() async {
//     String? Url = "";
//     //Get Url Api
//     print("get Url Api call:" + mycontroller[3].text.toString());
//     await GetURLApi.getData(mycontroller[3].text.toString().trim())
//         .then((value) async {
//       if (value.stcode! >= 200 && value.stcode! <= 210) {
//         if (value.url != null) {
//           Url = value.url;
//           print("url method::" + Url.toString());
//           await HelperFunctions.saveHostSP(Url!.trim());
//           await HelperFunctions.saveTenetIDSharedPreference(
//               mycontroller[3].text.toString().trim());
//           setURL();
//           errorMsh = "";
//           erroMsgVisble = false;
//           settingError = false;
//           notifyListeners();
//         } else {
//           print("object1:" + value.exception.toString());
//           erroMsgVisble = true;
//           isLoading = false;
//           errorMsh = value.exception.toString();
//         }
//       } else {
//         print("object2:" + value.exception.toString());
//         erroMsgVisble = true;
//         isLoading = false;
//         errorMsh = value.exception.toString();
//       }
//     });
//     notifyListeners();
//   }

//   validateLogin(BuildContext context) async {
//     // PermissionStatus locationStatus;

//     //  locationStatus = await Permission.location.status;

//     // if (locationStatus.isGranted) {
//     // if(Platform.isIOS){
//     //   print('testLogin');
//     //   await checkLocation();
//     //   await Future.delayed(Duration(seconds: 3));
//     // }
//     if (mycontroller[3].text.toString().trim().isEmpty) {
//       errorMsh = "Complete the setup..!!";
//     } else {
//       if (formkey.currentState!.validate()) {
//         disableKeyBoard(context);
//         isLoading = true;
//         //**** */
//         //  await config.getSetup();

//         //Get URL APi

//         String? Url = "";
//         //Get Url Api
//         print("get Url Api call:" + mycontroller[3].text.toString());
//         await GetURLApi.getData(mycontroller[3].text.toString().trim())
//             .then((value) async {
//           if (value.stcode! >= 200 && value.stcode! <= 210) {
//             if (value.url != null) {
//               Url = value.url;
//               print("url method::" + Url.toString());
//               await HelperFunctions.saveHostSP(Url!.trim());
//               await HelperFunctions.saveTenetIDSharedPreference(
//                   mycontroller[3].text.toString().trim());
//               setURL();
//               errorMsh = "";
//               erroMsgVisble = false;
//               settingError = false;
//               notifyListeners();
//             } else {
//               print("object1:" + value.exception.toString());
//               erroMsgVisble = true;
//               isLoading = false;
//               errorMsh = value.exception.toString();
//             }
//           } else {
//             print("object2:" + value.exception.toString());
//             erroMsgVisble = true;
//             isLoading = false;
//             errorMsh = value.exception.toString();
//           }
//         });

//         //
//         await getUrlApi();
//         //**** */
//         log("is is is ");
//         notifyListeners();
//         PostLoginData postLoginData = new PostLoginData();
//         postLoginData.deviceCode =
//             await HelperFunctions.getDeviceIDSharedPreference();
//         postLoginData.licenseKey =
//             await HelperFunctions.getLicenseKeySharedPreference();
//         postLoginData.fcmToken =
//             await HelperFunctions.getFCMTokenSharedPreference();
//         // log("fcmmmm: "+postLoginData.fcmToken.toString());
//         postLoginData.username = mycontroller[0].text;
//         postLoginData.password = mycontroller[1].text;
//         Utils.tenetID =
//             await HelperFunctions.getTenetIDSharedPreference();

//         await LoginAPi.getData(postLoginData).then((value) async {
//           if (value.resCode! >= 200 && value.resCode! <= 200) {
//             if (value.loginstatus!.toLowerCase().contains('success') &&
//                 value.data != null) {
//               DashBoardController.isLogout = false;
//               isLoading = false;
//               erroMsgVisble = false;
//               errorMsh = '';
//               Utils.userNamePM = mycontroller[0].text;
//               await HelperFunctions.saveUserName(mycontroller[0].text);
//               await HelperFunctions.saveLicenseKeySharedPreference(
//                   value.data!.licenseKey);
//               await HelperFunctions.saveLogginUserCodeSharedPreference(
//                   mycontroller[0].text);
//               // await HelperFunctions.saveSapUrlSharedPreference(
//               //     value.data!.endPointUrl);
//               await HelperFunctions.saveTenetIDSharedPreference(
//                   value.data!.tenantId);
//               await HelperFunctions.saveUserIDSharedPreference(
//                   value.data!.UserID);
//               Utils.UserId = value.data!.UserID;
//               Utils.Usercode = value.data!.userCode;
//               Utils.storeid =
//                   int.parse(value.data!.storeid.toString());
//               Utils.Storecode = value.data!.storecode.toString();
//               await HelperFunctions.saveUserLoggedInSharedPreference(true);
//               await HelperFunctions.savePasswordSharedPreference(
//                   mycontroller[1].text);

//               log("message");
//               // await HelperFunctions.saveuserDB(value.data!.userDB);
//               await HelperFunctions.savedbUserName(value.data!.UserID);
//               // await HelperFunctions.savedbPassword(value.data!.dbPassword);

//               await HelperFunctions.saveUserType(value.data!.userType);
//               await HelperFunctions.saveSlpCode(value.data!.slpcode);

//               mycontroller[0].clear();
//               mycontroller[1].clear();
//               notifyListeners();
//               Get.offAllNamed(ConstantRoutes.download);
//             } else if (value.loginstatus!.toLowerCase().contains("failed") &&
//                 value.data == null) {
//               isLoading = false;
//               erroMsgVisble = true;
//               errorMsh = value.loginMsg!;
//               notifyListeners();
//             }
//           } else if (value.resCode! >= 400 && value.resCode! <= 410) {
//             erroMsgVisble = true;

//             isLoading = false;
//             errorMsh = value.excep!;
//             notifyListeners();
//           } else {
//             if (value.excep == 'No route to host') {
//               isLoading = false;
//               erroMsgVisble = true;
//               errorMsh = 'Check your Internet Connection...!!';
//             } else {
//               isLoading = false;
//               erroMsgVisble = true;
//               errorMsh = '${value.resCode!}..!!Network Issue..\nTry again Later..!!';
//             }
//             notifyListeners();
//           }
//         });
//         // Get.offAllNamed(ConstantRoutes.dashboard);
//       }
//     }
//     // } else {
//     //   await showDialog<dynamic>(
//     //         context: context,
//     //         builder: (_) {
//     //           return PermissionShowDialog(
//     //             locationbool: locationbool,
//     //             camerabool: camerabool,
//     //             notificationbool: notificationbool,
//     //           );
//     //         }).then((value) async {
//     //             permission = await Geolocator.checkPermission();

//     //     });
//     // }
//   }

//   // showShare(String deviceID) {
//   //   Share.share(
//   //     'Dear Sir/Madam,\n  Kindly Register My Mobile For Sellerkit App,\n My Device ID : \n $deviceID \n Thanks & Regards',
//   //   );
//   // }

//   disableKeyBoard(BuildContext context) {
//     FocusScopeNode focus = FocusScope.of(context);
//     if (!focus.hasPrimaryFocus) {
//       focus.unfocus();
//     }
//   }

//   // testApi()async{
//   //  await TestApi.getData();
//   // }
//   setTermsAConditionsValue(bool? val) {
//     print(val);

//     TCbool = (TCbool! == true) ? false : val;
//     notifyListeners();
//   }

//   getHost() async {
//     mycontroller[2].clear();
//     mycontroller[3].clear();
//     TCbool = false;
//     await HelperFunctions.clearHost();
//     await HelperFunctions.clearCheckedTennetIDSharedPref();
//     await HelperFunctions.clearhostIP();
// //Existing Coding below
//     // String? host = await HelperFunctions.getHostDSP();
//     // String? tenet = await HelperFunctions.getTenetIDSharedPreference();

//     // log("host ${host}");
//     // if (host != null) {
//     //   settingError = false;
//     //   erroMsgVisble = false;
//     //   mycontroller[2].text = host;
//     //   mycontroller[3].text = tenet!;
//     // }
//     // if (host == null) {
//     erroMsgVisble = true;
//     settingError = true;
//     errorMsh = "Complete the setup..!!";
//     notifyListeners();
//     // }
//   }

//   bool progrestext = false;
//   void settingvalidate(BuildContext context) async {
   
//     await checkLoc();
//     // await  checkLocation();
//     // await LocationTrack.determinePosition();
//     notifyListeners();
//     if (formkey2.currentState!.validate()) {
//        progrestext = true;
//       errorMsh = "";
//       erroMsgVisble = false;
//       settingError = false;
//       // setURL();
//       progrestext = false;
//       notifyListeners();

//       Navigator.pop(context);
//     }
//   }

//   checkLoc() async {
//     if (Platform.isAndroid) {
//       await LocationTrack.determinePosition();
//     } else {
//       await LocationTrack2.determinePosition();
//     } // await Future.delayed(Duration(seconds: 3));
//     Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) async {
//       log("result:::" + result.name.toString());
//       // Got a new connectivity status!

//       if (result.name == 'none') {
//         Utils.ipaddress = '';
//         Utils.ipname = '';
//       } else if (result.name == 'mobile') {
//         if (Platform.isAndroid) {
//           final MobileNetworkInfo mobileNetworkInfo = MobileNetworkInfo();
//           final String? name = await mobileNetworkInfo.getMobileNetworkName();

//           // List<String>? wifiiInfo = await config.setNetwork();
//           //
//           var ipAddress = IpAddress(type: RequestType.text);
//           String data = await ipAddress.getIpAddress();
//           //
//           Utils.ipaddress = name == null ? 'null' : name;
//           Utils.ipname = data == null ? 'null' : data;
//         } else if (Platform.isIOS) {
//          List<String>? wifiiInfo = await config.getIosNetworkInfo();
//         Utils.ipaddress =  wifiiInfo[1];
//         Utils.ipname =  wifiiInfo[0];
//         }
//       } else if (result.name == 'wifi') {
//         List<String>? wifiiInfo = await config.setNetwork();
//         Utils.ipaddress = wifiiInfo[1];
//         Utils.ipname = wifiiInfo[0];
//       }
//       print("LocationTrack.Lat2::" + LocationTrack.Lat.toString());
//       print("LocationTrack.Long2::" + LocationTrack.Long.toString());
//       print("Utils.lat::" + Utils.latitude.toString());
//       print("Utils.lang::" + Utils.langtitude.toString());
//       Utils.latitude = LocationTrack.Lat.isEmpty
//           ? "${Utils.latitude}"
//           : '${LocationTrack.Lat}';
//       Utils.langtitude = LocationTrack.Long.isEmpty
//           ? "${Utils.langtitude}"
//           : '${LocationTrack.Long}';
//       //
//       if (Utils.langtitude!.isEmpty ||
//           Utils.langtitude == '') {
//         Utils.langtitude = '0.000';
//       }
//       if (Utils.latitude!.isEmpty || Utils.latitude == '') {
//         Utils.latitude = '0.000';
//       }
//       Utils.headerSetup =
//           "${Utils.latitude};${Utils.langtitude};${Utils.ipname};${Utils.ipaddress}";
//       //
//       print("Location Header::" + Utils.headerSetup.toString());
//       EncryptData enc = new EncryptData();
//       String? encryValue = enc.encryptAES("${Utils.headerSetup}");
//       log("Encryped Location Header:::" + encryValue.toString());
//       Utils.EncryptedSetup = encryValue;
//       log("Utils.EncryptedSetup::" +
//           Utils.EncryptedSetup.toString());
//       //  await config.getSetup();
//     });

//     // await LocationTrack.checkcamlocation();
//   }

//   setURL() async {
//     String? getUrl = await HelperFunctions.getHostDSP();
//     String hostip = '';
//     if (getUrl != null) {
//       for (int i = 0; i < getUrl.length; i++) {
//         if (getUrl[i] == ":") {
//           break;
//         }
//         // log("for ${hostip}");
//         hostip = hostip + getUrl[i];
//       }
//     }

//     // log("for last ${hostip}");
//     HelperFunctions.savehostIP(hostip);
//     Utils.userNamePM = await HelperFunctions.getUserName();
//     Url.queryApi = "http://${getUrl.toString()}/api/";
//   }

//   Future<bool> checkloc() async {
//     bool res = false;
//     print('test1');
//     res = await LocationTrack.checkPermission();

//     return res;
//   }
// }

