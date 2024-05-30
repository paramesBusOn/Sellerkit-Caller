import 'dart:convert';
import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';
import '../../dBModel/getAllCustomerDbModel.dart';

class CustomerDetails {
  List<CustomerData>? itemdata;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  CustomerDetails(
      {this.itemdata, this.message, this.status, this.exception, this.stcode});
  Future<CustomerDetails> getData(String meth) async {
    // SkClientPortal/GetAllCustomers
    Responce res = Responce();
    res = await ServicePostNoBody.callApi(meth, Utils.token!);
    Map<String, dynamic> jsons = {};
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      return CustomerDetails.fromJson(jsonDecode(res.responceBody!), res);
    }
    return CustomerDetails.fromJson(jsons, res);
  }

  factory CustomerDetails.fromJson(Map<String, dynamic> jsons, Responce res) {
    if (res.resCode! <= 210 && res.resCode! >= 200) {
      if (jsons != null) {
        var list = json.decode(jsons["data"]) as List;
        // log("listsL:"+list.toString());
        List<CustomerData> dataList =
            list.map((data) => CustomerData.fromJson(data)).toList();
        return CustomerDetails(
            itemdata: dataList,
            message: jsons['respCode'],
            status: true,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return CustomerDetails(
            itemdata: null,
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      }
    } else {
      if (res.resCode! <= 410 && res.resCode! >= 400) {
        Map<String, dynamic> jsons = jsonDecode(res.responceBody!);
        return CustomerDetails(
            itemdata: null,
            message:jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return CustomerDetails(
            itemdata: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody!);
      }
    }
  }
}

class CustomerData {
  CustomerData({
    required this.id,
    required this.cardcode,
    required this.cardname,
    required this.cantactName,
    required this.mobile,
    required this.alterMobileno,
    required this.email,
    required this.gst,
    required this.address1,
    required this.address2,
    required this.zipcode,
    required this.city,
    required this.state,
    required this.area,
    required this.tag,
  });

  int? id;
  String? cardcode;
  String? cardname;
  String? cantactName;
  String? mobile;
  String? alterMobileno;
  String? email;
  String? gst;
  String? address1;
  String? address2;
  String? zipcode;
  String? city;
  String? state;
  String? area;
  String? tag;

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
      id: 0,
      cardcode: json['CustomerCode'] ?? '',
      cardname: json['CustomerName'] ?? '',
      cantactName: json['ContactName'] ?? '',
      mobile: json['CustomerMobile'] ?? '',
      alterMobileno: json['AlternateMobileNo'] ?? '',
      address2: json['Bil_Address2'] ?? '',
      email: json['CustomerEmail'] ?? '',
      gst: json['GSTNo'] ?? '',
      address1: json['Bil_Address1'] ?? '',
      zipcode: json['Bil_Pincode'] ?? '',
      city: json['Bil_City'] ?? '',
      state: json['Bil_State'] ?? '',
      area: json['Bil_Address3'] ?? "",
      tag: json['CustomerGroup'] ?? "");

// AlternateMobileNo: json['AlternateMobileNo']??'',
//     AssignedTo: json['AssignedTo']??'',
//     Bil_Address1: json['Bil_Address1']??'',
//     Bil_Address2: json['Bil_Address2']??'',
//     Bil_Address3: json['Bil_Address3']??'',
//     Bil_Area: json['Bil_Area']??'',
//     Bil_City: json['Bil_City']??'',
//     Bil_Country: json['Bil_Country']??'',
//     Bil_District: json['Bil_District']??'',
//     Bil_Pincode: json['Bil_Pincode']??'',
//     Bil_State: json['Bil_State']??'',
//     CompanyName: json['CompanyName']??'',
//     ContactName: json['ContactName']??'',
//     CreatedBy: json['CreatedBy']??0,
//     CreatedOn: json['CreatedOn']??'',
//     CustomerCode: json['CustomerCode']??'',
//     CustomerEmail: json['CustomerEmail']??'',
//     CustomerGroup: json['CustomerGroup']??'',
//     CustomerMobile: json['CustomerMobile']??'',
//     CustomerName: json['CustomerName']??'',
//     Del_Address1: json['Del_Address1']??'',
//     Del_Address2: json['Del_Address2']??'',
//     Del_Address3: json['Del_Address3']??'',
//     Del_Area: json['Del_Area']??'',
//     Del_City: json['Del_City']??'',
//     Del_Country: json['Del_Country']??'',
//     Del_District: json['Del_District']??'',
//     Del_Pincode: json['Del_Pincode']??'',
//     Del_State: json['Del_State']??'',
//     GSTNo: json['GSTNo']??'',
//     PAN: json['PAN']??'',
//     Status: json['Status']??'',
//     StoreCode: json['StoreCode']??'',
//     UpdatedBy: json['UpdatedBy']??0,
//     UpdatedOn: json['UpdatedOn']??'',
//     traceid: json['traceid']??''

  Map<String, Object?> toMap() => {
        CustomerMasterDB.id: id,
        CustomerMasterDB.cardcode: cardcode,
        CustomerMasterDB.cardname: cardname,
        CustomerMasterDB.cantactName: cantactName,
        CustomerMasterDB.mobile: mobile,
        CustomerMasterDB.alterMobileno: alterMobileno,
        CustomerMasterDB.email: email,
        CustomerMasterDB.gst: gst,
        CustomerMasterDB.address1: address1,
        CustomerMasterDB.address2: address2,
        CustomerMasterDB.zipcode: zipcode,
        CustomerMasterDB.city: city,
        CustomerMasterDB.state: state,
        CustomerMasterDB.area: area,
        CustomerMasterDB.tag: tag
      };
}
