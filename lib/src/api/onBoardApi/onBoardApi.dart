import 'dart:convert';

import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';
import 'package:http/http.dart' as http;

class OnBoardApi {
  List<onBoardData>? itemdata;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  OnBoardApi(
      {required this.itemdata,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});

  static Future<OnBoardApi> getData(String meth) async {
    // http://164.52.217.188:81/api/PortalAuthenticate/GetInitialContent
    Responce res = Responce();
    // res = await ServiceGet.callApi(meth, Utils.token!);
    final responce = await http.get(
      Uri.parse(
          'http://164.52.217.188:81/api/PortalAuthenticate/GetInitialContent'),
      headers: {"Content-Type": "application/json"},
    );
    res.resCode = responce.statusCode;
    res.responceBody = responce.body;
    List<dynamic> jsons = [];

    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return OnBoardApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return OnBoardApi.fromJson(jsons, res);
  }

  factory OnBoardApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<onBoardData> dataList =
            list.map((data) => onBoardData.fromJson(data)).toList();
        return OnBoardApi(
            itemdata: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return OnBoardApi(
            itemdata: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      return OnBoardApi(
          itemdata: null,
          message: 'Exception',
          status: null,
          stcode: res.resCode,
          exception: res.responceBody);
    }
  }

  // factory OnBoardApi.issues(Map<String, dynamic> jsons, int stcode) {
  //   return OnBoardApi(
  //       itemdata: null,
  //       message: jsons['respCode'],
  //       status: null,
  //       stcode: stcode,
  //       exception: jsons['respDesc']);
  // }

  // factory OnBoardApi.error(String jsons, int stcode) {
  //   return OnBoardApi(
  //       itemdata: null,
  //       message: 'Exception',
  //       status: null,
  //       stcode: stcode,
  //       exception: jsons);
  // }
}

class onBoardData {
  onBoardData(
      {required this.id,
      required this.loadContent,
      required this.urL1,
      required this.urL2,
      required this.urL3,
      required this.urL4,
      required this.urL5});
  int? id;
  String? loadContent;
  String? urL1;
  String? urL2;
  String? urL3;
  String? urL4;
  String? urL5;

  factory onBoardData.fromJson(Map<String, dynamic> json) => onBoardData(
      id: json['id'] ?? 0,
      loadContent: json['loadContent'] ?? "",
      urL1: json['urL1'] ?? "",
      urL2: json['urL2'] ?? "",
      urL3: json['urL3'] ?? "",
      urL4: json['urL4'] ?? "",
      urL5: json['urL5'] ?? "");
}
