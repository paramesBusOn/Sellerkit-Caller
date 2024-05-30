// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/leadUpdateFollowiupApi/farwordLeadApi.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class AllSaveLeadApi {
  static Future<ForwardLeadUserApi> getData(
      String meth, leadDocEntry, AllSaveLeadApi ForwardLeadUserApiData) async {
    // Sellerkit_Flexi/v2/FollowupUpdate

    Map<String, dynamic> body = {
      "leadid": leadDocEntry,
      "followupdate": ForwardLeadUserApiData.curentDate == null ||
              ForwardLeadUserApiData.curentDate!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.curentDate}",
      "followupmode": ForwardLeadUserApiData.followupMode == null ||
              ForwardLeadUserApiData.followupMode!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.followupMode}",
      "status": ForwardLeadUserApiData.status == null ||
              ForwardLeadUserApiData.status!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.status}",
      "reasoncode": ForwardLeadUserApiData.ReasonCode == null ||
              ForwardLeadUserApiData.ReasonCode!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.ReasonCode}",
      "planofpurchase": ForwardLeadUserApiData.Purchasedate == null ||
              ForwardLeadUserApiData.Purchasedate == '' ||
              ForwardLeadUserApiData.Purchasedate!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.Purchasedate}",
      "nextfollowupdate": ForwardLeadUserApiData.nextFD == null ||
              ForwardLeadUserApiData.nextFD!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.nextFD}",
      "feedback": ForwardLeadUserApiData.feedback == null ||
              ForwardLeadUserApiData.feedback!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.feedback}",
      "ref1": ForwardLeadUserApiData.billRef == null ||
              ForwardLeadUserApiData.billRef!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.billRef}",
      "ref2": null,
      "nextuser": ForwardLeadUserApiData.nextUser == null ||
              ForwardLeadUserApiData.nextUser!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.nextUser}",
      "refdate": ForwardLeadUserApiData.billDate == null ||
              ForwardLeadUserApiData.billDate!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.billDate}",
      "reasontype": ForwardLeadUserApiData.Reasoname == null ||
              ForwardLeadUserApiData.Reasoname!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.Reasoname}",
      "isvisitplanrequired": 0,
      "visittime": ForwardLeadUserApiData.visitdate == null ||
              ForwardLeadUserApiData.visitdate!.isEmpty
          ? null
          : "${ForwardLeadUserApiData.visitdate}",
      "purposeofvisit": 0,
      "remindon": null
    };

    Responce res = Responce();
    res = await ServicePost.callApi(meth, Utils.token!, body);
    Map<String, dynamic> json = {};
    if (res.resCode! >= 200 && res.resCode! <= 200) {
      return ForwardLeadUserApi.fromjson(jsonDecode(res.responceBody!), res);
    }
    return ForwardLeadUserApi.fromjson(json, res);
  }

  String? curentDate;
  String? nextFD;
  String? updatedBy;
  String? followupMode;
  String? ReasonCode;
  String? Purchasedate;
  String? feedback;
  String? Reasoname;
  String? nextUser;
  String? status;
  //won

  String? billRef;
  String? visitdate;
  String? billDate;
  int? visitreq;

  AllSaveLeadApi(
      {this.Purchasedate,
      this.visitreq,
      this.curentDate,
      this.nextFD,
      this.visitdate,
      this.ReasonCode,
      this.followupMode,
      this.updatedBy,
      this.feedback,
      this.nextUser,
      this.status,
      this.Reasoname,
      //won

      this.billDate,
      this.billRef});
}
