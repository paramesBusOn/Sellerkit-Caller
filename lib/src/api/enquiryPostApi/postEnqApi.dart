// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/enqTypeApi/enqTypeApi.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class EnqPostApi {
  String? exception;
  int? stcode;
  String? resType;
  // Error? error ;
  String? message;

  EnqPostApi(
      {this.exception,
      required this.stcode,
      required this.resType,
      // this.error,
      required this.message});

  static Future<EnqPostApi> getData(
      String meth, PostEnq patch, PatchExCus patchdet) async {
    Config config = Config();

    // var req
    // var body = reqpost.toJson();
    Map<String, dynamic> body = {
      "interestLevel": patchdet.levelof == null ? null : "${patchdet.levelof}",
      "OrderType": patchdet.ordertype == null ? null : "${patchdet.ordertype}",
      "enquiredOn": config.currentDate(),
      "customerCode": "${patch.CardCode}",
      "customerName": patchdet.CardName!.replaceAll("'", "''"),
      "contactName": patchdet.cantactName?.replaceAll("'", "''"),
      "alternateMobileNo":
          patchdet.altermobileNo == null ? null : "${patchdet.altermobileNo}",
      "bilArea": patchdet.area?.replaceAll("'", "''"),
      "customerMobile": "${patchdet.CardCode}",
      "companyName": null,
      "customerEmail": patchdet.U_EMail?.replaceAll("'", "''"),
      "customerGroup": "${patchdet.U_Type}",
      "storeCode": Utils.storecode,
      "address1": patchdet.U_Address1?.replaceAll("'", "''"),
      "address2": patchdet.U_Address2?.replaceAll("'", "''"),
      "pinCode": patchdet.U_Pincode,
      "city": patchdet.U_City?.replaceAll("'", "''"),
      "district": null,
      "state": patchdet.U_State == null || patchdet.U_State!.isEmpty
          ? null
          : "${patchdet.U_State}",
      "country": patchdet.U_Country == null || patchdet.U_Country!.isEmpty
          ? null
          : "${patchdet.U_Country}",
      "potentialvalue": patch.U_PotentialValue,
      //  0,
      "itemCode": null,
      "itemName": null,
      "assignedTo": "${patch.assignedtoslpCode}",
      "refferal": "${patch.U_EnqRefer}",
      "enquiryType": patch.ActivityType,
      "lookingfor": "${patch.U_Lookingfor}",
      "enquirydscription": patchdet.remarks!.replaceAll("'", "''"),
      "quantity": 0,
      "followupOn":
          patch.remainderdate == null ? null : "${patch.remainderdate}",
      "isVisitRequired": "${patch.isvist}",
      "visitTime": patch.sitedate == null ? null : "${patch.sitedate}",
      "remindOn": patch.remainderdate == null ? null : "${patch.remainderdate}"
    };
    Responce res = Responce();

    res = await ServicePost.callApi(meth, Utils.token!, body);
    Map<String, dynamic> jsons = {};
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      jsons = jsonDecode(res.responceBody!);
    }
    return EnqPostApi.fromJson(jsons, res);
  }

  factory EnqPostApi.fromJson(Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return EnqPostApi(
          stcode: res.resCode,
          exception: null,
          resType: jsons["respType"],
          // error: null,
          message: jsons['respDesc']);
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        return EnqPostApi(
            stcode: res.resCode,
            exception: jsons['respDesc'],
            resType: jsons["respCode"] ?? '',
            // error: jsons==null?null: Error.fromJson(jsons['error']),
            message: null);
      } else {
        return EnqPostApi(
            stcode: res.resCode,
            exception: res.responceBody,
            resType: null,
            // error: null,
            message: null);
      }
    }
  }

}

class Error {
  int? code;
  Message? message;
  Error({this.code, this.message});

  factory Error.fromJson(dynamic jsons) {
    return Error(
      code: jsons['code'] as int,
      message: Message.fromJson(jsons['message']),
    );
  }
}

class Message {
  String? lang;
  String? value;
  Message({
    this.lang,
    this.value,
  });

  factory Message.fromJson(dynamic jsons) {
    return Message(
      //  groupCode: jsons['GroupCode'] as int,
      lang: jsons['lang'] as String,
      value: jsons['value'] as String,
    );
  }
}
