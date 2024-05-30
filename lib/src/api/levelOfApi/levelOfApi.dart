// ignore_for_file: unnecessary_null_comparison, unnecessary_cast

import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class LevelOfApi {
  List<LevelofData>? itemdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  LevelOfApi(
      {this.itemdata, this.message, this.status, this.exception, this.stcode});

   Future<LevelOfApi> getData(
    String meth,
  ) async {
    // SkClientPortal/GetallMaster?MasterTypeId=20
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);

    List<dynamic> json = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      json = jsonDecode(res.responceBody!);
    }
    return LevelOfApi.fromJson(json, res);
  }

  factory LevelOfApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<LevelofData> dataList =
            list.map((data) => LevelofData.fromJson(data)).toList();
        return LevelOfApi(
            itemdata: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return LevelOfApi(
            itemdata: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return LevelOfApi(
            itemdata: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return LevelOfApi(
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class LevelofData {
  LevelofData({
    required this.code,
    required this.name,
  });

  String? code;
  String? name;

  factory LevelofData.fromJson(Map<String, dynamic> json) => LevelofData(
        code: json['code'] ?? 00,
        name: json['description'] ?? '',
      );

  Map<String, Object?> toMap() => {
        CusLevelDBModel.code: code,
        CusLevelDBModel.name: name,
      };
}
