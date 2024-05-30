import 'dart:convert';
import 'dart:developer';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class CheckEnqDetailsApi {
  List<CheckEnqDetailsData>? checkEnqDetailsData;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  CheckEnqDetailsApi(
      {required this.checkEnqDetailsData,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
 
  static Future<CheckEnqDetailsApi> getData(
      String meth) async {
    // SkClientPortal/Chkenquiry?phone=$phoneNO&Slpcode=$sapUserId

    Responce res = Responce();
    res = await ServicePostNoBody.callApi(meth, Utils.token!);
    String jsons = '';
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      jsons = res.responceBody.toString();
    }
    return CheckEnqDetailsApi.fromJson(jsons, res);
  }

  factory CheckEnqDetailsApi.fromJson(String? jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons!.isEmpty) {
        return CheckEnqDetailsApi(
            checkEnqDetailsData: null,
            message: "Success",
            status: false,
            stcode: res.resCode,
            exception: null);
      } else {
        var list = json.decode(jsons) as List;
        log("list" + list.toString());
        List<CheckEnqDetailsData> dataList =
            list.map((data) => CheckEnqDetailsData.fromJson(data)).toList();
        return CheckEnqDetailsApi(
            checkEnqDetailsData: dataList,
            message: "Success",
            status: true,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      return CheckEnqDetailsApi(
          checkEnqDetailsData: null,
          message: "Error",
          status: false,
          stcode: res.resCode,
          exception: res.responceBody);
    }
  }
}

class CheckEnqDetailsData {
  CheckEnqDetailsData({
    required this.Type,
    required this.DocEntry,
    required this.Current_Branch,
    required this.User_Branch,
  });

  String? Type;
  int? DocEntry;
  currentbranch? Current_Branch;
  String? User_Branch;

  factory CheckEnqDetailsData.fromJson(Map<String, dynamic> json) =>
      CheckEnqDetailsData(
        Type: json['type'] ?? '',
        DocEntry: json['docEntry'] ?? 0,
        Current_Branch: currentbranch.fromJson(json['currentbranch']),
        User_Branch: json['userbranch'] ?? '',
      );
}

class currentbranch {
  String? currentBranch;
  currentbranch({
    this.currentBranch,
  });
  factory currentbranch.fromJson(Map<String, dynamic> json) {
    return currentbranch(currentBranch: json['currentbranch']);
  }
}
