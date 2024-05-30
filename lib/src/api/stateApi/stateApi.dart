import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/stateDBModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class StateDetailsApi {
  stateHeader? itemdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  StateDetailsApi(
      {this.itemdata, this.message, this.status, this.exception, this.stcode});

  Future<StateDetailsApi> getData(String meth) async {
// Sellerkit_Flexi/v2/Statelist
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    Map<String, dynamic> jsons = {};
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      jsons = jsonDecode(res.responceBody!);
    }
    return StateDetailsApi.fromJson(jsons, res);
  }

  factory StateDetailsApi.fromJson(Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
       
        return StateDetailsApi(
            itemdata: stateHeader.fromJson(jsons),
            message: "Success",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return StateDetailsApi(
            itemdata: null,
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 210 && res.resCode! >= 200) {
        return StateDetailsApi(
            itemdata: null,
            message: jsons['respType'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return StateDetailsApi(
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class stateHeader {
  stateHeader(
      {required this.respCode,
      required this.datadetail,
      required this.respDesc,
      required this.respType

      // required this.customertag
      });

  String? respType;
  String? respCode;
  String? respDesc;
  List<StateHeaderData>? datadetail;

  factory stateHeader.fromJson(Map<String, dynamic> jsons) {
    //  if (jsons["data"] != null) {
    var list = json.decode(jsons["data"]) as List;
    if (list.isEmpty) {
      return stateHeader(
          respCode: jsons['respCode'],
          datadetail: null,
          respDesc: jsons['respDesc'],
          respType: jsons['respType']);
    } else {
      List<StateHeaderData> dataList =
          list.map((data) => StateHeaderData.fromJson(data)).toList();
      return stateHeader(
          respCode: jsons['respCode'],
          datadetail: dataList,
          respDesc: jsons['respDesc'],
          respType: jsons['respType']);
    }
  }
}

class StateHeaderData {
  String? statecode;
  String? stateName; //
  String? countrycode; //
  String? countryname; //

  StateHeaderData({
    required this.statecode,
    required this.stateName,
    required this.countrycode,
    required this.countryname,
  });
  factory StateHeaderData.fromJson(Map<String, dynamic> json) =>
      StateHeaderData(
        statecode: json['StateCode'] ?? 0, //
        stateName: json['StateName'] ?? '', //
        countrycode: json['CountryCode'] ?? '', //
        countryname: json['CountryName'] ?? '', //
      );

  Map<String, Object?> toMap() => {
        StateMasterDB.statecode: statecode,
        StateMasterDB.statename: stateName,
        StateMasterDB.cuntrycode: countrycode,
        StateMasterDB.countryname: countryname,
      };
}
