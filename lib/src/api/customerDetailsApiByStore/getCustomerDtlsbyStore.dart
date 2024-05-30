import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class CutomerdetModalApi {
  CustomerdetData? leadcheckdata;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  CutomerdetModalApi(
      {required this.leadcheckdata,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
  static Future<CutomerdetModalApi> getData(String meth) async {
    // SkClientPortal/GetstoresbyId?Id=${ConstantValues.storeid}
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    Map<String, dynamic> jsons = {};
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return CutomerdetModalApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return CutomerdetModalApi.fromJson(jsons, res);
  }

  factory CutomerdetModalApi.fromJson(
      Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        // var list = jsons as List;
        // List<FeedsModalData> dataList =
        //     list.map((data) => FeedsModalData.fromJson(data)).toList();
        return CutomerdetModalApi(
            leadcheckdata: CustomerdetData.fromJson(jsons),
            message: "Success",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return CutomerdetModalApi(
            leadcheckdata: null,
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      return CutomerdetModalApi(
          leadcheckdata: null,
          message: 'Exception',
          status: null,
          stcode: res.resCode,
          exception: res.responceBody);
    }
  }
}

class CustomerdetData {
  int? id;
  String? cardCode;
  String? cardName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? gstin;
  CustomerdetData(
      {required this.address1,
      required this.address2,
      required this.cardCode,
      required this.cardName,
      required this.city,
      required this.country,
      required this.gstin,
      required this.id,
      required this.pincode,
      required this.state});

  factory CustomerdetData.fromJson(Map<String, dynamic> jsons) =>
      CustomerdetData(
          address1: jsons['address1'] ?? '',
          address2: jsons['address2'] ?? '',
          cardCode: jsons['cardCode'] ?? '',
          cardName: jsons['storeName'] ?? '',
          city: jsons['city'],
          country: jsons['country'] ?? '',
          gstin: jsons['gstNo'] ?? '',
          id: jsons['id'] ?? 0,
          pincode: jsons['pinCode'] ?? '',
          state: jsons['state'] ?? '');
}
