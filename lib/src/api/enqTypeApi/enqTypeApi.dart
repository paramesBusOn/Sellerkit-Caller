// ignore_for_file: unnecessary_null_comparison, unnecessary_cast

import 'dart:convert';
import 'package:http/http.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class EnquiryTypeApi {
  List<EnquiryTypeData>? itemdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  EnquiryTypeApi(
      {this.itemdata, this.message, this.status, this.exception, this.stcode});

  Future<EnquiryTypeApi> getData(
    String meth,
  ) async {
    // SkClientPortal/GetallMaster?MasterTypeId=2
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    List<dynamic> json = [];
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      json = jsonDecode(res.responceBody!);
    }
    return EnquiryTypeApi.fromJson(json, res);
  }

  factory EnquiryTypeApi.fromJson(List<dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null && jsons.isNotEmpty) {
        var list = jsons as List;
        List<EnquiryTypeData> dataList =
            list.map((data) => EnquiryTypeData.fromJson(data)).toList();
        return EnquiryTypeApi(
            itemdata: dataList,
            message: "sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return EnquiryTypeApi(
            itemdata: null,
            message: "failed",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 210 && res.resCode! >= 200) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return EnquiryTypeApi(
            itemdata: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return EnquiryTypeApi(
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class EnquiryTypeData {
  EnquiryTypeData({
    required this.Code,
    required this.Name,
  });

  String? Code;
  String? Name;

  factory EnquiryTypeData.fromJson(Map<String, dynamic> json) =>
      EnquiryTypeData(
        Code: json['code'] ?? 00,
        Name: json['description'] ?? '',
      );

  Map<String, Object?> toMap() => {
        EnqTypeDBModel.code: Code,
        EnqTypeDBModel.name: Name,
      };
}
class PatchExCus
{
  int? id;
  String?custcode;
  String? CardCode;
  String? CardName;
  String? CardType;
  String? U_Address1;
  String? U_Address2;
  String? U_Address3;
  String? U_City;
  String? U_Pincode;
  String? U_State;
  String? U_ShipAddress1;
  String? U_ShipAddress2;
  String? U_ShipAddress3;
  String? U_Shiparea;
  String? U_ShipCity;
  String? U_ShipPincode;
  String? U_ShipCountry;
  String? U_ShipState;
  String? U_Country;
  String? U_Facebook;
  String? U_EMail;
  String? U_Type;
  String? cantactName;
  String? altermobileNo;
  String? gst;
  double? potentialvalue;
  String? remarks;
  String? levelof;
  String? ordertype;
  
  String? area;
  String? state;
  int? docent;
  int? ordernum;
  int? enqid;
  int? enqtype;
  
  
  // String? U;






  PatchExCus({
    this.remarks,
    this.levelof,
    this.ordertype,
    this.enqtype,
    this.enqid,
    this.docent,
    this.ordernum,
    this.U_ShipCountry,
    this.area,
    this.state,
    this.cantactName,
    this.custcode,
    this.id,
this.CardCode,
this.CardName,
this.CardType,
this.U_Address1,
this.U_Address2,
this.U_Address3,

this.U_City,
this.U_Country,
this.U_EMail,
this.U_Facebook,
this.U_Pincode,
this.U_State,
this.U_Type

  });

}

class PostEnq
{
  String? CardCode;
  String? Activity;
  String? ActivityType;
  String? U_Lookingfor;
  double? U_PotentialValue;
  String? U_AssignedTo;
  String? U_EnqStatus;
  String? U_EnqRefer;
  String? assignedtoslpCode;
  String? assignedtoManagerSlpCode;
  String? isvist;
  String? sitedate;
  String? remainderdate;




  PostEnq({
this.CardCode,
this.Activity,
this.ActivityType,
this.U_Lookingfor,
this.U_PotentialValue,
this.U_AssignedTo,
this.U_EnqStatus,
this.U_EnqRefer,
this.assignedtoslpCode,
this.isvist,
this.sitedate,
this.remainderdate,
  });

}