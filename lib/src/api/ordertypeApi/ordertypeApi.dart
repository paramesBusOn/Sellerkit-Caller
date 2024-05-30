// ignore_for_file: unnecessary_null_comparison, unnecessary_cast

import 'dart:convert';

import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class OrderTypeApi {
  List<OrderTypeData>? itemdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  OrderTypeApi(
      {this.itemdata, this.message, this.status, this.exception, this.stcode});

  Future<OrderTypeApi> getData(
    String meth,
  ) async {
//  SkClientPortal/GetallMaster?MasterTypeId=21
    Utils.token = await HelperFunctions.getTokenSharedPreference();
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> json = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      json = jsonDecode(res.responceBody!);
    }
    return OrderTypeApi.fromJson(json, res);
  }

  factory OrderTypeApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<OrderTypeData> dataList =
            list.map((data) => OrderTypeData.fromJson(data)).toList();
        return OrderTypeApi(
            itemdata: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return OrderTypeApi(
            itemdata: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return OrderTypeApi(
            itemdata: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return OrderTypeApi(
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }

  factory OrderTypeApi.issues(Map<String, dynamic> jsons, int stcode) {
    return OrderTypeApi(
        itemdata: null,
        message: jsons['respCode'],
        status: null,
        stcode: stcode,
        exception: jsons['respDesc']);
  }
}

class OrderTypeData {
  OrderTypeData({
    required this.Code,
    required this.Name,
  });

  String? Code;
  String? Name;

  factory OrderTypeData.fromJson(Map<String, dynamic> json) => OrderTypeData(
        Code: json['code'] ?? 00,
        Name: json['description'] ?? '',
      );

  Map<String, Object?> toMap() => {
        OrderTypeDBModel.code: Code,
        OrderTypeDBModel.name: Name,
      };
}
