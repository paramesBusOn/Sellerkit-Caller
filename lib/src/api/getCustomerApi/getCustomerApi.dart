import 'dart:convert';
import 'dart:developer';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetCustomerDetailsApi {
  GetCustomerDetailsApi(
      {required this.respCode,
      required this.itemdata,
      required this.respDesc,
      required this.respType,
      this.stcode,
      this.exception,
      this.message,
      this.status

      // required this.customertag
      });

  String? respType;
  String? respCode;
  String? respDesc;
  GetCustomerDetailsApitwo? itemdata;
  int? stcode;
  String? message;
  bool? status;
  String? exception;
//   int? stcode;

  static Future<GetCustomerDetailsApi> getData(
      String meth, GetCutomerpost reqpost) async {
    // Sellerkit_Flexi/v2/Customers
    Responce res = Responce();
    var body = reqpost.toJson();
    String? getToken = await HelperFunctions.getTokenSharedPreference();
    Utils.token = getToken.toString();
    res = await ServicePost.callApi(meth, Utils.token!, body);

    Map<String, dynamic> jsons = {};
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      jsons = jsonDecode(res.responceBody!);
    }
    return GetCustomerDetailsApi.fromJson(jsons, res);
  }

  factory GetCustomerDetailsApi.fromJson(
      Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons['data'] != null) {
        var list = json.decode(jsons['data'] as String) as Map<String, dynamic>;
        //   if(list.isNotEmpty ||list != null){
        //  List<GetCustomerData> dataList =
        //   list.map((data) => GetCustomerData.fromJson(data)).toList();
        return GetCustomerDetailsApi(
            respCode: jsons['respCode'] ?? '',
            itemdata: GetCustomerDetailsApitwo.fromJson(list),
            respDesc: jsons['respDesc'],
            respType: jsons['respType'],
            message: "Success",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return GetCustomerDetailsApi(
            respCode: jsons['respCode'],
            itemdata: null,
            respDesc: jsons['respDesc'],
            respType: jsons['respType'],
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! >= 400 && res.resCode! <= 410) {
        return GetCustomerDetailsApi(
            respCode: null,
            respDesc: null,
            respType: null,
            itemdata: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return GetCustomerDetailsApi(
            respCode: null,
            respDesc: null,
            respType: null,
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class GetCustomerDetailsApitwo {
  GetCustomerDetailsApitwo({
    required this.customerdetails,
    required this.enquirydetails,
    // required this.leaddetails,
    // required this.quotationdetails,
    // required this.orderdetails
  });

  List<GetCustomerData>? customerdetails;
  List<GetenquiryData>? enquirydetails;
  // List<GetleadData>? leaddetails;
  // List<GetQuotationData>? quotationdetails;
  // List<GetorderData>? orderdetails;

  factory GetCustomerDetailsApitwo.fromJson(Map<String, dynamic> jsons) {
    // var list6=jsons[""];\

    if (jsons["customers"] != null || jsons["Trans"] != null) {
      var list1 = jsons["customers"] as List;
      var list2 = jsons["Trans"] as List;
      List<GetCustomerData> dataList =
          list1.map((data) => GetCustomerData.fromJson(data)).toList();
      log("list1::" + list1.toString());
      if (list2.isNotEmpty) {
        List<GetenquiryData> dataList2 =
            list2.map((data) => GetenquiryData.fromJson(data)).toList();
        return GetCustomerDetailsApitwo(
            customerdetails: dataList, enquirydetails: dataList2);
      } else {
        return GetCustomerDetailsApitwo(
            customerdetails: dataList, enquirydetails: null);
      }
    } else {
      return GetCustomerDetailsApitwo(
        customerdetails: null,
        enquirydetails: null,
      );
    }
  }
}

class GetCustomerData {
  int? ID; //
  String? EnquiredOn;
  String? customerCode; //
  String? customerName; //
  String? EnqDate; //
  String? Followup; //
  String? Status; //
  String? Mgr_UserCode; //
  String? Mgr_UserName; //
  String? AssignedTo_User; //
  String? AssignedTo_UserName; //
  String? EnqType;
  String? Lookingfor; //
  double? PotentialValue; //
  String? Address_Line_1; //
  String? Address_Line_2; //
  String? Pincode; //
  String? City; //
  String? State; //
  String? Country; //
  String? Manager_Status_Tab; //
  String? Slp_Status_Tab; //
  String? email; //
  String? referal; //
  // String? customertag;
  String? contactName;
  String? altermobileNo;
  String? customerGroup;
  String? mobileNo;
  String? comapanyname;
  String? storecode;
  String? area;
  String? district;
  String? itemCode;
  String? itemname;
  String? enquirydscription;
  double? quantity;
  String? isVisitRequired;
  String? visitTime;
  String? remindOn;
  String? isClosed;
  bool? leadConverted;
  String? createdBy;
  String? createdDateTime;
  String? updatedBy;
  String? updatedDateTime;
  String? gst;
  String? codeid;
  String? address3;
  String? del_Address1;
  String? del_Address2;
  String? del_Address3;
  String? del_Area;
  String? del_city;
  String? del_district;
  String? del_state;
  String? del_country;
  String? del_pincode;
  String? pan;
  String? website;
  String? facebook;
  String? cardtype;

  String? status;

  GetCustomerData({
    required this.del_Address1,
    required this.del_Address2,
    required this.del_Address3,
    required this.del_Area,
    required this.del_city,
    required this.del_country,
    required this.del_district,
    required this.del_pincode,
    required this.del_state,
    required this.pan,
    required this.website,
    required this.facebook,
    required this.cardtype,
    required this.status,
    required this.contactName,
    required this.altermobileNo,
    required this.customerGroup,
    required this.Mgr_UserName,
    required this.comapanyname,
    required this.visitTime,
    required this.remindOn,
    required this.isClosed,
    required this.isVisitRequired,
    required this.storecode,
    required this.area,
    required this.district,
    required this.itemCode,
    required this.itemname,
    required this.leadConverted,
    required this.createdBy,
    required this.createdDateTime,
    required this.updatedBy,
    required this.updatedDateTime,
    required this.enquirydscription,
    required this.quantity,
    required this.ID,
    required this.customerCode,
    required this.Status,
    required this.customerName,
    required this.AssignedTo_User,
    required this.EnqDate,
    required this.Followup,
    required this.Mgr_UserCode,
    required this.AssignedTo_UserName,
    required this.EnqType,
    required this.Lookingfor,
    required this.PotentialValue,
    required this.Address_Line_1,
    required this.Address_Line_2,
    required this.Pincode,
    required this.City,
    required this.State,
    required this.Country,
    required this.Manager_Status_Tab,
    required this.Slp_Status_Tab,
    required this.email,
    required this.referal,
    required this.gst,
    required this.mobileNo,
    required this.codeid,
    required this.address3,
  });
  factory GetCustomerData.fromJson(Map<String, dynamic> json) =>
      GetCustomerData(
          ID: json['Id'] ?? 0, //
          customerCode: json['CustomerCode'] ?? '', //
          Status: json['CurrentStatus'] ?? '',
          customerName: json['CustomerName'] ?? '', //
          EnqDate: json['EnquiredOn'] ?? '',
          Followup: json['FollowupOn'] ?? '',
          Mgr_UserCode: json['mgr_UserCode'] ?? '',
          AssignedTo_UserName: json['AssignedTo'] ?? '',
          Mgr_UserName: json['mgr_UserName'] ?? '',
          AssignedTo_User: json['assignedTo_User'] ?? '',
          EnqType: json['EnquiryType'] ?? '',
          Lookingfor: json['Lookingfor'] ?? '',
          PotentialValue: json['Potentialvalue'] ?? 0.00,
          Address_Line_1: json['Bil_Address1'] ?? '', //
          Address_Line_2: json['Bil_Address2'] ?? '', //
          Pincode: json['Bil_Pincode'].toString(), //
          City: json['Bil_City'] ?? '', //
          State: json['Bil_State'] ?? '', //
          codeid: json["CodeId"], //
          Country: json['Country'] ?? '',
          Manager_Status_Tab: json['manager_Status_Tab'] ?? '',
          Slp_Status_Tab: json['EnquiryStatus'] ?? '',
          email: json['CustomerEmail'] ?? '', //
          referal: json['Refferal'] ?? '',
          contactName: json['ContactName'] ?? '', //
          customerGroup: json['CustomerGroup'] ?? '', //
          altermobileNo: json['AlternateMobileNo'] ?? '', //
          mobileNo: json["CustomerMobile"] ?? '', //
          comapanyname: json['CompanyName'] ?? '', //
          storecode: json['StoreCode'] ?? '', //
          area: json['Bil_Area'] ?? '', //
          gst: json["GSTNo"] ?? '', //
          address3: json["Bil_Address3"] ?? '', //
          district: json['Bil_District'] ?? '', //
          itemCode: json['ItemCode'] ?? '',
          itemname: json['ItemName'] ?? '',
          enquirydscription: json['Enquirydscription'] ?? '',
          quantity: json['Quantity'] ?? 0.0,
          isVisitRequired: json["IsVisitRequired"] ?? '',
          visitTime: json['VisitTime'] ?? '',
          remindOn: json['RemindOn'] ?? '',
          isClosed: json['isClosed'] ?? '',
          leadConverted: json['LeadConverted'],
          createdBy: json["CreatedBy"] ?? '',
          createdDateTime: json['CreatedOn'] ?? '',
          updatedBy: json['UpdatedBy'] ?? '',
          updatedDateTime: json['UpdatedOn'] ?? '',
          del_Address1: json['Del_Address1'] ?? '', //
          del_Address2: json["Del_Address2"] ?? '', //
          del_Address3: json['Del_Address3'] ?? '', //
          del_Area: json['Del_Area'] ?? '', //
          del_city: json['Del_City'] ?? '', //
          del_country: json['Del_Country'] ?? '', //
          del_district: json["Del_District"] ?? '', //
          del_pincode: json['Del_Pincode'] ?? '', //
          del_state: json['Del_State'] ?? '', //
          pan: json['PAN'] ?? '', //
          facebook: json['Facebook'] ?? '', //
          website: json['Website'] ?? '', //
          cardtype: json['cardtype'] ?? '', //
          status: json['Status'] ?? '' //

          );
}

class GetenquiryData {
  String? DocType;
  int? DocNum;
  String? DocDate;
  String? Store;
  double? BusinessValue;
  String? AssignedTo;
  String? CurrentStatus;
  String? Status;
  GetenquiryData(
      {required this.DocType,
      required this.AssignedTo,
      required this.BusinessValue,
      required this.CurrentStatus,
      required this.DocDate,
      required this.DocNum,
      required this.Status,
      required this.Store});
  factory GetenquiryData.fromJson(Map<String, dynamic> json) => GetenquiryData(
      DocType: json['DocType'] ?? '',
      AssignedTo: json['AssignedTo'] ?? '',
      BusinessValue: json['BusinessValue'] ?? 0.0,
      CurrentStatus: json['CurrentStatus'] ?? '',
      DocDate: json['DocDate'],
      DocNum: json['DocNum'] ?? '',
      Status: json['Status'] ?? '',
      Store: json['Store']);
}

class GetleadData {
  int? enquiryID;
  String? enquiredOn;
  String? customerCode;
  String? customerName;
  String? contactName;
  String? customerMobile;
  String? alternateMobileNo;
  String? companyName;
  String? customerEmail;
  String? customerGroup;
  String? storeCode;
  String? address1;
  String? address2;
  String? pinCode;
  String? bilArea;
  String? city;
  String? district;
  String? state;
  String? country;
  double? potentialvalue;
  String? itemCode;
  String? itemName;
  String? assignedTo;
  String? refferal;
  String? enquiryType;
  String? lookingfor;
  String? enquirydscription;
  double? quantity;
  String? followupOn;
  String? isVisitRequired;
  String? visitTime;
  String? remindOn;
  String? currentStatus;
  String? enquiryStatus;
  String? isClosed;
  bool? leadConverted;
  int? createdBy;
  String? createdDateTime;
  int? updatedBy;
  String? updatedDateTime;
  GetleadData(
      {required this.address1,
      required this.address2,
      required this.alternateMobileNo,
      required this.assignedTo,
      required this.bilArea,
      required this.city,
      required this.companyName,
      required this.contactName,
      required this.country,
      required this.createdBy,
      required this.createdDateTime,
      required this.currentStatus,
      required this.customerCode,
      required this.customerEmail,
      required this.customerGroup,
      required this.customerMobile,
      required this.customerName,
      required this.district,
      required this.enquiredOn,
      required this.enquiryID,
      required this.enquiryStatus,
      required this.enquiryType,
      required this.enquirydscription,
      required this.followupOn,
      required this.isClosed,
      required this.isVisitRequired,
      required this.itemCode,
      required this.itemName,
      required this.leadConverted,
      required this.lookingfor,
      required this.pinCode,
      required this.potentialvalue,
      required this.quantity,
      required this.refferal,
      required this.remindOn,
      required this.state,
      required this.storeCode,
      required this.updatedBy,
      required this.updatedDateTime,
      required this.visitTime});
  factory GetleadData.fromJson(Map<String, dynamic> json) => GetleadData(
      address1: json['Address1'],
      address2: json['Address2'],
      alternateMobileNo: json['AlternateMobileNo'],
      assignedTo: json['AssignedTo'],
      bilArea: json['BilArea'],
      city: json['City'],
      companyName: json['CompanyName'],
      contactName: json['ContactName'],
      country: json['Country'],
      createdBy: json['CreatedBy'],
      createdDateTime: json['CreatedDateTime'],
      currentStatus: json['CurrentStatus'],
      customerCode: json['CustomerCode'],
      customerEmail: json['CustomerEmail'],
      customerGroup: json['CustomerGroup'],
      customerMobile: json['CustomerMobile'],
      customerName: json['CustomerName'],
      district: json['District'],
      enquiredOn: json['EnquiredOn'],
      enquiryID: json['EnquiryID'],
      enquiryStatus: json['EnquiryStatus'],
      enquiryType: json['EnquiryType'],
      enquirydscription: json['Enquirydscription'],
      followupOn: json['FollowupOn'],
      isClosed: json['isClosed'],
      isVisitRequired: json['IsVisitRequired'],
      itemCode: json['ItemCode'],
      itemName: json['ItemName'],
      leadConverted: json['LeadConverted'],
      lookingfor: json['Lookingfor'],
      pinCode: json['PinCode'].toString(),
      potentialvalue: json['Potentialvalue'],
      quantity: json['Quantity'],
      refferal: json['Refferal'],
      remindOn: json['RemindOn'],
      state: json['State'],
      storeCode: json['StoreCode'],
      updatedBy: json['UpdatedBy'],
      updatedDateTime: json['UpdatedDateTime'],
      visitTime: json['VisitTime']);
}

//Quotation
class GetQuotationData {
  int? enquiryID;
  String? enquiredOn;
  String? customerCode;
  String? customerName;
  String? contactName;
  String? customerMobile;
  String? alternateMobileNo;
  String? companyName;
  String? customerEmail;
  String? customerGroup;
  String? storeCode;
  String? address1;
  String? address2;
  String? pinCode;
  String? bilArea;
  String? city;
  String? district;
  String? state;
  String? country;
  double? potentialvalue;
  String? itemCode;
  String? itemName;
  String? assignedTo;
  String? refferal;
  String? enquiryType;
  String? lookingfor;
  String? enquirydscription;
  double? quantity;
  String? followupOn;
  String? isVisitRequired;
  String? visitTime;
  String? remindOn;
  String? currentStatus;
  String? enquiryStatus;
  String? isClosed;
  bool? leadConverted;
  int? createdBy;
  String? createdDateTime;
  int? updatedBy;
  String? updatedDateTime;
  GetQuotationData(
      {required this.address1,
      required this.address2,
      required this.alternateMobileNo,
      required this.assignedTo,
      required this.bilArea,
      required this.city,
      required this.companyName,
      required this.contactName,
      required this.country,
      required this.createdBy,
      required this.createdDateTime,
      required this.currentStatus,
      required this.customerCode,
      required this.customerEmail,
      required this.customerGroup,
      required this.customerMobile,
      required this.customerName,
      required this.district,
      required this.enquiredOn,
      required this.enquiryID,
      required this.enquiryStatus,
      required this.enquiryType,
      required this.enquirydscription,
      required this.followupOn,
      required this.isClosed,
      required this.isVisitRequired,
      required this.itemCode,
      required this.itemName,
      required this.leadConverted,
      required this.lookingfor,
      required this.pinCode,
      required this.potentialvalue,
      required this.quantity,
      required this.refferal,
      required this.remindOn,
      required this.state,
      required this.storeCode,
      required this.updatedBy,
      required this.updatedDateTime,
      required this.visitTime});
  factory GetQuotationData.fromJson(Map<String, dynamic> json) =>
      GetQuotationData(
          address1: json['Address1'],
          address2: json['Address2'],
          alternateMobileNo: json['AlternateMobileNo'],
          assignedTo: json['AssignedTo'],
          bilArea: json['BilArea'],
          city: json['City'],
          companyName: json['CompanyName'],
          contactName: json['ContactName'],
          country: json['Country'],
          createdBy: json['CreatedBy'],
          createdDateTime: json['CreatedDateTime'],
          currentStatus: json['CurrentStatus'],
          customerCode: json['CustomerCode'],
          customerEmail: json['CustomerEmail'],
          customerGroup: json['CustomerGroup'],
          customerMobile: json['CustomerMobile'],
          customerName: json['CustomerName'],
          district: json['District'],
          enquiredOn: json['EnquiredOn'],
          enquiryID: json['EnquiryID'],
          enquiryStatus: json['EnquiryStatus'],
          enquiryType: json['EnquiryType'],
          enquirydscription: json['Enquirydscription'],
          followupOn: json['FollowupOn'],
          isClosed: json['isClosed'],
          isVisitRequired: json['IsVisitRequired'],
          itemCode: json['ItemCode'],
          itemName: json['ItemName'],
          leadConverted: json['LeadConverted'],
          lookingfor: json['Lookingfor'],
          pinCode: json['PinCode'].toString(),
          potentialvalue: json['Potentialvalue'],
          quantity: json['Quantity'],
          refferal: json['Refferal'],
          remindOn: json['RemindOn'],
          state: json['State'],
          storeCode: json['StoreCode'],
          updatedBy: json['UpdatedBy'],
          updatedDateTime: json['UpdatedDateTime'],
          visitTime: json['VisitTime']);
}
//Orders

class GetorderData {
  int? enquiryID;
  String? enquiredOn;
  String? customerCode;
  String? customerName;
  String? contactName;
  String? customerMobile;
  String? alternateMobileNo;
  String? companyName;
  String? customerEmail;
  String? customerGroup;
  String? storeCode;
  String? address1;
  String? address2;
  String? pinCode;
  String? bilArea;
  String? city;
  String? district;
  String? state;
  String? country;
  double? potentialvalue;
  String? itemCode;
  String? itemName;
  String? assignedTo;
  String? refferal;
  String? enquiryType;
  String? lookingfor;
  String? enquirydscription;
  double? quantity;
  String? followupOn;
  String? isVisitRequired;
  String? visitTime;
  String? remindOn;
  String? currentStatus;
  String? enquiryStatus;
  String? isClosed;
  bool? leadConverted;
  int? createdBy;
  String? createdDateTime;
  int? updatedBy;
  String? updatedDateTime;
  GetorderData(
      {required this.address1,
      required this.address2,
      required this.alternateMobileNo,
      required this.assignedTo,
      required this.bilArea,
      required this.city,
      required this.companyName,
      required this.contactName,
      required this.country,
      required this.createdBy,
      required this.createdDateTime,
      required this.currentStatus,
      required this.customerCode,
      required this.customerEmail,
      required this.customerGroup,
      required this.customerMobile,
      required this.customerName,
      required this.district,
      required this.enquiredOn,
      required this.enquiryID,
      required this.enquiryStatus,
      required this.enquiryType,
      required this.enquirydscription,
      required this.followupOn,
      required this.isClosed,
      required this.isVisitRequired,
      required this.itemCode,
      required this.itemName,
      required this.leadConverted,
      required this.lookingfor,
      required this.pinCode,
      required this.potentialvalue,
      required this.quantity,
      required this.refferal,
      required this.remindOn,
      required this.state,
      required this.storeCode,
      required this.updatedBy,
      required this.updatedDateTime,
      required this.visitTime});
  factory GetorderData.fromJson(Map<String, dynamic> json) => GetorderData(
      address1: json['Address1'],
      address2: json['Address2'],
      alternateMobileNo: json['AlternateMobileNo'],
      assignedTo: json['AssignedTo'],
      bilArea: json['BilArea'],
      city: json['City'],
      companyName: json['CompanyName'],
      contactName: json['ContactName'],
      country: json['Country'],
      createdBy: json['CreatedBy'],
      createdDateTime: json['CreatedDateTime'],
      currentStatus: json['CurrentStatus'],
      customerCode: json['CustomerCode'],
      customerEmail: json['CustomerEmail'],
      customerGroup: json['CustomerGroup'],
      customerMobile: json['CustomerMobile'],
      customerName: json['CustomerName'],
      district: json['District'],
      enquiredOn: json['EnquiredOn'],
      enquiryID: json['EnquiryID'],
      enquiryStatus: json['EnquiryStatus'],
      enquiryType: json['EnquiryType'],
      enquirydscription: json['Enquirydscription'],
      followupOn: json['FollowupOn'],
      isClosed: json['isClosed'],
      isVisitRequired: json['IsVisitRequired'],
      itemCode: json['ItemCode'],
      itemName: json['ItemName'],
      leadConverted: json['LeadConverted'],
      lookingfor: json['Lookingfor'],
      pinCode: json['PinCode'].toString(),
      potentialvalue: json['Potentialvalue'],
      quantity: json['Quantity'],
      refferal: json['Refferal'],
      remindOn: json['RemindOn'],
      state: json['State'],
      storeCode: json['StoreCode'],
      updatedBy: json['UpdatedBy'],
      updatedDateTime: json['UpdatedDateTime'],
      visitTime: json['VisitTime']);
}

class GetCutomerpost {
  String? listtype;
  String? valuetype;
  String? customermobile;

  GetCutomerpost({this.listtype, this.valuetype, required this.customermobile});
  Map<String, dynamic> toJson() => {
        'listtype': 'withrecenttrans',
        'valuetype': 'name',
        'customermobile': customermobile,
      };
}
