import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/src/api/ItemCategoryApi.dart/ItemCategoryApi.dart';
import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
import 'package:sellerkitcalllog/src/api/getRefferalApi/getRefferalApi.dart';
import 'package:sellerkitcalllog/src/api/stateApi/stateApi.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBHelper.dart';
import 'package:sellerkitcalllog/src/dBHelper/dBOperation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


class CallNotificationController extends ChangeNotifier {
  CallNotificationController() {
    init();
  }
  init() async {
            String? ip = await HelperFunctions.getHostDSP();
            String? username = await HelperFunctions.getdbUserName();
            String? password = await HelperFunctions.getPasswordSharedPreference();
            String? tenentId = await HelperFunctions.getTenetIDSharedPreference();
      print("$ip+$username+$password+$tenentId");
        String? getToken = await HelperFunctions.getTokenSharedPreference();
    Utils.token = getToken;
  await HelperFunctions.getHostDSP().then((value) {
          log("getUrl $value");
        });
    // categoryValue = null;
    // enqReffeValue = null;
    // cusTagValue = null;
    // stateValue = null;
    // stateData = [];
    // filtercatagorydata = [];
    // cusTagList = [];
    // enqReffList = [];
    // catagorydata = [];
    // getCusTagType();
    // await getCatagoryApi();
    // getEnqRefferes();
    // getStatelist();
    notifyListeners();
  }

  final formkey = GlobalKey<FormState>();
  List<TextEditingController> mycontroller =
      List.generate(25, (i) => TextEditingController());
  List<StateHeaderData> stateData = [];
  List<StateHeaderData> filterstateData = [];
  bool statebool = false;
  getStatelist() async {
    stateData.clear();
    filterstateData.clear();

    final Database db = (await DBHelper.getInstance())!;
    stateData = await DBOperation.getstateData(db);
    filterstateData = stateData;
    log("getCustomerListFromDB length::" + filterstateData.length.toString());
    notifyListeners();
  }

  List<CustomerTagTypeData2> cusTagList = [];
  List<CustomerTagTypeData2> get getCusTagList => cusTagList;
  String isSelectedCsTag = '';
  String get getisSelectedCsTag => isSelectedCsTag;

  List<EnqRefferesData> enqReffList = [];
  List<EnqRefferesData> get getenqReffList => enqReffList;

  getCusTagType() async {
    final Database db = (await DBHelper.getInstance())!;
    cusTagList = await DBOperation.getCusTagData(db);
    notifyListeners();
  }

  getEnqRefferes() async {
    final Database db = (await DBHelper.getInstance())!;

    enqReffList = await DBOperation.getEnqRefferes(db);
    notifyListeners();
  }

  choosedType(String? val) {
    categoryValue = val;
    notifyListeners();
  }

  choosedRefferType(String? val) {
    enqReffeValue = val;
    notifyListeners();
  }

  choosedCustomerGroupType(String? val) {
    cusTagValue = val;
    notifyListeners();
  }

  choosedStateType(String? val) {
    stateValue = val;
    notifyListeners();
  }

  String? categoryValue;
  String? enqReffeValue;
  String? cusTagValue;
  String? stateValue;

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
    notifyListeners();
  }

  selectCsTag(String selected) {
    if (isSelectedCsTag == selected) {
      isSelectedCsTag = '';
    } else {
      isSelectedCsTag = selected;
    }
    notifyListeners();
  }

  String errorTime = '';
  String apiFdate = '';
  bool checkdata = false;
  int? reyear;
  int? remonth;
  int? reday;
  int? rehours;
  int? reminutes;
  String? apiNdate = '';
  getDate2(BuildContext context) async {
    errorTime = "";
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
//  firstDate: DateTime.now().subtract(Duration(days: 1)),
//   lastDate: DateTime(2100),
    if (pickedDate != null) {
      mycontroller[17].text = "";
      apiFdate = pickedDate.toString();
      var datetype = DateFormat('dd-MM-yyyy').format(pickedDate);

      if (mycontroller[14].text.isNotEmpty) {
        DateTime planPurDate;
        DateTime nextfdate;

        planPurDate = DateTime.parse(apiNdate!);
        nextfdate = DateTime.parse(pickedDate.toString());

        if (nextfdate.isAfter(planPurDate)) {
          mycontroller[16].text = '';
          checkdata = true;
          notifyListeners();
        } else {
          checkdata = false;
          mycontroller[16].text = datetype;
          reyear = pickedDate.year;
          remonth = pickedDate.month;
          reday = pickedDate.day;
          log("::" + reyear.toString());
          notifyListeners();
        }
      } else {
        mycontroller[16].text = datetype;
        reyear = pickedDate.year;
        remonth = pickedDate.month;
        reday = pickedDate.day;
        notifyListeners();
      }
    }
    notifyListeners();
  }
}
