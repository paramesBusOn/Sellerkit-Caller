// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class ItemMasterCategoryApi {
  List<String>? itemdata;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  ItemMasterCategoryApi(
      {required this.itemdata,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});

  static Future<ItemMasterCategoryApi> getData(String meth) async {
    //  SkClientPortal/GetCatogeryList
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    String json = '';
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      json = res.responceBody!.toString();
    }
    return ItemMasterCategoryApi.fromJson(json, res);
  }

  factory ItemMasterCategoryApi.fromJson(String jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons != null && jsons.isNotEmpty) {
              List<dynamic> list = json.decode(jsons) ;

        List<String> dataList = list.map((data) => data.toString()).toList();

        return ItemMasterCategoryApi(
            itemdata: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return ItemMasterCategoryApi(
            itemdata: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      return ItemMasterCategoryApi(
          itemdata: null,
          message: 'Exception',
          status: null,
          stcode: res.resCode,
          exception: res.responceBody);
    }
  }
}
