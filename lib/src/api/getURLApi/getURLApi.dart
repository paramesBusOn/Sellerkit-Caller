// ignore_for_file: unnecessary_new, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetURLApi {
  String? url;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  GetURLApi(
      {required this.url,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
  static Future<GetURLApi> getData(String? meth) async {
    Responce res = Responce();
    // var body = postLoginData.toJson();

    res = await ServicePostNoBody.callApi(meth!,'');

    String jsons = '';
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      jsons = res.responceBody.toString();
    }
    return GetURLApi.fromJson(jsons.toString(), res);
  }

  factory GetURLApi.fromJson(String jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons.isNotEmpty) {
        return GetURLApi(
            url: jsons,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return GetURLApi(
            url: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! >= 400 && res.resCode! <= 410) {
        return GetURLApi(
          url: null,
          message: 'Exception',
          status: null,
          stcode: res.resCode,
          exception: res.responceBody,
        );
      } else {
        return GetURLApi(
            url: null,
            message: 'Catch',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}
