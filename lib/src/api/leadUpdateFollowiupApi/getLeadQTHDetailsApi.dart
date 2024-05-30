// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/serviceGetApi.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetLeadDetailsQTHApi {
  GetLeadDeatilsData? leadDeatilheadsData;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  GetLeadDetailsQTHApi(
      {required this.leadDeatilheadsData,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});

  static Future<GetLeadDetailsQTHApi> getData(
    String meth,
  ) async {
    // Sellerkit_Flexi/v2/Leads?leadId=$docentry
    Responce res = Responce();
    res = await ServiceGet.callApi(meth, Utils.token!);
    Map<String, dynamic> jsons = {};
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return GetLeadDetailsQTHApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return GetLeadDetailsQTHApi.fromJson(jsons, res);
  }

  factory GetLeadDetailsQTHApi.fromJson(Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null) {
        var list = json.decode(jsons["data"]) as Map<String, dynamic>;
        // List<GetLeadDeatilsData> dataList =
        //   list.map((data) => GetLeadDeatilsData.fromJson(data)).toList();
        return GetLeadDetailsQTHApi(
            leadDeatilheadsData: GetLeadDeatilsData.fromJson(list),
            message: jsons['respDesc'],
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return GetLeadDetailsQTHApi(
            leadDeatilheadsData: null,
            message: jsons["msg"],
            status: jsons["status"],
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        Map<String, dynamic> jsons = json.decode(res.responceBody!);
        return GetLeadDetailsQTHApi(
            leadDeatilheadsData: null,
            message: jsons['respCode'] ?? '',
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return GetLeadDetailsQTHApi(
            leadDeatilheadsData: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class GetLeadDeatilsData {
  List<GetLeadDeatilsQTHData>? leadcheckQTHdata;
  List<GetLeadQTLData>? leadDeatilsQTLData;
  List<GetLeadDeatilsLData>? leadDeatilsLeadData;
  GetLeadDeatilsData({
    required this.leadcheckQTHdata,
    required this.leadDeatilsQTLData,
    required this.leadDeatilsLeadData,
  });
  factory GetLeadDeatilsData.fromJson(Map<String, dynamic> jsons) {
    if (jsons['LeadMaster'] != null) {
      var list1 = jsons["LeadMaster"] as List;
      List<GetLeadDeatilsQTHData> dataList1 =
          list1.map((data) => GetLeadDeatilsQTHData.fromJson(data)).toList();

      if (jsons["LeadLine"] != null) {
        var list2 = jsons["LeadLine"] as List;
        List<GetLeadQTLData> dataList2 =
            list2.map((data) => GetLeadQTLData.fromJson(data)).toList();

        if (jsons['LeadChecklist'] != null) {
          var list3 = jsons["LeadChecklist"] as List;

          if (list3.isNotEmpty) {
            List<GetLeadDeatilsLData> dataList3 = list3
                .map((data) => GetLeadDeatilsLData.fromJson(data))
                .toList();
            return GetLeadDeatilsData(
                leadcheckQTHdata: dataList1,
                leadDeatilsQTLData: dataList2,
                leadDeatilsLeadData: dataList3);
          } else {
            return GetLeadDeatilsData(
                leadcheckQTHdata: dataList1,
                leadDeatilsQTLData: dataList2,
                leadDeatilsLeadData: null);
          }
        } else {
          return GetLeadDeatilsData(
              leadcheckQTHdata: dataList1,
              leadDeatilsQTLData: dataList2,
              leadDeatilsLeadData: null);
        }
      } else {
        return GetLeadDeatilsData(
            leadcheckQTHdata: dataList1,
            leadDeatilsQTLData: null,
            leadDeatilsLeadData: null);
      }
    } else {
      return GetLeadDeatilsData(
          leadcheckQTHdata: null,
          leadDeatilsQTLData: null,
          leadDeatilsLeadData: null);
    }
  }
}

class GetLeadDeatilsQTHData {
  int? LeadDocEntry;
  // int? FollowupEntry;
  int? LeadNum;
  String? LeadCreatedDate;
  String? LastFUPUpdate;
  String? CardCode;
  String? CardName;
  String? Address1;
  String? Address2;
  String? City;
  String? Pincode;
  double? DocTotal;
  String? nextFollowupDate;
  String? status;

  // String? LastUpdateMessage;
  // String? LastUpdateTime;

  GetLeadDeatilsQTHData(
      {required this.LeadDocEntry,
      required this.LeadNum,
      required this.LeadCreatedDate,
      required this.LastFUPUpdate,
      required this.CardCode,
      required this.CardName,
      required this.Address1,
      required this.Address2,
      required this.City,
      required this.Pincode,
      required this.DocTotal,
      required this.nextFollowupDate,
      required this.status

      // required this.LastUpdateMessage,
      // required this.LastUpdateTime,
      //required this.FollowupEntry
      });

  factory GetLeadDeatilsQTHData.fromJson(Map<String, dynamic> jsons) {
    // if ( jsons["quit"] != null) {

    //     var list = jsons["quit"] as List;
    //      log("quit:"+list.length.toString());
    //     List<GetLeadQTLData> dataList =
    //         list.map((data) => GetLeadQTLData.fromJson(data)).toList();
    return GetLeadDeatilsQTHData(
        LeadDocEntry: jsons['LeadId'] ?? -1,
        LeadNum: jsons['LeadId'] ?? -1,
        LeadCreatedDate: jsons['CreatedDate'] ?? '',
        LastFUPUpdate: jsons['UpdatedDate'] ?? '',
        CardCode: jsons['CustomerCode'] ?? '',
        CardName: jsons['CustomerName'] ?? '',
        Address1: jsons['Address1'] ?? '',
        Address2: jsons['Address2'] ?? '',
        City: jsons['City'] ?? '',
        Pincode: jsons['Pincode'].toString() ?? '',
        DocTotal: jsons['LeadValue'] ?? 0.00,
        nextFollowupDate: jsons['NextFollowupDate'] ?? '',
        status: jsons['Status'] ?? '');
  }
}

class GetLeadQTLData {
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  double? Price;
  double? Info_SP;
  double? Cost;
  double? StoreStock;
  double? WhseStock;
  bool? isFixedPrice;
  bool? AllowOrderBelowCost;
  bool? AllowNegativestock;
  GetLeadQTLData({
    required this.Info_SP,
    required this.Cost,
    required this.StoreStock,
    required this.WhseStock,
    required this.isFixedPrice,
    required this.AllowOrderBelowCost,
    required this.AllowNegativestock,
    required this.ItemCode,
    required this.ItemName,
    required this.Quantity,
    required this.Price,
  });
  factory GetLeadQTLData.fromJson(Map<String, dynamic> json) => GetLeadQTLData(
        Info_SP: json['SP'] ?? 0.00,
        Cost: json['Price'] ?? 0.00,
        StoreStock: json['StoreStock'] ?? 0.00,
        WhseStock: json['WhseStock'] ?? 0.00,
        isFixedPrice: json['isFixedPrice'] ?? false,
        AllowNegativestock: json['AllowNegativeStock'] ?? false,
        AllowOrderBelowCost: json['AllowOrderBelowCost'] ?? false,
        ItemCode: json['ItemCode'] ?? '',
        ItemName: json['ItemName'] ?? '',
        Quantity: json['Quantity'] ?? 0.0,
        Price: json['Price'] ?? 0.00,
      );
}

class GetLeadDeatilsLData {
  String? FollowMode;
  String? Followup_Date_Time;
  String? Status;
  String? Feedback;
  int? FollowupEntry;
  int? LeadDocEntry;
  String? NextFollowup_Date;
  String? UpdatedBy;

  GetLeadDeatilsLData(
      {required this.FollowMode,
      required this.Followup_Date_Time,
      required this.Status,
      required this.Feedback,
      required this.FollowupEntry,
      required this.LeadDocEntry,
      required this.NextFollowup_Date,
      required this.UpdatedBy});

  factory GetLeadDeatilsLData.fromJson(Map<String, dynamic> json) =>
      GetLeadDeatilsLData(
        FollowMode: json['FollowupMode'],
        // ':
        // json['FollowupMode']== '02'?'Store Visit':json['FollowupMode']== '03'?'Sms/WhatsApp':
        // json['FollowupMode']== '04'?'Other':'',
        Followup_Date_Time: json['FollowupDate'] ?? '',
        Status: json['ReasonType'] ?? '',
        Feedback: json['Feedback'] ?? '',
        FollowupEntry: json['followupEntry'] ?? -1,
        LeadDocEntry: json['leadDocEntry'] ?? -1,
        NextFollowup_Date: json['NextFollowupDate'] ?? '',
        UpdatedBy: json['FollowupBy'],
      );
}
