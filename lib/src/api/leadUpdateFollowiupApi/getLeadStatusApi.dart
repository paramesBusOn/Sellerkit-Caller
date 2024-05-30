import 'dart:convert';

import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetLeadStatusApi {
  List<GetLeadStatusData>? leadcheckdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  GetLeadStatusApi(
      {this.leadcheckdata,
      this.message,
      this.status,
      this.exception,
      this.stcode});

   Future<GetLeadStatusApi> getData(String meth) async {
    // SkClientPortal/GetallMaster?MasterTypeId=14
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> jsons = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return GetLeadStatusApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return GetLeadStatusApi.fromJson(jsons, res);
  }

  factory GetLeadStatusApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;

        List<GetLeadStatusData> dataList =
            list.map((data) => GetLeadStatusData.fromJson(data)).toList();

        return GetLeadStatusApi(
            leadcheckdata: dataList,
            message: "Success",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return GetLeadStatusApi(
            leadcheckdata: null,
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return GetLeadStatusApi(
            leadcheckdata: null,
            message: jsons["respCode"],
            status: null,
            stcode: res.resCode,
            exception: jsons["respDesc"]);
      } else {
        return GetLeadStatusApi(
            leadcheckdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody!);
      }
    }
  }
}

class GetLeadStatusData {
  int? id;
  int? masterTypeId;

  String? code;
  String? name;
  int? statusType;
  int? status;

  GetLeadStatusData(
      {required this.code,
      required this.name,
      required this.statusType,
      this.id,
      this.status,
      this.masterTypeId});

  factory GetLeadStatusData.fromJson(Map<String, dynamic> json) =>
      GetLeadStatusData(
        status: json['status'],
        id: json['id'],
        masterTypeId: json['masterTypeId'],
        code: json['code'] ?? '',
        name: json['description'] ?? '',
        statusType: json['nextStatus'] ?? '',
      );

  Map<String, Object?> toMap() => {
        LeadStatusReason.code: code,
        LeadStatusReason.name: name,
        LeadStatusReason.statusType: statusType,
      };
}

class namedata {
  String? name;
  namedata({
    required this.name,
  });
}
