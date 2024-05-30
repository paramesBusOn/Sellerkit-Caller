// ignore_for_file: unnecessary_null_comparison, avoid_print

// import 'dart:math';
import 'dart:developer';
import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/encripted.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class LoginPostApi {
  String? loginstatus;
  String? loginMsg;
  LoginPostApiData? data;
  int? resCode;
  String? excep;
  String? token;

  List<LoginVerificationList>? loginVerifiList;

  LoginPostApi(
      {required this.loginstatus,
      required this.loginMsg,
      required this.loginVerifiList,
      this.data,
      this.excep,
      this.token,
      required this.resCode});

  static Future<LoginPostApi> getData(
      PostLoginData postLoginData, String meth) async {
    Responce res = Responce();
    var body = postLoginData.toJson();

    res = await ServicePost.callApi(meth, '', body);

    if (res.resCode == 200) {
      //

      Config config = Config();
      Map<String, dynamic> tokenNew3 = json.decode(res.responceBody!);
      Map<String, dynamic> jres =
          config.parseJwt(tokenNew3['token'].toString());
      log("ABCD7333:::$jres");
      EncryptData Encrupt = EncryptData();
      String? testData2 = Encrupt.decrypt(jres['encrypted']);

      Map<String, dynamic> jres2 = jsonDecode(testData2);
      log("jres2:::$jres2");
      Map<String, dynamic> tokenNew = json.decode(res.responceBody!);
      log("token::::${tokenNew['token']}");
      Utils.token = tokenNew['token'];
      HelperFunctions.saveTokenSharedPreference(tokenNew['token']);
      return LoginPostApi.fromJson(
          jres2, json.decode(res.responceBody!), res.resCode!);
    } else {
      if (res.responceBody!.toString().contains('Failed host lookup')) {
        return LoginPostApi.fromJson({},
            json.decode(res.responceBody!), res.resCode!);
      } else {
        return LoginPostApi.fromJson({}, {}, 500);
      }
    }
  }

  factory LoginPostApi.fromJson(Map<String, dynamic> jsons,
      Map<String, dynamic> verifijsons, int rescode) {
    if (rescode >= 200 && rescode <= 210) {
      if (jsons != null) {
        var list = verifijsons['restrictionData'] as List;
        if (list.isEmpty) {
          return LoginPostApi(
              loginstatus: "success",
              loginMsg: "success",
              data: LoginPostApiData.fromJson(jsons),
              excep: null,
              loginVerifiList: null,
              resCode: rescode,
              token: verifijsons['token']);
        } else {
          List<LoginVerificationList> dataList =
              list.map((data) => LoginVerificationList.fromJson(data)).toList();
          //
          return LoginPostApi(
            loginstatus: "success",
            loginMsg: "success",
            data: LoginPostApiData.fromJson(jsons),
            loginVerifiList: dataList,
            resCode: rescode,
            excep: null,
          );
        }
      } else {
        return LoginPostApi(
            loginstatus: "failed",
            loginMsg: "failed",
            data: null,
            excep: null,
            loginVerifiList: null,
            resCode: rescode);
      }
    } else {
      if (rescode >= 400 && rescode <= 410) {
        return LoginPostApi(
            excep: verifijsons['respDesc'],
            resCode: rescode,
            loginstatus: null,
            loginMsg: null,
            loginVerifiList: null,
            data: null);
      } else {
        return LoginPostApi(
            excep: verifijsons.toString(),
            resCode: rescode,
            loginstatus: null,
            loginMsg: "Catch",
            loginVerifiList: null,
            data: null);
      }
    }
  }
}

class LoginPostApiData {
  String licenseKey;
  // String endPointUrl;
  // String sessionID;
  String UserID;
  // String userDB;
  // String dbUserName;
  // String dbPassword;
  String userType;
  String slpcode;
  String urlColumn;
  String tenantId;
  String devicecode;
  String userCode;
  String? storeid;
  String? storecode;

  LoginPostApiData(
      {required this.storeid,
      required this.licenseKey,
      required this.urlColumn,
      required this.tenantId,
      required this.UserID,
      required this.devicecode,
      required this.userCode,
      required this.storecode,
      // required this.dbPassword,
      required this.userType,
      required this.slpcode});

  factory LoginPostApiData.fromJson(Map<String, dynamic> json) {
    return LoginPostApiData(
        licenseKey: json["LicenseKey"] ?? '',
        urlColumn: json[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"],
        tenantId: json["TenantId"],
        userCode: json['UserCode'],
        UserID: json['USerId'],
        devicecode: json['DeviceCode'],
        // dbPassword: json['dbPassword'],
        userType: json['UserTypeId'],
        slpcode: json['Slpcode'],
        storeid: json['StoreId'] ?? '',
        storecode: json['StoreCode']);
  }
  // {"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":"DFG56","USerId":"3","TenantId":"cc45","DeviceCode":"","UserCode":"2233","UserTypeId":"1","LicenseKey":"","Slpcode":"EMP01"}
}

class LoginVerificationList {
  int? id;
  String? code;
  int? restrictionType;
  String? restrictionData;
  String? remarks;

  LoginVerificationList({
    required this.id,
    required this.code,
    required this.restrictionData,
    required this.restrictionType,
    required this.remarks,
  });

  factory LoginVerificationList.fromJson(Map<String, dynamic> json) {
    return LoginVerificationList(
      id: json["id"] ?? 0,
      code: json["code"] ?? '',
      restrictionType: json["restrictionType"] ?? 0,
      restrictionData: json['restrictionData'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
  // {"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":"DFG56","USerId":"3","TenantId":"cc45","DeviceCode":"","UserCode":"2233","UserTypeId":"1","LicenseKey":"","Slpcode":"EMP01"}
}

class PostLoginData {
  String? licenseKey;
  String? deviceCode;
  String? tenantId;
  String? username;
  String? password;
  String? fcmToken;
  String? ipaddress;
  String? ipName;
  String? latitude;
  String? langtitude;
  String? devicename;
  PostLoginData(
      {this.deviceCode,
      this.tenantId,
      this.username,
      this.password,
      this.fcmToken,
      this.ipaddress,
      this.ipName,
      this.langtitude,
      this.latitude,
      this.licenseKey,
      this.devicename});

  Map<String, dynamic> toJson() => {
        "deviceCode": deviceCode, //
        'tenantId': tenantId, //
        'userCode': username, //
        'password': password, //
        'fcmToken': fcmToken, //
        'ip': ipaddress, //
        'ssid': ipName, //
        'longitude': langtitude, //
        'lattitude': latitude, //
        'devicename': devicename //
      };
}
