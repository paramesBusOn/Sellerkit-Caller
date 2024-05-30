import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class PaymodeApi {
  List<PaymodeApiData>? paymode;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  PaymodeApi(
      {required this.paymode,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});

  static Future<PaymodeApi> getData(
    String meth,
  ) async {
    //  SkClientPortal/GetallMaster?MasterTypeId=18
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> jsons = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      jsons = jsonDecode(res.responceBody!);
    }

    return PaymodeApi.fromJson(jsons, res);
  }

  factory PaymodeApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<PaymodeApiData> dataList =
            list.map((data) => PaymodeApiData.fromJson(data)).toList();
        return PaymodeApi(
            paymode: dataList,
            message: "Success",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return PaymodeApi(
            paymode: null,
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        return PaymodeApi(
            paymode: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      } else {
        return PaymodeApi(
            paymode: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class PaymodeApiData {
  PaymodeApiData(
      {required this.CODE,
      required this.color,
      required this.createdBy,
      required this.createdOn,
      required this.description,
      required this.id,
      required this.mastertypeid,
      required this.parentMasterId,
      required this.status,
      required this.updatedBy,
      required this.updatedOn});

  String? CODE;
  int? color;
  int? id;
  int? mastertypeid;
  String? description;
  int? parentMasterId;
  int? status;
  int? createdBy;
  String? createdOn;
  int? updatedBy;
  String? updatedOn;

  factory PaymodeApiData.fromJson(Map<String, dynamic> json) => PaymodeApiData(
      CODE: json['code'],
      color: 0,
      createdBy: json['createdBy'],
      createdOn: json['createdOn'] ?? '',
      description: json['description'],
      id: json['id'],
      mastertypeid: json['masterTypeId'],
      parentMasterId: json['parentMasterId'],
      status: json['status'],
      updatedBy: json['updatedBy'],
      updatedOn: json['updatedOn']);
}
