import 'dart:convert';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class ForwardLeadUserApi {
  int stCode;
  String? error;

  ForwardLeadUserApi({required this.stCode, this.error});
  static Future<ForwardLeadUserApi> getData(
      String meth, ForwardLeadUserApiData ForwardLeadUserApiData) async {
    // SkClientPortal/Updateleadfollowlinecollection?leaddocentry=$followupEntry

    Map<String, dynamic> body = {
      "id": 0,
      "docEntry": 0,
      "lineId": 0,
      "visOrder": 0,
      "object": "",
      "logInst": 0,
      "uUpdateType": "ManualLeadForward",
      "uUpdateDateTime": "${ForwardLeadUserApiData.curentDate}",
      "uUpdatedBy": Utils.slpcode,
      "uFollowupMode": "others",
      "reasonType": '',
      "uReasonCode": "",
      "uNextFollowupDate": "${ForwardLeadUserApiData.nextFD}",
      "uFeedback": "",
      "uRef1": "",
      "uRef2": "",
      "uNextUser": "${ForwardLeadUserApiData.nextUser}",
      "uRefDate": "2023-08-19T10:59:22.887Z"
    };

    Responce res = Responce();
    res = await ServicePost.callApi(meth, Utils.token!, body);
    Map<String, dynamic> json = {};
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return ForwardLeadUserApi.fromjson(jsonDecode(res.responceBody!), res);
    }
    return ForwardLeadUserApi.fromjson(json, res);
  }

  factory ForwardLeadUserApi.fromjson(Map<String, dynamic> json, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return ForwardLeadUserApi(
        stCode: res.resCode!,
        error: json['respDesc'],
      );
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        Map<String, dynamic> json = jsonDecode(res.responceBody!);
        return ForwardLeadUserApi(stCode: res.resCode!, error: res.responceBody);
      } else {
        return ForwardLeadUserApi(
          stCode: res.resCode!,
          error: res.responceBody!,
        );
      }
    }
  }
}

class ForwardLeadUserApiData {
  String? curentDate;
  String? nextFD;
  int? nextUser;
  ForwardLeadUserApiData({this.curentDate, this.nextFD, this.nextUser});
}
