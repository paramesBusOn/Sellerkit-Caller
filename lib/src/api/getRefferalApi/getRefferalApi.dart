// ignore_for_file: unnecessary_cast

import 'dart:convert';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class EnqRefferesApi {
  List<EnqRefferesData>? enqReffersdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  EnqRefferesApi(
      { this.enqReffersdata,
       this.message,
       this.status,
      this.exception,
       this.stcode});

  Future<EnqRefferesApi> getData(
    String meth,
  ) async {
    //SkClientPortal/GetallMaster?MasterTypeId=3
    Responce res = Responce();

    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> json = [];
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      json = jsonDecode(res.responceBody!);
    }
    return EnqRefferesApi.fromJson(json, res);
  }

  factory EnqRefferesApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<EnqRefferesData> dataList =
            list.map((data) => EnqRefferesData.fromJson(data)).toList();
        return EnqRefferesApi(
            enqReffersdata: dataList,
            message: "true",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return EnqRefferesApi(
            enqReffersdata: null,
            message: "false",
            status: false,
            stcode: res.resCode,
            exception: "Error");
      }
    } else {
      if (res.resCode! >= 400 && res.resCode! <= 410) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return EnqRefferesApi(
            enqReffersdata: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return EnqRefferesApi(
            enqReffersdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody.toString());
      }
    }
  }

  
}

class EnqRefferesData {
  EnqRefferesData({
    required this.Code,
    required this.Name,
  });

  String? Code;
  String? Name;

  factory EnqRefferesData.fromJson(Map<String, dynamic> json) =>
      EnqRefferesData(
        Code: json['code'] ?? '',
        Name: json['description'] ?? '',
      );

  Map<String, Object?> toMap() => {
        EnqTypeDBModel.code: Code,
        EnqTypeDBModel.name: Name,
      };
}
