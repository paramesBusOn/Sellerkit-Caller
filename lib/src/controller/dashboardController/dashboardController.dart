import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/GetCallLog_NativeCode.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/ItemCategoryApi.dart/ItemCategoryApi.dart';
import 'package:sellerkitcalllog/src/api/customerDetailsApiByStore/getCustomerDtlsbyStore.dart';
import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
import 'package:sellerkitcalllog/src/api/getRefferalApi/getRefferalApi.dart';
import 'package:sellerkitcalllog/src/api/leadUpdateFollowiupApi/getFollowupGetResonApi.dart';
import 'package:sellerkitcalllog/src/api/orderApi/getAllOrders.dart';
import 'package:sellerkitcalllog/src/api/orderApi/getOrderQTHApi.dart';
import 'package:sellerkitcalllog/src/api/paymentModeApi/paymentApi.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBHelper.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBOperation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/checkEnqDetailsApi/checkEnqDetailsApi.dart';
import '../../api/getCustomerApi/getCustomerApi.dart';
import '../../api/getUserListApi/getUserListApi.dart';
import '../../api/leadUpdateFollowiupApi/allLeadSaveApi.dart';
import '../../api/leadUpdateFollowiupApi/getLeadOpenapi.dart';
import '../../api/leadUpdateFollowiupApi/getLeadQTHDetailsApi.dart';
import '../../api/leadUpdateFollowiupApi/getLeadStatusApi.dart';
import '../../api/outStandingApi/getOutStandingApi.dart';
import '../../dBModel/outstandingDBmodel.dart';
import '../../dBModel/outstandinglinechild.dart';
import '../../pages/dasboard/screens/dashboardPage.dart';
import '../../pages/dasboard/widgets/networkandLocationBox.dart';

class DashboardController extends ChangeNotifier {
  init() async {
    refershAfterClosedialog();
    clearAllListData();
    // setArgument(context);
    await getAllOutstandingscall();
    calllog();
    getCusTagType();
    getCatagoryApi();
    getEnqRefferes();
    callpaymodeApi();
    callinitApi();
    getLeadStatus();
  }

  clearInit() async {
    dashbordTextController.clear();
    notifyListeners();
  }

  String docentry = '';
  setDocentry(String value) {
    docentry = value;
    notifyListeners();
  }

  String mobileno2 = '';
  List<CustomerTagTypeData2> cusTagList = [];
  List<CustomerTagTypeData2> get getCusTagList => cusTagList;
  String isSelectedCsTag = '';
  String get getisSelectedCsTag => isSelectedCsTag;
  Config config = Config();
  List<EnqRefferesData> enqReffList = [];
  List<EnqRefferesData> get getenqReffList => enqReffList;
  List<GetLeadDeatilsQTHData> leadDeatilsQTHData = [];
  List<GetLeadDeatilsQTHData> get getleadDeatilsQTHData => leadDeatilsQTHData;

  List<GetOrderDeatilsQTHData> orderDeatilsQTHData = [];
  List<GetOrderDeatilsQTHData> get getOrderDeatilsQTHData =>
      orderDeatilsQTHData;

  List<GetOrderQTLData> orderDeatilsQTLData = [];
  List<GetOrderQTLData> get getOrderDeatilsQTLData => orderDeatilsQTLData;

  List<GetLeadQTLData> leadDeatilsQTLData = [];
  List<GetLeadQTLData> get getleadDeatilsQTLData => leadDeatilsQTLData;

  getCusTagType() async {
    final Database db = (await DBHelper.getInstance())!;
    cusTagList = await DBOperation.getCusTagData(db);
    notifyListeners();
  }

  bool customerDetailsBoxbool = false;
  Future<void> setArgument(BuildContext context, String mobileno) async {
    log("argument:$mobileno");
    if (mobileno.isNotEmpty) {
      // mycontroller[0].text = mobileno;
      await callApi(context, mobileno);
    }
  }

  popupmenu(BuildContext context) async {
    await showDialog<dynamic>(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return setupAlerbox(
              // address: adrress,
              );
        }).then((value) {}).then((value) {
      notifyListeners();
    }).then((value) {});
  }

  getEnqRefferes() async {
    final Database db = (await DBHelper.getInstance())!;

    enqReffList = await DBOperation.getEnqRefferes(db);
    notifyListeners();
  }

  choosedType(String? val) {
    categoryValue = val!;
    notifyListeners();
  }

  choosedRefferType(String? val) {
    enqReffeValue = val!;
    notifyListeners();
  }

  String? categoryValue;
  String? enqReffeValue;

  List<String> catagorydata = [];
  List<String> filtercatagorydata = [];
  getCatagoryApi() async {
    catagorydata.clear();
    filtercatagorydata.clear();
    String? meth1 = ConstantApiUrl.getItemCategoryApi;

    await ItemMasterCategoryApi.getData(meth1!).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        catagorydata = value.itemdata!;
        filtercatagorydata = catagorydata;
      }
    });
  }

  selectCsTag(String selected) {
    if (isSelectedCsTag == selected) {
      isSelectedCsTag = '';
    } else {
      isSelectedCsTag = selected;
    }
    notifyListeners();
  }

  Future getPermissionUser() async {
    if (await Permission.phone.request().isGranted) {
    } else {
      await Permission.phone.request();
    }
    if (await Permission.contacts.request().isGranted) {
    } else {
      await Permission.contacts.request();
    }
  }

  List<Callloginfo> callsInfo = [];

  List<Contact> contactList = [];
  List<TextEditingController> mycontroller =
      List.generate(30, (i) => TextEditingController());
  TextEditingController dashbordTextController = TextEditingController();
  void calllog() async {
    String? getToken = await HelperFunctions.getTokenSharedPreference();
    Utils.token = getToken;
    getPermissionUser();
    if (Platform.isAndroid) {
      Iterable<CallLogEntry> entries = await CallLog.get();
      for (var item in entries) {
        if (item.callType.toString().contains('incoming')) {
          callsInfo.add(Callloginfo(
              name: item.callType.toString(),
              number: item.number,
              duration: item.name.toString()));
        }
      }
    } else {
      List<Object?> result = await CallLogService.getCallLog();
      List<dynamic> listWithoutNulls =
          result.where((element) => element != null).toList();
      List<Contact> contacts = listWithoutNulls
          .map((item) => Contact(
                firstName: item['firstName'],
                lastName: item['lastName'],
                phoneNumbers: List<String>.from(item['phoneNumbers']),
              ))
          .toList();
      for (int i = 0; i < contacts.length; i++) {
        callsInfo.add(Callloginfo(
            name: contacts[i].firstName.toString(),
            number: contacts[i].phoneNumbers.toString(),
            duration: ''));
      }
      notifyListeners();
    }
  }

  // resetDialogBox() {
  //   viewDefault = false;
  //   viewLeadDtls = false;
  //   viewOutStatndingDtls = false;
  //   viewOrderDtls = false;
  //   notifyListeners();
  // }

  showdialog(BuildContext context, String mobileno) async {
    mobileno2 = mobileno;
    dashbordTextController.text = mobileno2;
    print(dashbordTextController);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 50));
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mobileno.isNotEmpty) {
      await callApi(context, mobileno);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),

              // title: Text("hi"),
              content: const NewWidget());
        },
      ).then((value) {
        refershAfterClosedialog();
      });
    }
    notifyListeners();
    await HelperFunctions.saveNavigationCountSharedPreference('false');
    // });
  }

  showdialogAddContact(BuildContext context, String mobileno) async {
    mobileno2 = mobileno;

    await Future.delayed(const Duration(milliseconds: 50));
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mobileno.isNotEmpty) {
      // await callApi(context, mobileno);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),

              // title: Text("hi"),
              content: const AddtoContact());
        },
      ).then((value) {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //         insetPadding: const EdgeInsets.all(10),
        //         contentPadding: const EdgeInsets.all(0),
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10)),

        //         // title: Text("hi"),
        //         content: const AskAgainBox());
        //   },
        // ).then((value) {
        //   viewDefault = false;
        //   viewLeadDtls = false;
        //   viewOutStatndingDtls = false;
        //   viewOrderDtls = false;
        //   notifyListeners();
        //   // context.read<DashboardController>().refershAfterClosedialog();
        // });
        refershAfterClosedialog();
      });
    }
    notifyListeners();
    // });
  }

  List<CheckEnqDetailsData>? checkEnqDetailsData = [];

  List<GetCustomerData>? customerdetails;
  List<GetenquiryData> enquirydetails = [];
  List<GetenquiryData> leaddetails = [];
  List<GetenquiryData>? quotationdetails = [];
  List<GetenquiryData>? orderdetails = [];
  List<GetenquiryData>? customerDatalist = [];

  bool customerapicLoading = false;
  bool get getcustomerapicLoading => customerapicLoading;
  bool oldcutomer = false;
  String exceptionOnApiCall = '';
  callApi(BuildContext context, String mobile) async {
    //a
    //fs
    customerDatalist = [];
    customerapicLoading = true;
    GetCutomerpost reqpost = GetCutomerpost(customermobile: mobile);
    String meth = ConstantApiUrl.getCustomerApi!;
    await GetCustomerDetailsApi.getData(meth, reqpost).then((value) async {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.itemdata != null) {
          if (value.itemdata!.customerdetails!.isNotEmpty &&
              value.itemdata!.customerdetails != null) {
            customerdetails = value.itemdata!.customerdetails;
            // mapValues(value.itemdata!.customerdetails![0]);
            oldcutomer = true;
            // }
            customerDatalist = [];

            if (value.itemdata!.enquirydetails != null) {
              for (int i = 0; i < value.itemdata!.enquirydetails!.length; i++) {
                if ((value.itemdata!.enquirydetails![i].DocType == 'Lead' ||
                        value.itemdata!.enquirydetails![i].DocType == 'Order' ||
                        value.itemdata!.enquirydetails![i].DocType ==
                            'Outstanding') &&
                    value.itemdata!.enquirydetails![i].Status!
                        .contains('Open')) {
                  customerDatalist!.add(GetenquiryData(
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
              // await Future.delayed(Duration(milliseconds: 50));
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   showDialog(
              //       builder: (_) {
              //         return CustomerDetailsViewBox(
              //           customerDatalist: customerDatalist!,
              //           customerdetails: customerdetails,
              //           // dashbordCnt: dashbordCnt,
              //         );
              //       },
              //       context: context);
              // });
            }
            // else if (value.itemdata!.enquirydetails!.isNotEmpty &&
            //     value.itemdata!.enquirydetails != null) {
            //   for (int i = 0; i < value.itemdata!.enquirydetails!.length; i++) {

            //   }
            //   log("Anbuenq");
            //   enquirydetails = value.itemdata!.enquirydetails;

            // }
          } else {
            oldcutomer = false;
            customerapicLoading = false;
            await Future.delayed(const Duration(milliseconds: 50));
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   showDialog(
            //       builder: (_) {
            //         return CustomerDetailsViewBox(
            //           customerDatalist: customerDatalist!,
            //           customerdetails: customerdetails,
            //           // dashbordCnt: dashbordCnt,
            //         );
            //       },
            //       context: context);
            // });
          }
        } else if (value.itemdata == null) {
          oldcutomer = false;
          customerapicLoading = false;
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        customerapicLoading = false;
        exceptionOnApiCall = '${value.stcode!}..!!${value.exception}..!! ';
      } else if (value.stcode == 500) {
        customerapicLoading = false;
        exceptionOnApiCall =
            '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
      }
    });
    for (int i = 0; i < valueDBmodel.length; i++) {
      if (valueDBmodel[i].customerCode == mobile) {
        customerDatalist!.add(GetenquiryData(
            DocType: 'Outstanding',
            AssignedTo: valueDBmodel[i].assignedTo,
            BusinessValue: valueDBmodel[i].amountPaid,
            CurrentStatus: 'Open',
            DocDate: '',
            DocNum: valueDBmodel[i].customerCode != null
                ? int.parse(valueDBmodel[i].customerCode.toString())
                : 0,
            Status: 'Open',
            Store: valueDBmodel[i].storeCode));
      }
    }
  }

  viewDetailsMethod(String mobile, String docentry, String doctype,
      BuildContext context) async {
    String doctype2 = doctype;
    switch (doctype2) {
      case 'Order':
        viewOrderDtls = !viewOrderDtls;
        notifyListeners();
        if (viewOrderDtls == true) {
          setDocentry(docentry);
          await callOrderDetailsQTHApi(docentry);
          setviewBool(doctype, context);
        } else {
          setviewBool('', context);
        }
        break;
      case 'Outstanding':
        viewOutStatndingDtls = !viewOutStatndingDtls;
        notifyListeners();
        if (viewOutStatndingDtls == true) {
          setDocentry(docentry);

          await setOutstandingDetails(mobile);
          setviewBool(doctype, context);
        } else {
          setviewBool('', context);
        }
        break;
      case 'Lead':
        viewLeadDtls = !viewLeadDtls;
        notifyListeners();
        if (viewLeadDtls == true) {
          await refershAfterClosedialog();
          await clearAllListData();
          setDocentry(docentry);
          await callGetLeadDeatilsApi(docentry);
          setviewBool(doctype, context);
        } else {
          await refershAfterClosedialog();
          await clearAllListData();
          setviewBool('', context);
        }
        break;
      default:
    }
    notifyListeners();
  }

  setviewBool(String doctype, BuildContext context) {
    String doctype2 = doctype;
    switch (doctype2) {
      case 'Order':
        viewOrderDtls = true;
        viewLeadDtls = false;
        viewOutStatndingDtls = false;
        viewDefault = false;
        notifyListeners();

        break;
      case 'Outstanding':
        viewOrderDtls = false;
        viewLeadDtls = false;
        viewOutStatndingDtls = true;
        viewDefault = false;
        notifyListeners();

        break;
      case 'Lead':
        viewOrderDtls = false;
        viewLeadDtls = true;
        viewOutStatndingDtls = false;
        viewDefault = false;
        notifyListeners();

        break;
      default:
        callApi(context, dashbordTextController.text);
        refreshSucessdialog();
        clearAllListData();
        viewOrderDtls = false;
        viewLeadDtls = false;
        viewOutStatndingDtls = false;
        viewDefault = true;
        notifyListeners();
    }
    notifyListeners();
  }

  bool loadOrderViewDtlsApi = false;
  String errorOrderViewDtls = '';
  bool viewOrderDtls = false;
  bool viewLeadDtls = false;
  bool viewOutStatndingDtls = false;
  bool viewDefault = true;

  callOrderDetailsQTHApi(String orderDocNum) async {
    List<GetAllOrderData> tempOrderAll = [];
    String orderDocENtry = '';
    orderDeatilsQTHData = [];
    orderDeatilsQTLData = [];
    errorOrderViewDtls = '';
    loadOrderViewDtlsApi = true;
    String meth = ConstantApiUrl.getAllOrdersApi!;
    notifyListeners();

    await GetAllOrderApi.getData(meth).then((value) {
      if (value.stcode! <= 210 && value.stcode! >= 200) {
        tempOrderAll = value.ordercheckdatageader!.Ordercheckdata!;
      }
    }).then((value) {
      for (int i = 0; i < tempOrderAll.length; i++) {
        if (tempOrderAll[i].orderNum.toString() == orderDocNum) {
          orderDocENtry = tempOrderAll[i].orderDocEntry.toString();
          break;
        }
      }
    });
    if (orderDocENtry.isNotEmpty) {
      errorOrderViewDtls = '';
      String? meth2 = ConstantApiUrl.getOrderQTHApi(orderDocENtry);

      await GetOrderDetailsQTHApi.getData(meth2!).then((value) {
        log("ststus code");
        if (value.stcode! >= 200 && value.stcode! <= 210) {
          if (value.OrderDeatilsheaderData != null) {
            orderDeatilsQTHData =
                value.OrderDeatilsheaderData!.OrderDeatilsQTHData!;
            orderDeatilsQTLData =
                value.OrderDeatilsheaderData!.OrderDeatilsQTLData!;

            errorOrderViewDtls = '';
            loadOrderViewDtlsApi = false;
            notifyListeners();
          }
        } else if (value.stcode! >= 400 && value.stcode! <= 490) {
          errorOrderViewDtls = '${value.stcode!}..!!..${value.exception}';
          loadOrderViewDtlsApi = false;
          notifyListeners();
        } else {
          errorOrderViewDtls =
              '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
          loadOrderViewDtlsApi = false;
          notifyListeners();
        }
      });
    }
    loadOrderViewDtlsApi = false;
    notifyListeners();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  CustomerdetData? customermodeldata;
  callcustomerapi() async {
    String meth = ConstantApiUrl.getCustomerDtlsByStore!;
    await CutomerdetModalApi.getData(meth).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        customermodeldata = value.leadcheckdata;
      }
    });
  }

  List<PaymodeApiData> paymode = [];
  callpaymodeApi() async {
    paymode.clear();
    notifyListeners();
    String meth = ConstantApiUrl.getPaymodeApi!;
    await PaymodeApi.getData(meth).then((value) {
      //
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.paymode != null) {
          paymode = value.paymode!;

          notifyListeners();
        } else if (value.paymode == null) {
          log("DONR222");
          notifyListeners();
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        notifyListeners();
      } else if (value.stcode == 500) {
        notifyListeners();
      }
    });
  }

  //Lead Config
  String? valueChosedReason; //cl
  String? get getvalueChosedReason => valueChosedReason;
  String? valueChosedStatus; //cl
  String? get getvalueChosedStatus => valueChosedStatus;
  String? valueChosedStatusWon; //cl
  String? get getvalueChosedStatusWon => valueChosedStatusWon;
  List<String> data = ['', 'a'];

  String? hinttextforOpenLead = 'Select Status*: '; //cl
  String? get gethinttextforOpenLead => hinttextforOpenLead;
  String? hinttextforWonLead = 'Select Status*: '; //cl
  String? get gethinttextforWonLead => hinttextforWonLead;
  String? hinttextforLostLead = 'Select Reason*'; //cl
  String? get gethinttextforLostLead => hinttextforLostLead;
  String? feedbackLead = 'Give your feedback*'; //cl Give your feedback
  String? get getfeedbackLead => feedbackLead;
  String? nextFollowupDate = 'Next Follow up Date:*'; //cl
  String? get getnextFollowupDate => nextFollowupDate;
  String? orderBillRefer = 'Order/Bill Reference*'; //cl
  String? get getorderBillRefer => orderBillRefer;
  String? orderBillDate = 'Order/Bill Date:*'; //cl
  String? get getorderBillDate => orderBillDate;
  String? followup =
      'How you made the follow up?*'; //cl How the follow up has been made
  String? get getfollowup => followup;
  String? forwardNextFollowDate = 'Next Follow Up:*'; //cl
  String? get getforwardNextFollowDate => forwardNextFollowDate;
  //
  String? textquatationDate = 'Quatation Date'; //cl
  String? get gettextquatationDate => textquatationDate;
  String? textquatationNo = 'Quatation No'; //cl
  String? get gettextquatationNo => textquatationNo;
  String? textquatationValue = 'Quatation Value'; //cl
  String? get gettextquatationValue => textquatationValue;
  List<GetLeadPhoneData> leadphonedata = [];
  List<GetLeadPhoneData> get getleadphonedata => leadphonedata;

  String isSelectedFollowUp = '';
  String get getisSelectedFollowUp => isSelectedFollowUp;
  String isSelectedFollowUpcode = '';
  String get getisSelectedFollowUpcode => isSelectedFollowUpcode;
  selectFollowUp(String selected, String selectcode) {
    isSelectedFollowUp = selected;
    isSelectedFollowUpcode = selectcode;
    notifyListeners();
  }

  // List<GetLeadDeatilsQTHData>? leadDeatilsQTHData = [];
  // List<GetLeadDeatilsQTHData>? get getleadDeatilsQTHData => leadDeatilsQTHData;

  // List<GetLeadQTLData> leadDeatilsQTLData = [];
  // List<GetLeadQTLData> get getleadDeatilsQTLData => leadDeatilsQTLData;

  List<GetLeadDeatilsLData> leadDeatilsLData = [];
  List<GetLeadDeatilsLData> get getleadDeatilsLeadData => leadDeatilsLData;
  List<GetLeadopenData> leadopendata = [];
  List<GetLeadopenData> get getleadopendata => leadopendata;

  String caseStatusSelected = ''; //cl
  String? get getcaseStatusSelected => caseStatusSelected;
  String caseStatusSelectedcode = ''; //cl
  String? get getcaseStatusSelectedcode => caseStatusSelectedcode;
  String emptyQuataDate = ''; //cl
  String? get getemptyQuataDate => emptyQuataDate;
  String leadCheckDataExcep = '';
  String get getLeadCheckDataExcep => leadCheckDataExcep;
  List<UserListData> filteruserLtData = [];
  List<UserListData> get getfiltergetuserLtData => filteruserLtData;

  bool updateFollowUpDialog = false;
  bool get getupdateFollowUpDialog => updateFollowUpDialog;
  bool leadForwarddialog = false;
  bool get getleadForwarddialog => leadForwarddialog;
  bool leadWondialog = false;
  bool get getleadWondialog => leadWondialog;
  bool leadLostdialog = false;
  bool get getleadLostdialog => leadLostdialog;
  bool leadLoadingdialog = false;
  bool get getleadLoadingdialog => leadLoadingdialog;
  bool updateFollowUpdialog = false;
  bool get getupdateFollowUpdialog => updateFollowUpdialog;
  bool viewDetailsdialog = false;
  bool get getviewDetailsdialog => viewDetailsdialog;
  bool updateConvertToQuatationUpdialog = false;
  bool get getupdateConvertToQuatationUpdialog =>
      updateConvertToQuatationUpdialog;

  callinitApi() async {
    String meth = ConstantApiUrl.getLeadOpenApi!;
    await GetLeadopenApi.getData(meth).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        leadopendata = value.leadopendata!;
        notifyListeners();
      } else if (value.stcode! >= 400 && value.stcode! <= 490) {
        leadCheckDataExcep = "Something went wrong";
        notifyListeners();
      } else {
        leadCheckDataExcep =
            "${value.stcode!}..!!Network Issue..\nTry again Later..!!";

        notifyListeners();
      }
    });
    String meth2 = ConstantApiUrl.getLeadMadefollowupReson!;
    await GetLeadFollowupResonApi.getData(meth2).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        leadphonedata = value.leadphonedata!;

        notifyListeners();
      } else if (value.stcode! >= 400 && value.stcode! <= 490) {
        leadCheckDataExcep = "No data..!!";
        notifyListeners();
      } else {
        leadCheckDataExcep =
            "${value.stcode!}..!!Network Issue..\nTry again Later..!!";
        notifyListeners();
      }
    });
  }

  clearbool() {
    visitDt = '';
    VisitTime = '';
    errorVisitTime = '';
    notifyListeners();
  }

  clearAllListData() {
    clearbool();
    VisitTime = '';
    errorVisitTime = "";
    forwarderrorVisitTime = "";
    mycontroller[1].clear();
    mycontroller[0].clear();
    leadCheckDataExcep = '';

    leadDeatilsQTHData.clear();
    leadDeatilsQTLData.clear();
    leadDeatilsLData.clear();
    mycontroller[5].clear();
    caseStatusSelectedcode = "";
    caseStatusSelected = "";
    isSelectedFollowUp = '';
    isSelectedFollowUpcode = '';
    iscorectime = false;
    iscorectime2 = false;
    valueChosedReason = null;
    // valueChosedStatus='';
    // leadStatusOpen.clear();
    // leadStatusWon.clear();
    // leadStatusLost.clear();
    notifyListeners();
  }

  refershAfterClosedialog() {
    viewDefault = false;
    viewLeadDtls = false;
    viewOutStatndingDtls = false;
    viewOrderDtls = false;
    // dashbordTextController.clear();
    //
    forwaVisitTime = '';
    forwardnextWonFD = '';
    nextpurchasedate = '';
    nextpurchasedate = '';
    mycontroller[5].clear();
    leadCheckDataExcep = '';
    iscorectime = false;
    iscorectime2 = false;
    // leadOpenAllData.clear();
    // leadClosedAllData.clear();
    // leadLostAllData.clear();
    // filterleadOpenAllData.clear();

    // filterleadClosedAllData.clear();

    viewDetailsdialog = false;
    isSameBranch = true;
    quataDate = "";
    apiQuaDate = "";
    mycontroller[3].text = "";
    mycontroller[4].text = "";
    forwardSuccessMsg = "";
    updateConvertToQuatationUpdialog = false;
    caseStatusSelectedcode = "";
    caseStatusSelected = "";
    isSelectedFollowUp = '';
    isSelectedFollowUpcode = '';
    assignVisitTime = "Followup Time";
    leadDeatilsQTHData.clear();
    leadDeatilsQTLData.clear();
    leadDeatilsLData.clear();
    selectedUserList = '';

    notifyListeners();
  }

  String apiWonFDate = '';
  String nextWonFD = '';
  String apiwonpurchaseDate = '';
  String nextpurchasedate = '';
  String get getnextWonFD => nextWonFD;
  void showpurchaseupateDate(BuildContext context) {
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
      apiwonpurchaseDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      nextpurchasedate = chooseddate;
      notifyListeners();
    });
  }

  String apiQuaDate = '';
  String quataDate = '';
  String get getQuataDate => quataDate;

  void showQuatationDate(BuildContext context) {
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
      apiQuaDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      quataDate = chooseddate;
      notifyListeners();
    });
  }

  String apiforwardNextFollowUPDate = '';
  String forwardnextWonFD = '';
  String get getforwardnextWonFD => forwardnextWonFD;
  void showForwardNextDate(BuildContext context) {
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
      apiforwardNextFollowUPDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      forwardnextWonFD = chooseddate;
      notifyListeners();
    });
  }

  choosedStatus(String val) {
    log("val::$val");
    valueChosedStatus = val;
    notifyListeners();
  }

  choosedStatusWon(String val) {
    valueChosedStatusWon = val;
    notifyListeners();
  }

  choosedReason(String val) {
    valueChosedReason = val;
    notifyListeners();
  }

  String visitDt = '';
  String? nextVisitTime = 'Followup Time:';
  String? get getnextVisitTime => nextVisitTime;
  String? assignvisitDt = '';
  String? assignVisitTime = 'Followup Time:';
  String? get getassignVisitTime => assignVisitTime;
  bool iscorectime = false;

  String apiFDate = '';
  String nextFD = '';
  String get getnextFD => nextFD;

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
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      nextFD = chooseddate;
      notifyListeners();
    });
  }

  void showFollowupWonDate(BuildContext context) {
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
      apiWonFDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      nextWonFD = chooseddate;
      notifyListeners();
    });
  }

  static bool isSameBranch = true;
  bool get getisSameBranch => isSameBranch;

  viweDetailsClicked() {
    viewDetailsdialog = !viewDetailsdialog;
    notifyListeners();
  }

  callGetLeadDeatilsApi(String leadDocEnt) async {
    leadDeatilsQTHData.clear();
    leadDeatilsQTLData.clear();
    leadDeatilsLData.clear();
    forwardSuccessMsg = '';
    leadLoadingdialog = true;
    leadForwarddialog = true;
    updateFollowUpDialog = false;
    notifyListeners();
    String meth = ConstantApiUrl.getLeadQTHDetailsApi(leadDocEnt)!;
    await GetLeadDetailsQTHApi.getData(meth).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.leadDeatilheadsData != null) {
          leadDeatilsQTHData = value.leadDeatilheadsData!.leadcheckQTHdata!;
          leadDeatilsQTLData = value.leadDeatilheadsData!.leadDeatilsQTLData!;
          if (value.leadDeatilheadsData!.leadDeatilsLeadData != null) {
            leadDeatilsLData = value.leadDeatilheadsData!.leadDeatilsLeadData!;

// log("leadDeatilsLData::"+leadDeatilsLData[4].Feedback.toString());
          }

          leadLoadingdialog = false; //
          leadForwarddialog = false; //
          updateFollowUpDialog = false; //
          viewDetailsdialog = false; //
          notifyListeners();
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 490) {
        forwardSuccessMsg = '${value.message}..!!${value.exception}..!!';
        leadLoadingdialog = false;
        notifyListeners();
      } else {
        forwardSuccessMsg =
            '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
        leadLoadingdialog = false;
        notifyListeners();
      }
    });
  }

  ///cal forwardApi
  String forwardSuccessMsg = '';
  String get getforwardSuccessMsg => forwardSuccessMsg;
  String forwardSuccessMsgtype = '';
  String get getforwardSuccessMsgtype => forwardSuccessMsgtype;

  // forwardApi(String followDocEntry, int salesPersonEmpId) async {
  //   notifyListeners();
  //   if (forwardnextWonFD.isEmpty) {
  //     //selectedUserList
  //     forwardNextFollowDate = 'Next FollowUp*';
  //     notifyListeners();
  //   } else {
  //     forwardSuccessMsg = '';
  //     leadLoadingdialog = true;
  //     ForwardLeadUserApiData forwardLeadUserData = ForwardLeadUserApiData();
  //     forwardLeadUserData.curentDate = config.currentDateOnly();
  //     forwardLeadUserData.nextFD = apiforwardNextFollowUPDate;
  //     forwardLeadUserData.nextUser = salesPersonEmpId;
  //     String meth = ConstantApiUrl.getLeadfarwordApi(followDocEntry)!;
  //     await ForwardLeadUserApi.getData(meth, forwardLeadUserData).then((value) {
  //       if (value.stCode >= 200 && value.stCode <= 210) {
  //         forwardSuccessMsg = 'Successfully Forwarded..!!';
  //         leadLoadingdialog = false;
  //         notifyListeners();
  //       } else if (value.stCode >= 400 && value.stCode <= 410) {
  //         forwardSuccessMsg = value.error!;
  //         leadLoadingdialog = false;
  //         notifyListeners();
  //       } else if (value.stCode == 500) {
  //         forwardSuccessMsg =
  //             '${value.stCode}..!!Network Issue..\nTry again Later..!!';
  //         leadLoadingdialog = false;
  //         notifyListeners();
  //       }
  //     });
  //   }
  // }

  ///get lead status api
  List<GetLeadStatusData> leadStatusOpen = [];
  List<GetLeadStatusData> leadStatusLost = [];
  List<GetLeadStatusData> leadStatusWon = [];
  List<GetLeadStatusData> get getleadStatusOpen => leadStatusOpen;
  List<GetLeadStatusData> get getleadStatusLost => leadStatusLost;
  List<GetLeadStatusData> get getleadStatusWon => leadStatusWon;

  bool leadOpenSaveClicked = false;
  bool leadWonSaveClicked = false;
  bool leadLostSaveClicked = false;
  clickLeadSaveBtn(
      String followDocEntry, String leadDocEntry, String purchasedate) {
    if (caseStatusSelected == 'Open') {
      leadOpenSaveClicked = true;
      leadWonSaveClicked = false;
      leadLostSaveClicked = false;
      log("followDocEntry: $followDocEntry");
      log("leadDocEntry: $leadDocEntry");

      callRequiredOpen(followDocEntry, leadDocEntry, purchasedate);
    } else if (caseStatusSelected == 'Won') {
      leadWonSaveClicked = true;
      leadOpenSaveClicked = false;
      leadLostSaveClicked = false;
      callRequiredWon(followDocEntry, leadDocEntry);
    } else if (caseStatusSelected == 'Lost') {
      leadLostSaveClicked = true;
      leadOpenSaveClicked = false;
      leadWonSaveClicked = false;
      callRequiredLost(followDocEntry, leadDocEntry);
    }
  }

  String errorVisitTime = "";
  String VisitTime = '';
  String forwarderrorVisitTime = "";
  String forwaVisitTime = '';
  String get getVsitTime => VisitTime;
  callRequiredOpen(
      String followDocEntry, String leadDocEntry, String purchasedate) {
    int i = 0;
    if (valueChosedStatus == null) {
      i = i + 1;
      hinttextforOpenLead = "Select Status: *";
    } else {
      hinttextforOpenLead = "Select Status:*";
    }
    if (mycontroller[1].text.isEmpty) {
      i = i + 1;
      feedbackLead = 'Give your feedback *';
    } else {
      feedbackLead = 'Give your feedback*';
    }
    if (nextFD == '') {
      i = i + 1;
      nextFollowupDate = 'Next Follow up: *';
    } else {
      nextFollowupDate = 'Next Follow up:*';
    }
    if (VisitTime == '') {
      i = i + 1;
      nextVisitTime = 'Followup Time: *';
    } else {
      nextVisitTime = 'Followup Time:*';
    }
    if (isSelectedFollowUp == '') {
      i = i + 1;
      followup = 'How you made the follow up? *';
    } else {
      followup = 'How you made the follow up?*';
    }
    hinttextforWonLead = "Select Status:*";
    orderBillRefer = 'Order/Bill Reference*';
    orderBillDate = 'Order/Bill Date*';
    hinttextforLostLead = 'Select Reason:*';
    if (i < 1) {
      Allfollowupupdate(followDocEntry, leadDocEntry, mycontroller[1].text,
          apiFDate, "", "", "", "", purchasedate);

      // openSave(
      //     followDocEntry, valueChosedStatus, mycontroller[1].text, apiFDate);
    }
    notifyListeners();
  }

  selectVisitTime(BuildContext context) async {
    TimeOfDay timee = TimeOfDay.now();
    TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
    TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);
    if (nextFD.isNotEmpty) {
      errorVisitTime = "";
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: timee,
      );

      if (newTime != null) {
        timee = newTime;
//          if (timee.hour < startTime.hour ||
//               timee.hour > endTime.hour || (timee.hour == endTime.hour && timee.minute > endTime.minute)) {
//                 VisitTime = "";
//  iscorectime=true;
//             nextVisitTime = 'Followup Time:*';
//             notifyListeners();
//               }else{

        if (visitDt == DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          if (timee.hour < TimeOfDay.now().hour ||
              (timee.hour == TimeOfDay.now().hour &&
                  timee.minute < TimeOfDay.now().minute)) {
            errorVisitTime = "Please Choose Correct Time";
            VisitTime = "";
            iscorectime = false;
            notifyListeners();
          } else {
            errorVisitTime = "";
            VisitTime = timee.format(context).toString();
          }
        } else {
          errorVisitTime = "";
          timee = newTime;
          iscorectime = false;
          VisitTime = timee.format(context).toString();
        }
        nextVisitTime = 'Followup Time';
        notifyListeners();
        // }
      }

      notifyListeners();
    } else {
      VisitTime = "";
      // errorTime = "Please Choose First Date";
      notifyListeners();
    }
    notifyListeners();
  }

  bool iscorectime2 = false;
  forwardVisitTime(BuildContext context) async {
    TimeOfDay timee = TimeOfDay.now();
    TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
    TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);
    if (forwardnextWonFD.isNotEmpty) {
      forwarderrorVisitTime = "";
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: timee,
      );

      if (newTime != null) {
        timee = newTime;

//           if (timee.hour < startTime.hour ||
//               timee.hour > endTime.hour || (timee.hour == endTime.hour && timee.minute > endTime.minute)) {
//                 forwaVisitTime = "";
//  iscorectime2=true;
//             assignVisitTime = 'Followup Time:*';
//             notifyListeners();
//               }else{

        if (assignvisitDt == DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          if (timee.hour < TimeOfDay.now().hour ||
              (timee.hour == TimeOfDay.now().hour &&
                  timee.minute < TimeOfDay.now().minute)) {
            forwarderrorVisitTime = "Please Choose Correct Time";
            forwaVisitTime = "";
            iscorectime2 = false;
            notifyListeners();
          } else {
            errorVisitTime = "";
            iscorectime2 = false;
            forwaVisitTime = timee.format(context).toString();
          }
        } else {
          errorVisitTime = "";
          timee = newTime;
          iscorectime2 = false;
          forwaVisitTime = timee.format(context).toString();
        }
//  }
        notifyListeners();
      }
      notifyListeners();
    } else {
      VisitTime = "";
      // errorTime = "Please Choose First Date";
      notifyListeners();
    }
    notifyListeners();
  }

  Allfollowupupdate(
      String followDocEntry,
      String leadDocEntry,
      feedback,
      nextFPdate,
      billwonDate,
      billreference,
      String salesPersonEmpId,
      String checkstatus,
      purchasedate) async {
    log("purchasedate:::$purchasedate");
    forwardSuccessMsg = '';
    leadLoadingdialog = true;
    leadForwarddialog = true;
    updateFollowUpDialog = false;
    String? reasondetails;
    AllSaveLeadApi forwardLeadUserDataOpen = AllSaveLeadApi();
    if (caseStatusSelected == "Open") {
      for (int i = 0; i < leadStatusOpen.length; i++) {
        if (leadStatusOpen[i].code == valueChosedStatus) {
          reasondetails = leadStatusOpen[i].name;
        }
        notifyListeners();
      }
      if (VisitTime != '') {
        Config config = Config();

        forwardLeadUserDataOpen.nextFD =
            config.alignDateforFollow(VisitTime, nextFPdate);
      } else {
        forwardLeadUserDataOpen.nextFD = nextFPdate;
      }
      forwardLeadUserDataOpen.visitdate = null;
      forwardLeadUserDataOpen.curentDate = config.currentDate();
      forwardLeadUserDataOpen.ReasonCode = valueChosedStatus;
      forwardLeadUserDataOpen.Reasoname = reasondetails;
      forwardLeadUserDataOpen.Purchasedate = nextpurchasedate == null ||
              nextpurchasedate == '' ||
              nextpurchasedate.isEmpty
          ? purchasedate
          : apiwonpurchaseDate;
      forwardLeadUserDataOpen.followupMode = isSelectedFollowUpcode;

      forwardLeadUserDataOpen.updatedBy = Utils.slpcode;
      forwardLeadUserDataOpen.feedback = feedback;
      forwardLeadUserDataOpen.status = caseStatusSelectedcode;
      notifyListeners();
    } else if (caseStatusSelected == "Won") {
      for (int i = 0; i < leadStatusWon.length; i++) {
        if (leadStatusWon[i].code == valueChosedStatusWon) {
          reasondetails = leadStatusWon[i].name;
          log("reasondetails::$reasondetails");
        }
        notifyListeners();
      }

      forwardLeadUserDataOpen.ReasonCode = valueChosedStatusWon;
      forwardLeadUserDataOpen.Reasoname = reasondetails;
      forwardLeadUserDataOpen.billDate = billwonDate;
      forwardLeadUserDataOpen.billRef = billreference;
      forwardLeadUserDataOpen.curentDate = config.currentDate();
      forwardLeadUserDataOpen.feedback = feedback;
      forwardLeadUserDataOpen.followupMode = isSelectedFollowUpcode;
      forwardLeadUserDataOpen.nextFD = null;
      forwardLeadUserDataOpen.updatedBy = Utils.slpcode;
      forwardLeadUserDataOpen.status = caseStatusSelectedcode;
      notifyListeners();
    } else if (caseStatusSelected == "Lost") {
      for (int i = 0; i < leadStatusLost.length; i++) {
        if (leadStatusLost[i].code == valueChosedReason) {
          reasondetails = leadStatusLost[i].code;
          log("reasondetails::$reasondetails");
        }
        notifyListeners();
      }
      forwardLeadUserDataOpen.ReasonCode = valueChosedReason;
      forwardLeadUserDataOpen.Reasoname = reasondetails;
      forwardLeadUserDataOpen.curentDate = config.currentDate();
      forwardLeadUserDataOpen.feedback = feedback;
      forwardLeadUserDataOpen.followupMode = isSelectedFollowUpcode;
      forwardLeadUserDataOpen.nextFD = null;
      forwardLeadUserDataOpen.updatedBy = Utils.slpcode;
      forwardLeadUserDataOpen.status = caseStatusSelectedcode;
      notifyListeners();
    } else {
      for (int i = 0; i < leadStatusOpen.length; i++) {
        if (leadStatusOpen[i].name == checkstatus) {
          reasondetails = leadStatusOpen[i].code;
          log("reasondetails::$reasondetails");
        }

        notifyListeners();
      }
      Config config = Config();

      forwardLeadUserDataOpen.nextFD =
          config.alignDateforFollow(forwaVisitTime, apiforwardNextFollowUPDate);
      forwardLeadUserDataOpen.ReasonCode =
          reasondetails == null || reasondetails.isEmpty
              ? leadStatusOpen[0].code
              : reasondetails;
      forwardLeadUserDataOpen.Reasoname =
          reasondetails == null || reasondetails.isEmpty
              ? leadStatusOpen[0].name
              : checkstatus;
      forwardLeadUserDataOpen.status = "01";
      forwardLeadUserDataOpen.curentDate = config.currentDate();

      forwardLeadUserDataOpen.nextUser = salesPersonEmpId;
      notifyListeners();
    }
    String meth = ConstantApiUrl.allSaveLeadApi!;
    await AllSaveLeadApi.getData(meth, leadDocEntry, forwardLeadUserDataOpen)
        .then((value) {
      if (value.stCode >= 200 && value.stCode <= 210) {
        forwardSuccessMsg = "${value.error!}";
        leadLoadingdialog = false;
        notifyListeners();
      } else if (value.stCode >= 400 && value.stCode <= 410) {
        forwardSuccessMsg = "${value.error!}..!!${value.stCode}..!!";
        leadLoadingdialog = false;
        notifyListeners();
      } else if (value.stCode == 500) {
        forwardSuccessMsg =
            "${value.stCode}..!!Network Issue..\nTry again Later..!!";
        leadLoadingdialog = false;
        notifyListeners();
      }
    });
    // viewDefault = false;
    // viewLeadDtls = false;
    // viewOutStatndingDtls = false;
    // viewOrderDtls = false;
    notifyListeners();
    checkValues();
  }

  checkValues() {
    log("getupdateFollowUpDialog: $getupdateFollowUpDialog");
    log("getleadForwarddialog: $getleadForwarddialog");
    log("getleadLoadingdialog: $getleadLoadingdialog");
    log("getviewDetailsdialog :$getviewDetailsdialog");
    log("getforwardSuccessMsg: $getforwardSuccessMsg");
    log("getforwardSuccessMsg: $getforwardSuccessMsg");
    log('getisSameBranch : $getisSameBranch');
  }

  refreshSucessdialog() {
    init();
    refershAfterClosedialog();
  }

  String selectedUserList = '';
  String get getselectedUserList => selectedUserList;

  callRequiredWon(String followDocEntry, String leadDocEntry) {
    int i = 0;
    if (valueChosedStatusWon == null) {
      i = i + 1;
      hinttextforWonLead = "Select Status: *";
    } else {
      hinttextforWonLead = "Select Status:*";
    }
    if (mycontroller[0].text.isEmpty) {
      i = i + 1;

      orderBillRefer = 'Order/Bill Reference: *';
    } else {
      orderBillRefer = 'Order/Bill Reference:*';
    }
    if (mycontroller[1].text.isEmpty) {
      i = i + 1;
      feedbackLead = 'Give your feedback *';
      // orderBillRefer = 'Order/Bill Reference: *';
    } else {
      feedbackLead = 'Give your feedback*';
    }
    if (nextWonFD == '') {
      i = i + 1;
      orderBillDate = 'Order/Bill Date *';
    } else {
      orderBillDate = 'Order/Bill Date*';
    }
    if (isSelectedFollowUp == '') {
      i = i + 1;
      followup = 'How you made the follow up? *';
    } else {
      followup = 'How you made the follow up?*';
    }

    nextFollowupDate = 'Next Follow up:*';
    hinttextforLostLead = 'Select Reason:*';
    hinttextforOpenLead = "Select Status:*";
    if (i < 1) {
      Allfollowupupdate(followDocEntry, leadDocEntry, mycontroller[1].text, "",
          apiWonFDate, mycontroller[0].text, '', "", '');

      // WonSave(
      //     followDocEntry,
      //     leadDocEntry,
      //     valueChosedStatusWon,
      //     mycontroller[1].text,
      //     isSelectedFollowUp,
      //     apiWonFDate,
      //     mycontroller[0].text);
    }
    notifyListeners();
  }

  callRequiredLost(String followDocEntry, String leadDocEntry) {
    int i = 0;
    if (mycontroller[1].text.isEmpty) {
      i = i + 1;
      feedbackLead = 'Give your feedback *';
    } else {
      feedbackLead = 'Give your feedback*';
    }
    if (valueChosedReason == null) {
      i = i + 1;
      hinttextforLostLead = 'Select Reason: *';
    } else {
      hinttextforLostLead = 'Select Reason:*';
    }
    if (isSelectedFollowUp == '') {
      i = i + 1;
      followup = 'How you made the follow up? *';
    } else {
      followup = 'How you made the follow up?*';
    }
    hinttextforWonLead = "Select Status:*";
    orderBillRefer = 'Order/Bill Reference*';
    orderBillDate = 'Order/Bill Date*';
    nextFollowupDate = 'Next Follow up:*';
    hinttextforOpenLead = "Select Status:*";
    if (i < 1) {
      Allfollowupupdate(followDocEntry, leadDocEntry, mycontroller[1].text, "",
          "", "", "", "", '');

      // lostSave(followDocEntry, leadDocEntry, valueChosedReason,
      //     mycontroller[1].text, isSelectedFollowUp);
    }
    notifyListeners();
  }

  validatebtnChanged() {
    if (caseStatusSelected == "Open") {
      if (leadOpenSaveClicked == true) {
        hinttextforOpenLead = "Select Status: *";
        feedbackLead = 'Give your feedback *';
        nextFollowupDate = 'Next Follow up: *';
        followup = 'How you made the follow up? *';
        nextVisitTime = 'Followup Time: *';
      } else {
        hinttextforOpenLead = "Select Status:";
        feedbackLead = 'Give your feedback*';
        nextFollowupDate = 'Next Follow up:*';
        followup = 'How you made the follow up?*';
        nextVisitTime = 'Followup Time:*';
      }
    } else {}

    if (caseStatusSelected == "Won") {
      if (leadWonSaveClicked == true) {
        hinttextforWonLead = "Select Status: *";
        orderBillRefer = 'Order/Bill Reference *';
        feedbackLead = 'Give your feedback *';
        followup = 'How you made the follow up? *';
      } else {
        hinttextforWonLead = "Select Status:*";
        orderBillRefer = 'Order/Bill Reference*';
        feedbackLead = 'Give your feedback*';
        nextFollowupDate = 'Next Follow up:*';
        followup = 'How you made the follow up?*';
      }
      nextFD = '';
      nextWonFD = '';
    } else {}

    if (caseStatusSelected == "Lost") {
      if (leadLostSaveClicked == true) {
        feedbackLead = 'Give your feedback *';
        hinttextforLostLead = 'Select Reason: *';
        followup = 'How you made the follow up? *';
      } else {
        feedbackLead = 'Give your feedback*';
        hinttextforLostLead = 'Select Reason:*';
        followup = 'How you made the follow up?*';
      }
      nextFD = '';
      nextWonFD = '';
    } else {}
    notifyListeners();
  }

  caseStatusSelectBtn(String val, String code) {
    caseStatusSelected = val;
    caseStatusSelectedcode = code;

    notifyListeners();
  }

  List<UserListData> userLtData = [];
  List<UserListData> get getuserLtData => userLtData;
  filterListAssignData(String v) {
    for (int i = 0; i < filteruserLtData.length; i++) {
      filteruserLtData[i].color = 0;
    }
    if (v.isNotEmpty) {
      filteruserLtData = userLtData
          .where((e) => e.UserName!.toLowerCase().contains(v.toLowerCase())
              // ||
              // e.s!.toLowerCase().contains(v.toLowerCase())
              )
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      filteruserLtData = userLtData;
      notifyListeners();
    }
  }

  getLeadStatus() async {
    leadStatusOpen.clear();
    leadStatusWon.clear();
    leadStatusLost.clear();
    final Database db = (await DBHelper.getInstance())!;
    leadStatusOpen = await DBOperation.getLeadStatusOpen(db);
    leadStatusLost = await DBOperation.getLeadStatusLost(db);
    // log("leadStatusOpen:" + leadStatusOpen[0].name.toString());
    leadStatusWon = await DBOperation.getLeadStatusWon(db);
    userLtData = await DBOperation.getUserList(db);
    filteruserLtData = userLtData;
    setForwardDataList();
    notifyListeners();
  }

  setForwardDataList() {
    List<UserListData> filteruserLtData2 = [];
// print("List Length"+filteruserLtData.length.toString());
    for (int i = 0; i < filteruserLtData.length; i++) {
      // print("User slp::${ConstantValues.slpcode}--${filteruserLtData[i].slpcode}");
      if (filteruserLtData[i].slpcode != Utils.slpcode) {
        filteruserLtData2.add(UserListData(
            userCode: filteruserLtData[i].userCode,
            storeid: filteruserLtData[i].storeid,
            mngSlpcode: filteruserLtData[i].mngSlpcode,
            UserName: filteruserLtData[i].UserName,
            color: filteruserLtData[i].color,
            slpcode: filteruserLtData[i].slpcode,
            SalesEmpID: filteruserLtData[i].SalesEmpID));
      }
    }

    if (filteruserLtData2.isNotEmpty) {
      filteruserLtData = [];
      filteruserLtData = filteruserLtData2;
    }
    notifyListeners();
  }

  // againChangeAskDialogbox(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       final theme = Theme.of(context);
  //       return AlertDialog(
  //           insetPadding: const EdgeInsets.all(10),
  //           contentPadding: const EdgeInsets.all(0),
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

  //           // title: Text("hi"),
  //           content: AskAgainAlertBox());
  //     },
  //   ).then((value) {
  //     // context.read<DashboardController>().refershAfterClosedialog();
  //   });
  // }

  // outStanding

  double? totaloutstanding = 0.0;
  double? overdue = 0.0;
  double? upcoming = 0.0;
  //

  List<outstandingDBModel> valueDBmodel = [];
  List<outstandinglineDBModel> valueDBmodelchild = [];
  List<outstandKPI> outstandingkpi = [];
  List<outstandingData> outstanddata = [];
  List<outstandingLine> outstandline = [];
  List<ontapKpi> ontapKpi2 = [];

  bool apiOutloading = false;
  String errorOutstdmsg = '';
  getAllOutstandingscall() async {
    outstanddata.clear();
    outstandline.clear();
    apiOutloading = true;
    // outsatandingmodel outsatandingModel = await GetoutstandingApi.getData();
    String meth = ConstantApiUrl.outStandingApi!;
    await GetOutstandingApi.getData(meth).then((value) async {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.outstandhead!.outstanddata != null &&
            value.outstandhead!.outstanddata!.isNotEmpty &&
            value.outstandhead!.outstandline != null &&
            value.outstandhead!.outstandline!.isNotEmpty) {
          apiOutloading = false;
          notifyListeners();
          outstanddata = value.outstandhead!.outstanddata!;
          outstandline = value.outstandhead!.outstandline!;
          await tableinsert();
        } else {
          apiOutloading = false;
          errorOutstdmsg = 'No Outstanding..!!';
          notifyListeners();
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        apiOutloading = false;
        errorOutstdmsg = '${value.message}..${value.exception}..!!';
        notifyListeners();
      } else if (value.stcode! == 500) {
        apiOutloading = false;
        errorOutstdmsg = '${value.exception}..${value.message}..!!';

        notifyListeners();
      }
    });
  }

  tableinsert() async {
    final Database db = (await DBHelper.getInstance())!;
    // await DBOperation.truncareoutstandingmaste(db);
    // await DBOperation.truncareoutstandingline(db);
    await DBOperation.insertOutstandingMaster(outstanddata, db);
    await DBOperation.insertOutstandingchild(outstandline, db);

    notifyListeners();
    await getdbmodel();
    notifyListeners();
  }

  clearontap() {
    ontapKpi2.clear();
    totaloutstanding = 0.0;
    overdue = 0.0;
    upcoming = 0.0;
    outstandingkpi.clear();
    notifyListeners();
  }

  ontapkpicall(String cuscode) async {
    ontapKpi2.clear();
    totaloutstanding = 0.0;
    overdue = 0.0;
    upcoming = 0.0;
    final Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> result2 =
        await DBOperation.getoutontapKPI(db, cuscode);
    if (result2.isNotEmpty) {
      ontapKpi2.add(ontapKpi(
          totaloutstanding:
              double.parse(result2[0]['totaloutstanding'].toString()),
          overdue: double.parse(result2[0]['overdue'].toString()),
          upcoming: double.parse(result2[0]['upcoming'].toString()),
          Bil_City: result2[0]['Bil_City'].toString(),
          Bil_State: result2[0]['Bil_State'].toString(),
          CustomerName: result2[0]['CustomerName'].toString(),
          CustomerCode: result2[0]['CustomerCode'].toString()));

      totaloutstanding =
          double.parse(ontapKpi2[0].totaloutstanding!.toStringAsFixed(2));
      overdue = double.parse(ontapKpi2[0].overdue!.toStringAsFixed(2));
      upcoming = double.parse(ontapKpi2[0].upcoming!.toStringAsFixed(2));
      //  outstandKPI(
    }
  }

  onDoubletap(String? cusCode) async {
    valueDBmodelchild.clear();
    final Database db = (await DBHelper.getInstance())!;
    outstandingkpi = await DBOperation.getoutstandingchildInvoice(db, cusCode);
    notifyListeners();
  }

  countofKpi() async {
    final Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> result2 =
        await DBOperation.getoutstandingKPI(db);
    if (result2.isNotEmpty) {
      //  outstandKPI(
      totaloutstanding = result2[0]['totaloutstanding'] == null
          ? 0.0
          : double.parse(result2[0]['totaloutstanding'].toString());
      overdue = double.parse(result2[0]['overdue'].toString());
      upcoming = double.parse(result2[0]['upcoming'].toString());
      // );
    } else {
      //  outstandKPI(
      totaloutstanding = 0.0;
      overdue = 0.0;
      upcoming = 0.0;
      // );
    }
    notifyListeners();
  }

  getdbmodel() async {
    apiOutloading = true;
    notifyListeners();
    final Database db = (await DBHelper.getInstance())!;
    valueDBmodel = await DBOperation.getoutstandingMaster(db);
    valueDBmodelchild = await DBOperation.getoutstandingchild(db);
    await countofKpi();
    log("valueDBmodel.${valueDBmodel.length}");
    log("valueDBmodelchild::${valueDBmodelchild.length}");
    List<Map<String, Object?>> assignDB =
        await DBOperation.getOutLFtr("AssignedTo", db);

    List<Map<String, Object?>> customerDB =
        await DBOperation.getOutLFtr("CustomerName", db);
    notifyListeners();
    await dataget(assignDB, customerDB);
    notifyListeners();
    apiOutloading = false;
    notifyListeners();
  }

  List<Distcolumn> assigncolumn = [];
  List<cuscolumn2> customercolumn = [];

  Future<void> dataget(List<Map<String, Object?>> assignDB, customerDB) async {
    assigncolumn.clear();
    customercolumn.clear();
    notifyListeners();
    for (int i = 0; i < assignDB.length; i++) {
      assigncolumn.add(Distcolumn(name: assignDB[i]['AssignedTo'].toString()));
      log("assigncolumn::${assigncolumn.length}");
      notifyListeners();
    }
    for (int i = 0; i < customerDB.length; i++) {
      customercolumn
          .add(cuscolumn2(name: customerDB[i]['CustomerName'].toString()));
      log("customercolumn::${customercolumn[i].name}");
      notifyListeners();
    }
  }

  setOutstandingDetails(String mobile) async {
    clearontap();
    await ontapkpicall(mobile);
    await onDoubletap(mobile);
  }
}

class Callloginfo {
  String? name;
  String? number;
  String? duration;
  Callloginfo({
    this.name,
    required this.number,
    required this.duration,
  });
}

class Contact {
  String? firstName;
  String? lastName;
  List<dynamic>? phoneNumbers;

  Contact(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumbers});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumbers: List<dynamic>.from(json['phoneNumbers'] ?? ''),
    );
  }
}

class ontapKpi {
  double? totaloutstanding;
  double? overdue;
  double? upcoming;
  String? Bil_City;
  String? Bil_State;
  String? CustomerName;
  String? CustomerCode;
  ontapKpi(
      {required this.totaloutstanding,
      required this.overdue,
      required this.upcoming,
      required this.Bil_City,
      required this.Bil_State,
      required this.CustomerName,
      required this.CustomerCode});
}

class outstandKPI {
  String? TransNum;
  String? TransDate;
  String? TransRef1;
  double? age;
  double? BalanceToPay;
  double? TransAmount;
  int? docentry;

  outstandKPI(
      {this.docentry,
      required this.TransNum,
      required this.TransDate,
      required this.TransRef1,
      required this.age,
      required this.BalanceToPay,
      required this.TransAmount});
}

class Distcolumn {
  String name;
  Distcolumn({
    required this.name,
  });
}

class cuscolumn2 {
  String name;
  cuscolumn2({
    required this.name,
  });
}
