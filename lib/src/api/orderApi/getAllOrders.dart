import 'dart:convert';
import 'dart:math';

import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/serviceMainApi/ServicePost.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetAllOrderApi {
  GetAllOrderDataheader? ordercheckdatageader;

  String message;
  bool? status;
  String? exception;
  int? stcode;
  GetAllOrderApi(
      {required this.ordercheckdatageader,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});

  static Future<GetAllOrderApi> getData(
    String meth,
  ) async {
    // Sellerkit_Flexi/v2/GetAllOrders
    Map<String, dynamic> body = {
      "listtype": "summary",
      "valuetype": "name",
      "fromperiod": null,
      "toperiod": null,
      "status": null
    };
    Responce res = Responce();
    res = await ServicePost.callApi(meth, Utils.token!, body);
    Map<String, dynamic> jsons = {};
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      return GetAllOrderApi.fromJson(jsonDecode(res.responceBody!), res);
    }
    return GetAllOrderApi.fromJson(jsons, res);
  }

  factory GetAllOrderApi.fromJson(Map<String, dynamic> jsons, Responce res) {
    print("inside class" + jsons.toString());
    if (res.resCode! >= 200 && res.resCode! <= 210) {
      if (jsons != null || jsons.isNotEmpty) {
        return GetAllOrderApi(
            ordercheckdatageader: GetAllOrderDataheader.fromJson(jsons),
            message: "Sucess",
            status: true,
            stcode: res.resCode,
            exception: null);
      } else {
        return GetAllOrderApi(
            ordercheckdatageader: null,
            message: "Failure",
            status: false,
            stcode: res.resCode,
            exception: null);
      }
    } else {
      if (res.resCode! >= 400 && res.resCode! <= 410) {
        Map<String, dynamic> jsons = jsonDecode(res.responceBody!);
        return GetAllOrderApi(
            ordercheckdatageader: null,
            message: jsons['respCode'],
            status: null,
            stcode: res.resCode,
            exception: jsons['respDesc']);
      } else {
        return GetAllOrderApi(
            ordercheckdatageader: null,
            message: 'Exception',
            status: null,
            stcode: res.resCode,
            exception: res.responceBody);
      }
    }
  }
}

class GetAllOrderDataheader {
  List<GetAllOrderData>? Ordercheckdata;
  GetAllOrderDataheader({required this.Ordercheckdata});
  factory GetAllOrderDataheader.fromJson(
    Map<String, dynamic> jsons,
  ) {
    if (jsons['data'] != null) {
      var list = json.decode(jsons['data']) as List;
      List<GetAllOrderData> dataList =
          list.map((data) => GetAllOrderData.fromJson(data)).toList();
      return GetAllOrderDataheader(Ordercheckdata: dataList);
    } else {
      return GetAllOrderDataheader(Ordercheckdata: null);
    }
  }
}

class GetAllOrderData {
  int? orderDocEntry; //
  int? followupEntry;
  int? orderNum;
  String? deliveryDueDate;
  String? paymentDueDate;
  String? alternatemobileNo;
  String? contactName;
  String? customerEmail;
  String? companyName;
  String? pAN;
  String? gSTNo;
  String? customerPORef;
  String? bilAddress1;
  String? bilAddress2;
  String? bilAddress3;
  String? bilArea;
  String? bilCity;
  String? bilDistrict;
  String? bilState;
  String? bilCountry;
  String? bilPincode;
  String? delAddress1;
  String? delAddress2;
  String? delAddress3;
  String? delArea;
  String? delCity;
  String? delDistrict;
  String? delState;
  String? delCountry;
  String? delPincode;
  String? storeCode;
  String? assignedTo;
  String? deliveryFrom;
  String? orderstatus;
  String? currentstatus;
  String? dealID;
  int? baseID;
  String? baseType;
  String? basedocDate;
  double? grossTotal;
  double? discount;
  double? subTotal;
  double? taxAmount;
  double roundOff;
  String? attachURL1;
  String? attachURL2;
  String? attachURL3;

  String? mobile; //
  String? customerName; //
  String? docDate;
  // String? City;
  // String? NextFollowup;
  String? product;
  String? createdon; //
  double? value; //
  String? status; //
  String? lastUpdateMessage; //
  String? lastUpdateTime; //
  String? enqid;
  String? leadid;
  int? isDelivered;
  int? isInvoiced;
  String? orderType;
  String? customerGroup;

  GetAllOrderData({
    required this.customerGroup,
    required this.orderType,
    required this.createdon,
    required this.isDelivered,
    required this.isInvoiced,
    required this.orderDocEntry,
    required this.orderNum,
    required this.mobile,
    required this.customerName,
    required this.docDate,
    required this.assignedTo,
    required this.attachURL1,
    required this.attachURL2,
    required this.attachURL3,
    required this.basedocDate,
    required this.baseID,
    required this.baseType,
    required this.currentstatus,
    required this.dealID,
    required this.delAddress3,
    required this.delAddress2,
    required this.delAddress1,
    required this.delArea,
    required this.delCity,
    required this.delCountry,
    required this.delDistrict,
    required this.delPincode,
    required this.delState,
    required this.deliveryFrom,
    required this.discount,
    required this.followupEntry,
    required this.lastUpdateMessage,
    required this.grossTotal,
    required this.lastUpdateTime,
    required this.orderstatus,
    required this.product,
    required this.roundOff,
    required this.status,
    required this.storeCode,
    required this.subTotal,
    required this.taxAmount,
    required this.value,
    required this.alternatemobileNo,
    required this.bilAddress1,
    required this.bilAddress2,
    required this.bilAddress3,
    required this.bilArea,
    required this.bilCity,
    required this.bilCountry,
    required this.bilDistrict,
    required this.bilPincode,
    required this.bilState,
    required this.companyName,
    required this.contactName,
    required this.customerEmail,
    required this.customerPORef,
    required this.deliveryDueDate,
    required this.enqid,
    required this.gSTNo,
    required this.leadid,
    required this.pAN,
    required this.paymentDueDate,
    // required this.City,
    // required this.NextFollowup,
  });

  factory GetAllOrderData.fromJson(Map<String, dynamic> json) {
    // print("inside data class"+json.toString());
    return GetAllOrderData(
        customerGroup: json['CustomerGroup'] ?? '', //
        orderType: json['OrderType'] ?? '',//
        createdon: json['CreatedOn'] ?? '',//
        isDelivered: json['isDelivered'],//
        isInvoiced: json['isInvoiced'],//
        orderDocEntry: json['DocEntry'], //
        orderNum: json['OrderNumber'], //
        mobile: json['CustomerCode'], //
        customerName: json['CustomerName'], //
        docDate: json['DocDate'], //
        assignedTo: json['AssignedTo'],//
        attachURL1: json['AttachURL1'],//
        attachURL2: json['AttachURL2'],//
        attachURL3: json['AttachURL3'],//
        basedocDate: json['BaseDocDate'],//
        baseID: json['BaseID'],//
        baseType: json['BaseType'],//
        currentstatus: json['CurrentStatus'],//
        dealID: json['DealID'],//
        delAddress2: json['Del_Address2'],//
        delAddress3: json['Del_Address3'],//
        delArea: json['Del_Area'],//
        delCity: json['Del_City'],//
        delCountry: json['Del_Country'],//
        delDistrict: json['Del_District'],//
        delPincode: json['Del_Pincode'],//
        delState: json['Del_State'],//
        deliveryFrom: json['DeliveryFrom'],//
        discount: json['Discount'],//
        followupEntry: json['DocEntry'],//
        lastUpdateMessage: json['Orderstatus'],//
        grossTotal: json['GrossTotal'],//
        lastUpdateTime: json['UpdatedOn'],//
        orderstatus: json['Orderstatus'],//
        product: json['ItemName'],//
        roundOff: json['RoundOff'],//
        status: json['Orderstatus'],//
        storeCode: json['StoreCode'],//
        subTotal: json['SubTotal'],//
        taxAmount: json['TaxAmount'],//
        value: json['DocTotal'],//
        alternatemobileNo: json['AlternateMobileNo'], //
        bilAddress1: json['Bil_Address1'], //
        bilAddress2: json['Bil_Address2'], //
        bilAddress3: json['Bil_Address3'], //
        bilArea: json['Bil_Area'], //
        bilCity: json['Bil_City'], //
        bilCountry: json['Bil_Country'], //
        bilDistrict: json['Bil_District'], //
        bilPincode: json['Bil_Pincode'], //
        bilState: json['Bil_State'], //
        companyName: json['CompanyName'], //
        contactName: json['ContactName'], //
        customerEmail: json['CustomerEmail'], //
        customerPORef: json['CustomerPORef'], //
        delAddress1: json['Del_Address1'], //
        deliveryDueDate: json['DeliveryDueDate'], //
        enqid: json[''],
        gSTNo: json['GSTNo'], //
        leadid: json[''],
        pAN: json['PAN'], //
        paymentDueDate: json['PaymentDueDate']); //
  }
  // Map<String, Object?> toMap() => {
  //       OrderfilterDBcolumns.orderDocEntry: orderDocEntry,
  //       OrderfilterDBcolumns.followupEntry: followupEntry,
  //       OrderfilterDBcolumns.orderNum: orderNum,
  //       OrderfilterDBcolumns.deliveryDueDate: deliveryDueDate,
  //       OrderfilterDBcolumns.paymentDueDate: paymentDueDate,
  //       OrderfilterDBcolumns.alternatemobileNo: alternatemobileNo,
  //       OrderfilterDBcolumns.contactName: contactName,
  //       OrderfilterDBcolumns.companyName: companyName,
  //       OrderfilterDBcolumns.pAN: pAN,
  //       OrderfilterDBcolumns.gSTNo: gSTNo,
  //       OrderfilterDBcolumns.customerPORef: customerPORef,
  //       OrderfilterDBcolumns.bilAddress1: bilAddress1,
  //       OrderfilterDBcolumns.bil_Address2: bil_Address2,
  //       OrderfilterDBcolumns.bil_Address3: bil_Address3,
  //       OrderfilterDBcolumns.bil_Area: bil_Area,
  //       OrderfilterDBcolumns.bil_City: bil_City,
  //       OrderfilterDBcolumns.bil_District: bil_District,
  //       OrderfilterDBcolumns.bil_State: bil_State,
  //       OrderfilterDBcolumns.bil_Country: bil_Country,
  //       OrderfilterDBcolumns.bil_Pincode: bil_Pincode,
  //       OrderfilterDBcolumns.del_Address1: del_Address1,
  //       OrderfilterDBcolumns.del_Address2: Del_Address2,
  //       OrderfilterDBcolumns.del_Address3: Del_Address3,
  //       OrderfilterDBcolumns.Del_Area: Del_Area,
  //       OrderfilterDBcolumns.del_City: Del_City,
  //       OrderfilterDBcolumns.del_District: Del_District,
  //       OrderfilterDBcolumns.del_State: Del_State,
  //       OrderfilterDBcolumns.del_Country: Del_Country,
  //       OrderfilterDBcolumns.del_Pincode: Del_Pincode,
  //       OrderfilterDBcolumns.storeCode: StoreCode,
  //       OrderfilterDBcolumns.assignedTo: assignedTo,
  //       OrderfilterDBcolumns.deliveryFrom: DeliveryFrom,
  //       OrderfilterDBcolumns.orderstatus: Orderstatus,
  //       OrderfilterDBcolumns.currentstatus: currentstatus,
  //       OrderfilterDBcolumns.dealID: dealID,
  //       OrderfilterDBcolumns.baseID: baseID,
  //       OrderfilterDBcolumns.baseType: baseType,
  //       OrderfilterDBcolumns.basedocDate: basedocDate,
  //       OrderfilterDBcolumns.grossTotal: grossTotal,
  //       OrderfilterDBcolumns.discount: discount,
  //       OrderfilterDBcolumns.subTotal: subTotal,
  //       OrderfilterDBcolumns.taxAmount: taxAmount,
  //       OrderfilterDBcolumns.roundOff: roundOff,
  //       OrderfilterDBcolumns.attachURL1: attachURL1,
  //       OrderfilterDBcolumns.attachURL2: attachURL2,
  //       OrderfilterDBcolumns.attachURL3: attachURL3,
  //       OrderfilterDBcolumns.mobile: mobile,
  //       OrderfilterDBcolumns.customerName: customerName,
  //       OrderfilterDBcolumns.docDate: docDate,
  //       OrderfilterDBcolumns.product: product,
  //       OrderfilterDBcolumns.createdon: createdon,
  //       OrderfilterDBcolumns.value: value,
  //       OrderfilterDBcolumns.status: status,
  //       OrderfilterDBcolumns.lastUpdateMessage: lastUpdateMessage,
  //       OrderfilterDBcolumns.lastUpdateTime: lastUpdateTime,
  //       OrderfilterDBcolumns.enqid: enqid,
  //       OrderfilterDBcolumns.leadid: leadid,
  //       OrderfilterDBcolumns.isDelivered: isDelivered,
  //       OrderfilterDBcolumns.isInvoiced: isInvoiced,
  //       OrderfilterDBcolumns.orderType: orderType,
  //       OrderfilterDBcolumns.customerGroup: customerGroup,
  //     };
  // Map<String, dynamic> tojson() {
  //   Map<String, dynamic> map = {
  //     "orderDocEntry": orderDocEntry,
  //     "orderNum": orderNum,
  //     "U_Chkvalue": ischecked == false?'No':'Yes'
  //   };
  //   return map;
  // }
}
