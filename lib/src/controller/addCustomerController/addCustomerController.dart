// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
import 'package:sellerkitcalllog/src/api/getCustomerApi/getCustomerApi.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBHelper.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBOperation.dart';
import 'package:sellerkitcalllog/src/pages/addCustomer/widgets/warningdialog.dart';
import 'package:sqflite/sqflite.dart';

import '../../../helpers/Configuration.dart';
import '../../../helpers/constantRoutes.dart';
import '../../../helpers/utils.dart';
import '../../api/addCustomerApi/addCustomerApi.dart';
import '../../api/enqTypeApi/enqTypeApi.dart';
import '../../api/getAllCustomerApi/getAllCustomerApi.dart';
import '../../api/getRefferalApi/getRefferalApi.dart';
import '../../api/levelOfApi/levelOfApi.dart';
import '../../api/ordertypeApi/ordertypeApi.dart';
import '../../api/stateApi/stateApi.dart';
import '../../widgets/AlertDilog.dart';

class NewCustomerContoller extends ChangeNotifier {
  init() async {
    clearAllData();

    await stateApicallfromDB();
    getCustomerTag();
  }

  List<LevelofData> leveofdata = [];
  List<OrderTypeData> ordertypedata = [];

  bool isTextFieldEnabled = true;
  bool customerbool = false;
  bool areabool = false;
  bool citybool = false;
  bool pincodebool = false;
  bool statebool = false;
  bool statebool2 = false;
  // bool autoIsselectTag = false;

  refreshh() {
    clearAllData();

    getEnqRefferes();
    //  getLeveofType();
    // callLeadCheckApi();
  }

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  ontapvalid(BuildContext context) {
    methidstate(mycontroller[18].text, context);
    FocusScope.of(context).requestFocus(focusNode1);
    statebool = false;
    notifyListeners();
  }

  ontapvalid2(BuildContext context) {
    methidstate2(mycontroller[24].text);
    FocusScope.of(context).requestFocus(focusNode3);
    statebool = false;
    notifyListeners();
  }

  List<CustomerData> customerList = [];
  List<CustomerData> get getCustomerList => customerList;
  List<CustomerData> filterCustomerList = [];
  List<CustomerData> get getfilterCustomerList => filterCustomerList;
//

  List<GlobalKey<FormState>> formkey =
      new List.generate(3, (i) => new GlobalKey<FormState>(debugLabel: "Lead"));
  List<TextEditingController> mycontroller =
      List.generate(35, (i) => TextEditingController());

  Config config = new Config();

  String isSelectedGender = '';
  String get getisSelectedGender => isSelectedGender;

  String isSelectedAge = '';
  String get getisSelectedAge => isSelectedAge;

  String isSelectedcomeas = '';
  String get getisSelectedcomeas => isSelectedcomeas;

  String isSelectedAdvertisement = '';
  String get getisSelectedAdvertisement => isSelectedAdvertisement;

  // String isSelectedCsTag = '';
  // String get getisSelectedCsTag => isSelectedCsTag;

  bool showItemList = true;
  bool get getshowItemList => showItemList;

  bool isUpdateClicked = false;

  bool validateGender = false;
  bool validateAge = false;
  bool validateComas = false;
  bool validateCsTag = false;

  bool get getvalidateGender => validateGender;
  bool get getvalidateAge => validateAge;
  bool get getvalidateComas => validateComas;
  bool get getvalidateCsTag => validateCsTag;

  List<CustomerTagTypeData2> customerTagTypeData = [];

  // List<ProductDetails> productDetails = [];
  // List<ProductDetails> get getProduct => productDetails;

  // List<DocumentLines> productDetails = [];
  // List<DocumentLines> get getProduct => productDetails;

  String? selectedItemCode;
  String? get getselectedItemCode => selectedItemCode;

  String? selectedItemName;
  String? get getselectedItemName => selectedItemName;

  double? unitPrice;
  double? quantity;
  double total = 0.00;
// List<Custype> custype=[
//   Custype(name: "Single"),
//    Custype(name: "Bulk"),
//     Custype(name: "Chain Order")

//   ];
  List<EnquiryTypeData> enqList = [];
  List<EnquiryTypeData> get getEnqList => enqList;

  String isSelectedenquirytype = '';
  String get getisSelectedenquirytype => isSelectedenquirytype;

  bool visibleEnqType = false;
  bool get getvisibleEnqType => visibleEnqType;

  List<EnqRefferesData> enqReffList = [];
  List<EnqRefferesData> get getenqReffList => enqReffList;

  String isSelectedenquiryReffers = '';
  String isSelectedrefcode = '';
  String get getisSelectedenquiryReffers => isSelectedenquiryReffers;
  String? EnqRefer;
  //

  // List<PaymentTermsData> paymentTermsList = [
  //   PaymentTermsData(Name: "Cash", Code: "1"),
  //   PaymentTermsData(Name: "Card", Code: "2"),
  //   PaymentTermsData(Name: "Cheque", Code: "3"),
  //   PaymentTermsData(Name: "Finance", Code: "4"),
  //   PaymentTermsData(Name: "Wallet", Code: "5"),
  //   PaymentTermsData(Name: "Transfer", Code: "6"),
  //   PaymentTermsData(Name: "COD", Code: "7"),
  // ];
  // List<PaymentTermsData> get getpaymentTermsList => paymentTermsList;

  String isSelectedpaymentTermsList = '';
  String isSelectedpaymentTermsCode = '';
  String get getisSelectedpaymentTermsList => isSelectedpaymentTermsList;
  String? PaymentTerms;
//
//
  String isSelectedCusTag = '';
  String isSelectedCusTagcode = '';
  String get getisSelectedCusTag => isSelectedCusTag;
  String? CusTag;

  bool visibleRefferal = false;
  bool get getvisibleRefferal => visibleRefferal;

  static bool isComeFromEnq = false;

  int? enqID;
  int? basetype;

  selectEnqReffers(String selected, String refercode, String code) {
    isSelectedenquiryReffers = selected;
    EnqRefer = refercode;
    isSelectedrefcode = code;
    log("AN11:" + isSelectedenquiryReffers.toString());

    log("AN22:" + EnqRefer.toString());

    log("AN33:" + isSelectedrefcode.toString());
    notifyListeners();
  }

  selectpaymentTerms(String selected, String refercode, String code) {
    isSelectedpaymentTermsList = selected;
    PaymentTerms = refercode;
    isSelectedpaymentTermsCode = code;
    // log("AN11:" + isSelectedpaymentTermsList.toString());

    // log("AN22:" + EnqRefer.toString());

    // log("AN33:" + isSelectedrefcode.toString());
    notifyListeners();
  }

  selectCustomerTag(String selected, String refercode, String code) {
    // if (autoIsselectTag == true) {
    //   customerTagTypeData = [];
    //   getCustomerTag();
    //   autoIsselectTag = false;
    //   notifyListeners();
    // }
    isSelectedCusTag = selected;
    CusTag = refercode;
    isSelectedCusTagcode = code;
    // log("AN11:" + isSelectedenquiryReffers.toString());

    // log("AN22:" + EnqRefer.toString());

    // log("AN33:" + isSelectedrefcode.toString());
    notifyListeners();
  }

  getEnqRefferes() async {
    final Database db = (await DBHelper.getInstance())!;
    enqReffList = await DBOperation.getEnqRefferes(db);
    notifyListeners();
  }

  getCustomerTag() async {
    customerTagTypeData = [];
    final Database db = (await DBHelper.getInstance())!;
    customerTagTypeData = await DBOperation.getCusTagData(db);
    notifyListeners();
  }

  getCustomerListFromDB() async {
    final Database db = (await DBHelper.getInstance())!;
    customerList = await DBOperation.getCustomerData(db);
    filterCustomerList = customerList;
    log("getCustomerListFromDB length::" +
        filterCustomerList.length.toString());
    notifyListeners();
  }

  int? EnqTypeCode;
  selectEnqMeida(String selected, int enqtypecode) {
    isSelectedenquirytype = selected;
    EnqTypeCode = enqtypecode;

    notifyListeners();
  }

  getEnqType() async {
    final Database db = (await DBHelper.getInstance())!;
    enqList = await DBOperation.getEnqData(db);
    notifyListeners();
  }

  changeVisible() {
    showItemList = !showItemList;
    notifyListeners();
  }

  selectGender(String selected) {
    isSelectedGender = selected;
    notifyListeners();
  }

  selectage(String selected) {
    isSelectedAge = selected;
    notifyListeners();
  }

  selectComeas(String selected) {
    isSelectedcomeas = selected;
    notifyListeners();
  }

  selectAdvertisement(String selected) {
    isSelectedAdvertisement = selected;
    notifyListeners();
  }

  // selectCsTag(String selected) {
  //   if (isSelectedCsTag == selected) {
  //     isSelectedCsTag = '';
  //   } else {
  //     isSelectedCsTag = selected;
  //   }
  //   notifyListeners();
  // }

  String? taxRate;
  String? taxCode;
// int linenum=0;
  // addProductDetails(BuildContext context) {
  //   log("sellect" + selectedItemCode.toString());
  //   log("sellect" + selectedItemName.toString());
  //   log("sellect" + quantity.toString());
  //   log("sellect" + productDetails.length.toString());

  //   if (formkey[1].currentState!.validate()) {
  //     bool itemAlreadyAdded = false;

  //     for (int i = 0; i < productDetails.length; i++) {
  //       if (productDetails[i].ItemCode == selectedItemCode) {
  //         itemAlreadyAdded = true;
  //         break;
  //       }
  //     }
  //     if (itemAlreadyAdded) {
  //       showItemList = false;
  //       mycontroller[12].clear();
  //       Navigator.pop(context);
  //       isUpdateClicked = false;
  //       notifyListeners();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Item Already Added..!!'),
  //           backgroundColor: Colors.red,
  //           elevation: 10,
  //           behavior: SnackBarBehavior.floating,
  //           margin: EdgeInsets.all(5),
  //           dismissDirection: DismissDirection.up,
  //         ),
  //       );
  //     } else {
  //       productDetails.add(DocumentLines(
  //           id: 0,
  //           docEntry: 0,
  //           linenum: 0,
  //           ItemCode: selectedItemCode,
  //           ItemDescription: selectedItemName,
  //           Quantity: quantity,
  //           LineTotal: total,
  //           Price: unitPrice,
  //           TaxCode: 0.0,
  //           TaxLiable: "tNO",
  //           storecode: isselected[0] == true ? Utils.Storecode : null,
  //           deliveryfrom: isselected[0] == true ? "store" : "Whse"));
  //       log("productslist" + productDetails.length.toString());
  //       log("product" + productDetails[0].deliveryfrom.toString());
  //       showItemList = false;
  //       mycontroller[12].clear();
  //       Navigator.pop(context);
  //       isUpdateClicked = false;
  //       notifyListeners();
  //     }
  //   }
  // }

  // updateProductDetails(BuildContext context, int i) {
  //   if (formkey[1].currentState!.validate()) {
  //     productDetails[i].Quantity = quantity;
  //     productDetails[i].Price = unitPrice;
  //     productDetails[i].LineTotal = total;
  //     showItemList = false;
  //     Navigator.pop(context);
  //     isUpdateClicked = false;
  //   }
  // }

  List<GetCustomerData>? customerdetails;

  ///call customer api

  bool customerapicLoading = false;
  bool get getcustomerapicLoading => customerapicLoading;
  bool customerapicalled = false;
  bool get getcustomerapicalled => customerapicalled;
  bool oldcutomer = false;
  String exceptionOnApiCall = '';
  String get getexceptionOnApiCall => exceptionOnApiCall;
  bool isAnother = true;
  List<GetenquiryData>? enquirydetails;
  List<GetenquiryData>? leaddetails;
  List<GetenquiryData>? quotationdetails;
  List<GetenquiryData>? orderdetails;
  callApi(BuildContext context) {
    //
    //fs
    customerapicLoading = true;
    notifyListeners();
    String? meth = ConstantApiUrl.getCustomerApi;
    GetCutomerpost reqpost =
        GetCutomerpost(customermobile: mycontroller[0].text);

    GetCustomerDetailsApi.getData(meth!, reqpost).then((value) {
      //
      // log("value" + value.itemdata.toString());
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.itemdata != null) {
          if (value.itemdata!.customerdetails!.isNotEmpty &&
              value.itemdata!.customerdetails != null) {
            customerdetails = value.itemdata!.customerdetails;
            mapValues(value.itemdata!.customerdetails![0]);
            oldcutomer = true;
            notifyListeners();
            if (value.itemdata!.enquirydetails!.isNotEmpty &&
                value.itemdata!.enquirydetails != null) {
              AssignedToDialogUserState.LookingFor =
                  value.itemdata!.enquirydetails![0].DocType;
              AssignedToDialogUserState.Store =
                  value.itemdata!.enquirydetails![0].Store;
              AssignedToDialogUserState.handledby =
                  value.itemdata!.enquirydetails![0].AssignedTo;
              AssignedToDialogUserState.currentstatus =
                  value.itemdata!.enquirydetails![0].CurrentStatus;
              alertDialogOpenLeadOREnq2(context, "enquiry");
            }
            //  else       if (value.itemdata!.orderdetails!.isNotEmpty &&
            //             value.itemdata!.orderdetails != null) {
            //                log("Anbuenq");
            //           orderdetails = value.itemdata!.orderdetails;
            //           alertDialogOpenLeadOREnq(context,"Orders");
            //         }
            else if (value.itemdata!.enquirydetails!.isNotEmpty &&
                value.itemdata!.enquirydetails != null) {
              log("Anbulead");
              for (int i = 0; i < value.itemdata!.enquirydetails!.length; i++) {
                if (value.itemdata!.enquirydetails![i].DocType == "Lead") {
                  leaddetails!.add(GetenquiryData(
                      DocType: value.itemdata!.enquirydetails![i].DocType,
                      AssignedTo: value.itemdata!.enquirydetails![i].AssignedTo,
                      BusinessValue:
                          value.itemdata!.enquirydetails![i].BusinessValue,
                      CurrentStatus:
                          value.itemdata!.enquirydetails![i].CurrentStatus,
                      DocDate: value.itemdata!.enquirydetails![i].DocDate,
                      DocNum: value.itemdata!.enquirydetails![i].DocNum,
                      Status: value.itemdata!.enquirydetails![i].Status,
                      Store: value.itemdata!.enquirydetails![i].Store));
                }
              }

              // AssignedToDialogUserState.LookingFor =
              //     value.itemdata!.enquirydetails![0].DocType;
              // AssignedToDialogUserState.Store =
              //     value.itemdata!.enquirydetails![0].Store;
              // AssignedToDialogUserState.handledby =
              //    value.itemdata!.enquirydetails![0].AssignedTo;
              // AssignedToDialogUserState.currentstatus =
              //     value.itemdata!.enquirydetails![0].CurrentStatus;

              // alertDialogOpenLeadOREnq2(context, "Lead");
            } else if (value.itemdata!.enquirydetails!.isNotEmpty &&
                value.itemdata!.enquirydetails != null) {
              for (int i = 0; i < value.itemdata!.enquirydetails!.length; i++) {
                if (value.itemdata!.enquirydetails![i].DocType == "Enquiry") {
                  enquirydetails!.add(GetenquiryData(
                      DocType: value.itemdata!.enquirydetails![i].DocType,
                      AssignedTo: value.itemdata!.enquirydetails![i].AssignedTo,
                      BusinessValue:
                          value.itemdata!.enquirydetails![i].BusinessValue,
                      CurrentStatus:
                          value.itemdata!.enquirydetails![i].CurrentStatus,
                      DocDate: value.itemdata!.enquirydetails![i].DocDate,
                      DocNum: value.itemdata!.enquirydetails![i].DocNum,
                      Status: value.itemdata!.enquirydetails![i].Status,
                      Store: value.itemdata!.enquirydetails![i].Store));
                }
              }
              log("Anbuenq");
              enquirydetails = value.itemdata!.enquirydetails;
            }
          } else {
            oldcutomer = false;
            customerapicLoading = false;
            notifyListeners();
          }
        } else if (value.itemdata == null) {
          oldcutomer = false;
          customerapicLoading = false;
          notifyListeners();
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        customerapicLoading = false;
        exceptionOnApiCall = '${value.message!}..!!${value.exception}..!!';
        notifyListeners();
      } else if (value.stcode == 500) {
        customerapicLoading = false;
        exceptionOnApiCall =
            '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
        notifyListeners();
      }
    });
  }

  FocusNode focusNode2 = FocusNode();
  void alertDialogOpenLeadOREnq2(BuildContext context, String typeOfDataCus) {
    showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          AssignedToDialogUserState.typeOfDataCus = typeOfDataCus;
          return WarningDialog();
        }).then((value) {
      if (isAnother == false) {
        FocusScope.of(context).requestFocus(focusNode2);
      } else {}
    });
  }

  static String typeOfLeadOrEnq = '';
  static String branchOfLeadOrEnq = '';

  cancelDialog(BuildContext context) {
    exceptionOnApiCall = '';
    customerapicLoading = false;
    mycontroller[0].clear();
    notifyListeners();
    Navigator.pop(context);
  }

  clearnum() {
    value3 = false;
    mycontroller[19].clear();
    mycontroller[20].clear();
    mycontroller[21].clear();
    mycontroller[22].clear();
    mycontroller[23].clear();
    mycontroller[24].clear();
    mycontroller[16].clear();
    mycontroller[1].clear();
    mycontroller[25].clear();
    mycontroller[18].clear();
    mycontroller[2].clear();
    mycontroller[7].clear();
    mycontroller[4].clear();
    mycontroller[5].clear();
    mycontroller[6].clear();
    mycontroller[17].clear();
    mycontroller[3].clear();
    isSelectedCusTagcode = '';
    customerapicLoading = false;
    notifyListeners();
  }

  String statecode = '';
  String countrycode = '';
  String statename = '';
  bool isText1Correct = false;
  String statecode2 = '';
  String countrycode2 = '';
  String statename2 = '';
  bool isText1Correct2 = false;

  methidstate2(String name) {
    statecode2 = '';
    statename2 = '';
    countrycode2 = '';

    log("ANBU");
    for (int i = 0; i < filterstateData.length; i++) {
      if (filterstateData[i].stateName.toString().toLowerCase() ==
          name.toString().toLowerCase()) {
        statecode2 = filterstateData[i].statecode.toString();
        statename2 = filterstateData[i].stateName.toString();
        countrycode2 = filterstateData[i].countrycode.toString();
        isText1Correct2 = false;

        log("statecode22:::" + statecode2.toString());
      }
    }
    //  notifyListeners();
  }

  methidstate(String name, BuildContext context) {
    statecode = '';
    statename = '';
    countrycode = '';

    log("ANBU");
    for (int i = 0; i < filterstateData.length; i++) {
      if (filterstateData[i].stateName.toString().toLowerCase() ==
          name.toString().toLowerCase()) {
        statecode = filterstateData[i].statecode.toString();
        statename = filterstateData[i].stateName.toString();
        countrycode = filterstateData[i].countrycode.toString();
        isText1Correct = false;
// FocusScope.of(context).unfocus();
        log("22222state:::" + statecode.toString());
      }
    }
    //  notifyListeners();
  }

  List<StateHeaderData> stateData = [];
  List<StateHeaderData> filterstateData = [];
  stateApicallfromDB() async {
    stateData.clear();
    filterstateData.clear();

    final Database db = (await DBHelper.getInstance())!;
    stateData = await DBOperation.getstateData(db);
    filterstateData = stateData;
    log("filterstateData length::" + filterstateData.length.toString());
    notifyListeners();
  }

  filterListState2(String v) {
    if (v.isNotEmpty) {
      filterstateData = stateData
          .where((e) => e.stateName!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.name!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      filterstateData = stateData;
      notifyListeners();
    }
  }

  static List<String> dataenq = [];
  mapValues(GetCustomerData itemdata) {
    // mycontroller[0].text = itemdata[0].CardCode!;
    mycontroller[16].text = itemdata.customerName == null ||
            itemdata.customerName!.isEmpty ||
            itemdata.customerName == 'null'
        ? ''
        : itemdata.customerName!;
    mycontroller[1].text = itemdata.contactName == null ||
            itemdata.contactName == 'null' ||
            itemdata.contactName!.isEmpty
        ? ''
        : itemdata.contactName!;
    mycontroller[25].text = itemdata.gst == null ||
            itemdata.gst == '' ||
            itemdata.gst == 'null' ||
            itemdata.gst!.isEmpty
        ? ''
        : itemdata.gst!;
    mycontroller[18].text = itemdata.State == null ||
            itemdata.State == 'null' ||
            itemdata.State!.isEmpty
        ? ''
        : itemdata.State!;
    mycontroller[2].text = itemdata.Address_Line_1 == null ||
            itemdata.Address_Line_1!.isEmpty ||
            itemdata.Address_Line_1 == 'null'
        ? ''
        : itemdata.Address_Line_1!;
    mycontroller[7].text = itemdata.email == null ||
            itemdata.email!.isEmpty ||
            itemdata.email == 'null'
        ? ''
        : itemdata.email!;
    mycontroller[4].text = itemdata.Pincode == null ||
            itemdata.Pincode!.isEmpty ||
            itemdata.Pincode == 'null' ||
            itemdata.Pincode == '0'
        ? ''
        : itemdata.Pincode!;
    mycontroller[5].text = itemdata.City == null ||
            itemdata.City!.isEmpty ||
            itemdata.City == 'null'
        ? ''
        : itemdata.City!;
    mycontroller[6].text = itemdata.altermobileNo == null ||
            itemdata.altermobileNo == 'null' ||
            itemdata.altermobileNo!.isEmpty
        ? ''
        : itemdata.altermobileNo!;
    mycontroller[17].text = itemdata.area == null ||
            itemdata.area == 'null' ||
            itemdata.area!.isEmpty
        ? ''
        : itemdata.area!;

    mycontroller[3].text = itemdata.Address_Line_2 == null ||
            itemdata.Address_Line_2 == 'null' ||
            itemdata.Address_Line_2!.isEmpty
        ? ''
        : itemdata.Address_Line_2!;
//          if(dataenq[14] !=null ||dataenq[14] != "null"||dataenq[14].isNotEmpty) {
// for(int i=0;i<ordertypedata.length;i++){
//           if(ordertypedata[i].Name==dataenq[14]){
// valueChosedStatus=ordertypedata[i].Code;
//           }
//         }
//        }
    customerapicLoading = false;
    for (int i = 0; i < customerTagTypeData.length; i++) {
      if (customerTagTypeData[i].Name == itemdata.customerGroup) {
        isSelectedCusTagcode = customerTagTypeData[i].Code.toString();
        notifyListeners();
      }
    }
    notifyListeners();
  }

  static List<String> datafrommodify = [];
  static List<String> datafromquotes = [];
  static List<String> datafromlead = [];
  static List<String> datafromsiteout = [];
  static List<String> datafromfollow = [];
  static List<String> datafromopenlead = [];
  static String iscomfromSiteOutMobile = '';

  int? ordernum;

  int? ordocentry;
  bool? comeforreadonly = false;

  int? reyear;
  int? remonth;
  int? reday;
  int? rehours;
  int? reminutes;

  String? valueChosedStatus;
  String? valueChosedCusType;
  choosedType(String? val) {
    valueChosedCusType = val;
    notifyListeners();
  }

  choosedStatus(String? val) {
    valueChosedStatus = val;
    notifyListeners();
  }

  clearAllData() {
    log("step1");
    leveofdata.clear();
    ordertypedata.clear();
    valueChosedStatus = null;
    valueChosedCusType = null;
    valueChosedCusType = null;
    mycontroller[27].clear();
    mycontroller[28].clear();
    mycontroller[29].clear();
    mycontroller[30].clear();

    reyear = null;
    reminderOn = false;
    remonth = null;
    reday = null;
    rehours = null;
    reminutes = null;
    isTextFieldEnabled = true;
    iscomeforupdate = false;
    String statecode = '';
    String countrycode = '';
    String statename = '';
    statebool = false;
    statebool2 = false;
    isText1Correct = false;
    isText1Correct2 = false;
    isAnother == true;
    mycontroller[0].clear();
    mycontroller[1].clear();
    mycontroller[2].clear();
    mycontroller[3].clear();
    mycontroller[4].clear();
    mycontroller[5].clear();
    mycontroller[6].clear();
    mycontroller[7].clear();
    mycontroller[8].clear();
    mycontroller[9].clear();
    mycontroller[10].clear();
    mycontroller[11].clear();
    mycontroller[12].clear();
    mycontroller[13].clear();
    mycontroller[14].clear();
    mycontroller[15].clear();
    mycontroller[16].clear();
    mycontroller[17].clear();
    mycontroller[18].clear();
    mycontroller[19].clear();
    mycontroller[20].clear();
    mycontroller[21].clear();
    mycontroller[22].clear();
    mycontroller[23].clear();
    mycontroller[24].clear();
    mycontroller[25].clear();
    mycontroller[31].clear();

    value3 = false;
    isSelectedpaymentTermsList = '';
    isSelectedpaymentTermsCode = '';
    isSelectedenquirytype = '';
    isSelectedAge = '';
    isSelectedcomeas = '';
    isSelectedGender = '';
    isSelectedAdvertisement = '';
    isSelectedenquiryReffers = '';
    isSelectedCusTag = '';
    isSelectedCusTagcode = "";
    CusTag = null;
    customerapicalled = false;
    oldcutomer = false;
    customerapicLoading = false;
    // productDetails.clear();
    exceptionOnApiCall = '';

    showItemList = true;
    isSelectedCusTag = '';
    // isComeFromEnq = false;s
    isloadingBtn = false;
    // autoIsselectTag = false;
    enqID = null;
    basetype = null;
    log("step2");

    // resetListSelection();
    log("step3");

    notifyListeners();
  }

  String apiFDate = '';
  void showFollowupDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value == null) {
        return;
      }
      String chooseddate = value.toString();
      var date = DateTime.parse(chooseddate);
      chooseddate = "";
      chooseddate =
          "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
      apiFDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}.${date.millisecond.toString().padLeft(3, '0')}Z";
      print("delivery date" + apiFDate);
      reyear = date.year;
      remonth = date.month;
      reday = date.day;
      mycontroller[13].text = chooseddate;
      notifyListeners();
    });
  }

  String apiNdate = '';
  void showPaymentDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value == null) {
        return;
      }
      String chooseddate = value.toString();
      var date = DateTime.parse(chooseddate);
      chooseddate = "";
      chooseddate =
          "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
      apiNdate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}.${date.millisecond.toString().padLeft(3, '0')}Z";
      print(apiNdate);

      mycontroller[31].text = chooseddate;
      notifyListeners();
    });
  }

  int docnum = 0;
  bool iscomeforupdate = false;

//save all values tp server

  saveToServer(BuildContext context) async {
    // await callcustomerapi();
    log("Step----------1");

    String date = config.currentDateOnly();
    PatchExCus patch = new PatchExCus();
    patch.CardCode = mycontroller[0].text;
    patch.CardName = mycontroller[16].text;
    //patch.CardType =  mycontroller[2].text;
    patch.U_Address1 =
        mycontroller[2].text == null || mycontroller[2].text.isEmpty
            ? null
            : mycontroller[2].text;
    patch.U_Address2 =
        mycontroller[3].text == null || mycontroller[3].text.isEmpty
            ? null
            : mycontroller[3].text;
    patch.area = mycontroller[17].text == null || mycontroller[17].text.isEmpty
        ? null
        : mycontroller[17].text;
    patch.U_ShipAddress1 =
        mycontroller[19].text == null || mycontroller[19].text.isEmpty
            ? null
            : mycontroller[19].text;
    patch.U_ShipAddress2 =
        mycontroller[20].text == null || mycontroller[20].text.isEmpty
            ? null
            : mycontroller[20].text;
    patch.U_Shiparea =
        mycontroller[21].text == null || mycontroller[21].text.isEmpty
            ? null
            : mycontroller[21].text;
    patch.altermobileNo =
        mycontroller[6].text == null || mycontroller[6].text.isEmpty
            ? null
            : mycontroller[6].text;
    patch.cantactName =
        mycontroller[1].text == null || mycontroller[1].text.isEmpty
            ? null
            : mycontroller[1].text;
    patch.gst = mycontroller[25].text == null || mycontroller[25].text.isEmpty
        ? null
        : mycontroller[25].text;
    patch.U_ShipCity =
        mycontroller[22].text == null || mycontroller[22].text.isEmpty
            ? null
            : mycontroller[22].text;
    patch.U_ShipState = statecode2;
    patch.U_ShipPincode =
        mycontroller[23].text == null || mycontroller[23].text.isEmpty
            ? null
            : mycontroller[23].text;
    patch.U_Pincode =
        mycontroller[4].text == null || mycontroller[4].text.isEmpty
            ? null
            : mycontroller[4].text;
    patch.U_City = mycontroller[5].text == null || mycontroller[5].text.isEmpty
        ? null
        : mycontroller[5].text;
    patch.U_State = statecode;
    patch.U_Country = countrycode;
    patch.U_ShipCountry = countrycode2;
    patch.levelof = valueChosedStatus == null || valueChosedStatus!.isEmpty
        ? null
        : valueChosedStatus;
    patch.ordertype = valueChosedCusType == null || valueChosedCusType!.isEmpty
        ? null
        : valueChosedCusType;

    // patch.gst=
    //patch.U_Country =  mycontroller[6].text;
    patch.U_EMail = mycontroller[7].text == null || mycontroller[7].text.isEmpty
        ? null
        : mycontroller[7].text;
    patch.U_Type = isSelectedCusTagcode;

    PostOrder? postLead = new PostOrder();
    postLead.updateDate = config.currentDate();
    postLead.updateid = int.parse(Utils.userId.toString());
    postLead.slpCode = Utils.slpcode;
    patch.docent = ordocentry == null ? null : ordocentry;
    patch.ordernum = ordernum == null ? null : ordernum;
    postLead.docEntry = 0; //
    postLead.docnum = docnum + 1; //
    postLead.docstatus = "open"; //
    // postLead.doctotal = double.parse(getTotalOrderAmount());
    // postLead.DocType = "dDocument_Items"; //
    postLead.CardCode = mycontroller[0].text; //
    postLead.CardName = mycontroller[16].text; //
    postLead.DocDate = config.currentDate(); //
    postLead.deliveryDate = apiFDate;
    postLead.paymentDate = apiNdate;
    patch.enqid = enqID == null ? 0 : enqID;
    patch.enqtype = basetype == null ? -1 : basetype;
    // List<DocumentLines> productDetails2 = [];
    // for (int i = 0; i < productDetails.length; i++) {
    //   productDetails[i].linenum = i + 1;
    //   notifyListeners();
    // }
    // productDetails2 = productDetails;
    // // postLead.U_sk_planofpurchase = apiNdate;
    // postLead.docLine = productDetails2;
    // postLead.slpCode = Utils.slpcode; //enqID
    postLead.enqID = enqID;
//
    postLead.U_sk_leadId = "";

    postLead.paymentTerms = isSelectedpaymentTermsCode;
    postLead.poReference = mycontroller[14].text;
    postLead.notes = mycontroller[15].text;
    // postLead.deliveryDate = mycontroller[13].text;

//
    if (iscomeforupdate == false) {
      isloadingBtn = true;
      notifyListeners();
      addCustomerPOstApiMethod(context, postLead, patch);
    }
    //
    else {}
  }

  addCustomerPOstApiMethod(
      BuildContext context, PostOrder postLead, PatchExCus? patch) async {
    notifyListeners();
    String meth = ConstantApiUrl.addCustomerApi!;
    await AddCustomerPostApi.getData(meth, postLead, patch!).then((value) {
      log("ANBUUU stcode " + value.stcode.toString());

      if (value.stcode! >= 200 && value.stcode! <= 210) {
        successRes = value;
        callAlertDialog(context, '${value.message}..!!${value.exception}');

        // log("docno : " + successRes.DocNo.toString());
        notifyListeners();
        // callCheckListApi(context, value.DocEntry!);
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        log("aaaa" + value.message.toString());
        isloadingBtn = false;
        notifyListeners();
        showLeadDeatilsDialog(
            context, "${value.message}..!!${value.exception}..");
      } else if (value.stcode! >= 500) {
        isloadingBtn = false;
        notifyListeners();
        showLeadDeatilsDialog(context,
            "${value.stcode!}..!!Network Issue..\nTry again Later..!!");
      }
    });
    //
    // if (errorFiles.isNotEmpty) {
    //   showLeadDeatilsDialog(context, errorFiles);
    // }
  }

  //call save lead api
  late AddCustomerPostApi successRes;
  AddCustomerPostApi get getsuccessRes => successRes;

  bool reminderOn = false;
  setReminderOnMethod(bool val, String? title) {
    reminderOn = val;
    if (reminderOn == true) {
      // addgoogle(title);
      notifyListeners();
    }
    notifyListeners();
  }

  // call save apis
  callAlertDialog(BuildContext context, String mesg) async {
    showDialog<dynamic>(
        context: context,
        builder: (_) {
          return AlertMsg(
            msg: '$mesg',
          );
        }).then((value) async {
      clearAllData();
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(ConstantRoutes.dashboard);
    });
  }

  setArgument(String mobileno, BuildContext context) {
    if (mobileno.isNotEmpty) {
      mycontroller[0].text = mobileno;
      // callApi(context);
    }
    notifyListeners();
  }

  bool isloadingBtn = false;
  bool get getisloadingBtn => isloadingBtn;

  //
  int docnum1 = 0;

  bool remswitch = true;
  switchremainder(bool val) {
    remswitch = val;
    notifyListeners();
  }

  stateontap2(int i) {
    log("AAAA::" + i.toString());
    statebool2 = false;
    mycontroller[24].text = filterstateData[i].stateName.toString();
    statecode2 = filterstateData[i].statecode.toString();
    statename2 = filterstateData[i].stateName.toString();
    countrycode2 = filterstateData[i].countrycode.toString();
    log("statecode::" + statecode2.toString());
    log("statecode::" + countrycode2.toString());
    notifyListeners();
  }

  stateontap(int i) {
    log("AAAA::" + i.toString());
    statebool = false;
    mycontroller[18].text = filterstateData[i].stateName.toString();
    statecode = filterstateData[i].statecode.toString();
    statename = filterstateData[i].stateName.toString();
    countrycode = filterstateData[i].countrycode.toString();
    log("statecode::" + statecode.toString());
    log("statecode::" + countrycode.toString());
    notifyListeners();
  }
  //for success page

  //next btns

  firstPageNextBtn(BuildContext context) {
    int passed = 0;

    if (formkey[0].currentState!.validate()) {
      if (isSelectedCusTagcode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter Customer Group..!!'),
            backgroundColor: Colors.red,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(5),
            dismissDirection: DismissDirection.up,
          ),
        );
      }
      // if (mycontroller[18].text.isNotEmpty ) {

      //     methidstate(mycontroller[18].text);
      //     notifyListeners();

      // }
      else if (mycontroller[18].text.isEmpty ||
          statecode.isEmpty && countrycode.isEmpty) {
        isText1Correct = true;
        notifyListeners();
      }
      // else  if (mycontroller[24].text.isNotEmpty) {

      //       methidstate2(mycontroller[24].text);
      //       notifyListeners();

      //   }
      else if (mycontroller[24].text.isEmpty ||
          statecode2.isEmpty && countrycode2.isEmpty) {
        isText1Correct2 = true;
        notifyListeners();
      } else {
        if (passed == 0) {
          saveToServer(context);
          // resetValidate();
        }
      }
    }
    notifyListeners();
  }

  // seconPageBtnClicked() {
  //   if (productDetails.length > 0) {
  //     pageController.animateToPage(++pageChanged,
  //         duration: Duration(milliseconds: 250), curve: Curves.bounceIn);
  //   } else {
  //     Get.snackbar("Field Empty", "Choose products..!!",
  //         backgroundColor: Colors.red);
  //   }
  // }

  thirPageBtnClicked(BuildContext context) {
    int passed = 0;
    if (formkey[1].currentState!.validate()) {
      if (passed == 0) {
        // LeadSavePostApi.printData(postLead);
        saveToServer(context);
      }
    }
    if (isSelectedenquiryReffers.isEmpty) {
      visibleRefferal = true;
    }
    notifyListeners();
  }

  showLeadDeatilsDialog(BuildContext context, String msg) {
    showDialog<dynamic>(
        context: context,
        builder: (_) {
          return AlertMsg(msg: msg);
        });
  }

  resetValidate() {
    validateGender = false;
    validateAge = false;
    validateComas = false;
    notifyListeners();
  }

  resetValidateThird() {
    visibleRefferal = false;
    notifyListeners();
  }

  bool? fileValidation = false;

  List<String> filelink = [];
  List<String> fileException = [];
  List images = [
    "assets/PDFimg.png",
    "assets/txt.png",
    "assets/xls.png",
    "assets/img.jpg"
  ];

  bool value3 = false;

  converttoShipping(bool value) {
    if (value == true) {
      mycontroller[19].text = mycontroller[2].text.toString();
      mycontroller[20].text = mycontroller[3].text.toString();
      mycontroller[21].text = mycontroller[17].text.toString();
      mycontroller[22].text = mycontroller[5].text.toString();
      mycontroller[23].text = mycontroller[4].text.toString();
      mycontroller[24].text = mycontroller[18].text.toString();
      notifyListeners();
    } else {
      mycontroller[19].text = "";
      mycontroller[20].text = "";
      mycontroller[21].text = "";
      mycontroller[22].text = "";
      mycontroller[23].text = "";
      mycontroller[24].text = "";
      notifyListeners();
    }
  }

  // getTotalOrderAmount() {
  //   double? LineTotal = 0.00;
  //   for (int i = 0; i < productDetails.length; i++) {
  //     LineTotal = LineTotal! + productDetails[i].LineTotal!;
  //   }
  //   return LineTotal!.toStringAsFixed(2);
  // }

  getExiCustomerData(String Customer, String CustomerCode) async {
    for (int i = 0; i < customerList.length; i++) {
      if (Customer == customerList[i].cardname &&
          CustomerCode == customerList[i].cardcode) {
        mycontroller[16].text = customerList[i].cardname.toString();
        mycontroller[0].text = customerList[i].mobile.toString();
        mycontroller[1].text = customerList[i].cantactName.toString();
        mycontroller[2].text = customerList[i].address1.toString();
        mycontroller[3].text = customerList[i].address2.toString();
        mycontroller[17].text = customerList[i].area.toString();
        mycontroller[5].text = customerList[i].city.toString();
        mycontroller[4].text = customerList[i].zipcode.toString();
        mycontroller[18].text = customerList[i].state.toString();
        mycontroller[6].text = customerList[i].alterMobileno.toString();
        mycontroller[7].text = customerList[i].email.toString();
        mycontroller[25].text = customerList[i].gst.toString();
        final Database db = (await DBHelper.getInstance())!;
        await DBOperation.getCusTagDataDetails(
                db, customerList[i].tag.toString().toUpperCase())
            .then((value) {
          isSelectedCusTag = value[0].Name.toString();
          CusTag = value[0].Name.toString();
          isSelectedCusTagcode = value[0].Code.toString();
        });

        // autoIsselectTag = true;

        notifyListeners();
      }
    }
    notifyListeners();
  }

  clearbool() {
    customerbool = false;
    areabool = false;
    citybool = false;
    pincodebool = false;

    notifyListeners();
  }

//
  filterListcustomer(String v) {
    if (v.isNotEmpty) {
      filterCustomerList = customerList
          .where((e) => e.cardname!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.name!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      // filterexistCusDataList = existCusDataList;
      notifyListeners();
    }
  }

  filterListArea(String v) {
    if (v.isNotEmpty) {
      filterCustomerList = customerList
          .where((e) => e.area!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.name!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      filterCustomerList = customerList;
      notifyListeners();
    }
  }

  filterListCity(String v) {
    if (v.isNotEmpty) {
      filterCustomerList = customerList
          .where((e) => e.city!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.name!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      filterCustomerList = customerList;
      notifyListeners();
    }
  }

  filterListPincode(String v) {
    if (v.isNotEmpty) {
      filterCustomerList = customerList
          .where((e) => e.zipcode!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.name!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      filterCustomerList = customerList;
      notifyListeners();
    }
  }

  filterListState(String v) {
    if (v.isNotEmpty) {
      filterCustomerList = customerList
          .where((e) => e.state!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.name!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      filterCustomerList = customerList;
      notifyListeners();
    }
  }
}
