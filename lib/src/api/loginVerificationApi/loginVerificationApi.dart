// ignore_for_file: unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class LoginVerificationApi {
  static Future<LoginVerificationApi> getData(
      String meth, LoginVerfiReqbody reqbody) async {
    // Sellerkit_Flexi/v2/Logout
    Responce res = Responce();
    var body = reqbody.toJson();

    res = await ServicePost.callApi(meth, '', body);

    Map<String, dynamic> jsons = {};
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      jsons = jsonDecode(res.responceBody!);
    }
    return LoginVerificationApi.fromJson(jsons, res);
  }

  LoginVerificationDetails? datalist;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  // String? data;
  LoginVerificationApi({
    required this.datalist,
    required this.message,
    required this.status,
    this.exception,
    required this.stcode,
    // this.data
  });
  factory LoginVerificationApi.fromJson(
      Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons != null && jsons.isNotEmpty) {
        return LoginVerificationApi(
            datalist: LoginVerificationDetails.fromJson(jsons['data']),
            message: jsons['msg'],
            status: jsons['status'],
            // data:jsons['data']??'',
            stcode: res.resCode,
            exception: null);
      } else {
        return LoginVerificationApi(
            datalist: null,
            message: jsons.toString(),
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! >= 400 && res.resCode! <= 410) {
        jsons = jsonDecode(res.responceBody!);

        return LoginVerificationApi(
            datalist: null,
            message: jsons['msg'],
            status: jsons['status'],
            stcode: res.resCode,
            exception: null);
      } else {
        return LoginVerificationApi(
            datalist: null,
            message: res.responceBody.toString(),
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class LoginVerificationDetails {
  LoginVerificationDetails(
      {required this.fcm, required this.devicecode, required this.devicename});

  String? fcm;
  String? devicecode;
  String? devicename;

  factory LoginVerificationDetails.fromJson(Map<String, dynamic> json) =>
      LoginVerificationDetails(
          fcm: json['fcm'],
          devicecode: json['devicecode'],
          devicename: json['deviceName'] ?? '');
}

class LoginVerfiReqbody {
  String? userCode;
  String? fcmCode;
  String? deviceCode;
  int? logoutTypeId;
  String? tenantId;
  String? password;

  LoginVerfiReqbody({
    this.userCode,
    this.fcmCode,
    this.deviceCode,
    this.logoutTypeId,
    this.tenantId,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'userCode': userCode,
        'fcmCode': fcmCode,
        'deviceCode': deviceCode,
        'logoutTypeId': logoutTypeId,
        'tenantId': tenantId,
        'password': password,
      };
}
