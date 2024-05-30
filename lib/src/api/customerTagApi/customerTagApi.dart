// ignore_for_file: unnecessary_null_comparison, unnecessary_cast

import 'dart:convert';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class CustomerTagApi {
  List<CustomerTagTypeData2>? itemdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  CustomerTagApi(
      { this.itemdata,
       this.message,
       this.status,
      this.exception,
       this.stcode});

  Future<CustomerTagApi> getData(
    String meth,
  ) async {
    //SkClientPortal/GetallMaster?MasterTypeId=4
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> jsons = [];
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      jsons = jsonDecode(res.responceBody!);
    }
    return CustomerTagApi.fromJson(jsons, res);
  }

  factory CustomerTagApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<CustomerTagTypeData2> dataList =
            list.map((data) => CustomerTagTypeData2.fromJson(data)).toList();
        return CustomerTagApi(
            itemdata: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return CustomerTagApi(
            itemdata: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! >= 400 && res.resCode! <= 410) {
        Map<String, dynamic> js = json.decode(res.responceBody!);
        return CustomerTagApi(
            itemdata: null,
            message: js['respCode'],
            status: null,
            stcode: res.resCode!,
            exception: js['respDesc']);
      } else {
        return CustomerTagApi(
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class CustomerTagTypeData2 {
  CustomerTagTypeData2({
    required this.Code,
    required this.Name,
  });

  String? Code;
  String? Name;

  factory CustomerTagTypeData2.fromJson(Map<String, dynamic> json) =>
      CustomerTagTypeData2(
        Code: json['code'] ?? 00,
        Name: json['description'] ?? '',
      );

  Map<String, Object?> toMap() => {
        CusTagTypeDBModel.code: Code,
        CusTagTypeDBModel.name: Name,
      };
}
