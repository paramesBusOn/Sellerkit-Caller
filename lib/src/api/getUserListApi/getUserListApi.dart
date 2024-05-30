import 'dart:convert';

import 'package:http/http.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class UserListGetApi {
  List<UserListData>? userLtData;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  UserListGetApi(
      { this.userLtData,
       this.message,
       this.status,
      this.exception,
       this.stcode});

  Future<UserListGetApi> getData(
    String meth,
  ) async {
    // Sellerkit_Flexi/v2/GetAllUsers?userId=$sapUserId
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> jsons = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      jsons = jsonDecode(res.responceBody!);
    }
    return UserListGetApi.fromJson(jsons, res);
  }

  factory UserListGetApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<UserListData> dataList =
            list.map((data) => UserListData.fromJson(data)).toList();
        return UserListGetApi(
            userLtData: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return UserListGetApi(
            userLtData: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 210 && res.resCode! >= 200) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return UserListGetApi(
            userLtData: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return UserListGetApi(
            userLtData: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class UserListData {
  UserListData(
      {required this.storeid,
      // required this.UserKey,
      required this.mngSlpcode,
      required this.userCode,
      required this.UserName,
      required this.color,
      required this.slpcode,
      required this.SalesEmpID});

  // int? UserKey;
  String? userCode;
  String? slpcode;
  String? mngSlpcode;
  int? storeid;
  String? UserName;
  int? color;
  int? SalesEmpID;
  // int?EmployeeID;

  factory UserListData.fromJson(Map<String, dynamic> json) => UserListData(
      //  UserKey: json['UserKey'] ??0,
      storeid: json["storeId"] ?? '',
      slpcode: json['slpCode'] ?? '',
      mngSlpcode: json['reportingTo'] ?? '', //reportingTo
      SalesEmpID: json['id'] ?? 0,
      userCode: json['userCode'],
      //  EmployeeID: json['EmployeeID'] ??0,
      //  UserCode: json['UserCode'] ?? '', ̰
      UserName: json['userName'] ?? '',
      color: 0);

  Map<String, Object?> toMap() => {
        // UserListDBModel.userKey:UserKey,
        UserListDBModel.userCode: userCode,
        UserListDBModel.slpcode: slpcode,
        UserListDBModel.userName: UserName,
        UserListDBModel.managerSlp: mngSlpcode,
        UserListDBModel.salesEmpID: SalesEmpID,
        UserListDBModel.color: color,
        UserListDBModel.storeid: storeid
      };
}
