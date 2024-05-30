import 'dart:convert';

import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetLeadopenApi {
  List<GetLeadopenData>? leadopendata;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  GetLeadopenApi(
      {required this.leadopendata,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
  static Future<GetLeadopenApi> getData(String meth) async {
    // SkClientPortal/GetallMaster?MasterTypeId=8
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> jsons = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return GetLeadopenApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return GetLeadopenApi.fromJson(jsons, res);
  }

  factory GetLeadopenApi.fromJson(List<dynamic> jsons, Responce res) {
    if (jsons != null && jsons.isNotEmpty) {
      var list = jsons as List;

      List<GetLeadopenData> dataList =
          list.map((data) => GetLeadopenData.fromJson(data)).toList();

      return GetLeadopenApi(
          leadopendata: dataList,
          message: "Success",
          status: true,
          stcode: res.resCode,
          exception: null);
    } else {
      return GetLeadopenApi(
          leadopendata: null,
          message: "Failure",
          status: false,
          stcode: res.resCode,
          exception: null);
    }
  }

  factory GetLeadopenApi.error(String jsons, int stcode) {
    return GetLeadopenApi(
        leadopendata: null,
        message: 'Exception',
        status: null,
        stcode: stcode,
        exception: jsons);
  }
}

class GetLeadopenData {
  int? id;
  int? masterTypeId;

  String? code;
  String? name;

  GetLeadopenData(
      {required this.code, required this.name, this.id, this.masterTypeId});

  factory GetLeadopenData.fromJson(Map<String, dynamic> json) =>
      GetLeadopenData(
        id: json['id'],
        masterTypeId: json['masterTypeId'],
        code: json['code'] ?? '',
        name: json['description'] ?? '',
      );

//   Map<String, Object?> toMap() => {
//         LeadStatusReason.code: code,
//         LeadStatusReason.name: name,
//         LeadStatusReason.statusType: statusType,
//       };
}

class namedata {
  String? name;
  namedata({
    required this.name,
  });
}
