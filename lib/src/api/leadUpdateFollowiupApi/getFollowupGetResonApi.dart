import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetLeadFollowupResonApi {
  List<GetLeadPhoneData>? leadphonedata;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  GetLeadFollowupResonApi(
      {required this.leadphonedata,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
  static Future<GetLeadFollowupResonApi> getData(String meth) async {
    // SkClientPortal/GetallMaster?MasterTypeId=15
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> jsons = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return GetLeadFollowupResonApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return GetLeadFollowupResonApi.fromJson(jsons, res);
  }

  factory GetLeadFollowupResonApi.fromJson(List<dynamic> jsons, Responce res) {
    if (jsons != null && jsons.isNotEmpty) {
      var list = jsons as List;

      List<GetLeadPhoneData> dataList =
          list.map((data) => GetLeadPhoneData.fromJson(data)).toList();

      return GetLeadFollowupResonApi(
          leadphonedata: dataList,
          message: "Success",
          status: true,
          stcode: res.resCode,
          exception: null);
    } else {
      return GetLeadFollowupResonApi(
          leadphonedata: null,
          message: "Failure",
          status: false,
          stcode: res.resCode,
          exception: null);
    }
  }

  factory GetLeadFollowupResonApi.error(String jsons, int stcode) {
    return GetLeadFollowupResonApi(
        leadphonedata: null,
        message: 'Exception',
        status: null,
        stcode: stcode,
        exception: jsons);
  }
}

class GetLeadPhoneData {
  int? id;
  int? masterTypeId;

  String? code;
  String? name;

  GetLeadPhoneData(
      {required this.code, required this.name, this.id, this.masterTypeId});

  factory GetLeadPhoneData.fromJson(Map<String, dynamic> json) =>
      GetLeadPhoneData(
        id: json['id'],
        masterTypeId: json['masterTypeId'],
        code: json['code'] ?? '',
        name: json['description'] ?? '',
      );

  // Map<String, Object?> toMap() => {
  //       LeadStatusReason.code: code,
  //       LeadStatusReason.name: name,
  //       LeadStatusReason.statusType: statusType,
  //     };
}

class namedata {
  String? name;
  namedata({
    required this.name,
  });
}
