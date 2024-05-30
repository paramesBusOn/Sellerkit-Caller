// ignore_for_file: unnecessary_new, prefer_interpolation_to_compose_strings, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/encripted.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/utils.dart';
import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
import 'package:sellerkitcalllog/src/api/enqTypeApi/enqTypeApi.dart';
import 'package:sellerkitcalllog/src/api/getRefferalApi/getRefferalApi.dart';
import 'package:sellerkitcalllog/src/api/levelOfApi/levelOfApi.dart';
import 'package:sellerkitcalllog/src/api/ordertypeApi/ordertypeApi.dart';
import 'package:sellerkitcalllog/src/api/stateApi/stateApi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../DBHelper/DBHelper.dart';
import '../../DBHelper/DBOperation.dart';
import '../../api/getAllCustomerApi/getAllCustomerApi.dart';
import '../../api/getUserListApi/getUserListApi.dart';
import '../../api/leadUpdateFollowiupApi/getLeadStatusApi.dart';

class DownLoadController extends ChangeNotifier {
  String errorMsg = 'Some thing went wrong';
  bool exception = false;
  bool get getException => exception;
  String get getErrorMsg => errorMsg;
  Config config = new Config();

  // Future<void> createDB() async {
  //   await DBOperation.createDB().then((value) {
  //     print("Value created....!!");
  //   });
  // }

  setURL() async {
    String? getUrl = await HelperFunctions.getHostDSP();
    log("getUrl $getUrl");
    Utils.userNamePM = await HelperFunctions.getUserName();
    Utils.queryApi = 'http://${getUrl.toString()}/api/';
  }

  // TestNew testnew=TestNew();

  callApiNew(BuildContext context) async {
    // await VersionApi.getData().then((value) async {
    //   // log("123456:");

    //   if (value.stcode! >= 200 && value.stcode! <= 210) {
    //     if (value.itemdata != null) {
    //       toLaunch = value.itemdata![0].url;
    //       content = value.itemdata![0].content;
    //       if (value.itemdata![0].version == Utils.defaultversion.toString()) {
    callDefaultApi();
    //       } else {
    //         updateDialog(context);
    //       }
    //       notifyListeners();
    //     } else if (value.itemdata! == null) {
    //       exception = true;
    //       errorMsg = "${value.exception}..!! ";
    //       notifyListeners();
    //     }
    //     notifyListeners();
    //   } else if (value.stcode! >= 400 && value.stcode! <= 410) {
    //     exception = true;
    //     errorMsg = "${value.exception}..${value.message}..!! ";
    //     notifyListeners();
    //   } else if (value.stcode! == 500) {
    //     exception = true;
    //     errorMsg = "${value.stcode!}..!!Network Issue..\nTry again Later..!!";
    //     notifyListeners();
    //     notifyListeners();
    //   }
    // });
  }

  String? loadingApi = '';

  callDefaultApi() async {
    CustomerTagApi customerTagTypeApi = CustomerTagApi();
    List<CustomerTagTypeData2> customerTagTypeData = [];
    //
    EnqRefferesApi enquiryRefferesApi = EnqRefferesApi();
    List<EnqRefferesData> enqReffdata = [];
    //
    EnquiryTypeApi enquiryTypeApi = EnquiryTypeApi();
    List<EnquiryTypeData> enqTypeData = [];
    //
    StateDetailsApi stateDetailsApi = StateDetailsApi();
    List<StateHeaderData> stateData = [];
    //
    List<UserListData> userListData = [];
    UserListGetApi getUserApi = UserListGetApi();
    //
    LevelOfApi levelOfApi = LevelOfApi();
    List<LevelofData> levelofdata = [];
    //

    List<OrderTypeData> ordertypedata = [];
    OrderTypeApi orderTypeApi = OrderTypeApi();
    //
    GetLeadStatusApi getLeadStatusApi = GetLeadStatusApi();
    List<GetLeadStatusData> leadcheckdata = [];
    //
    CustomerDetails getAllCustomerApi = CustomerDetails();
    List<CustomerData> allcustomerData = [];
    //
    final Database db = (await DBHelper.getInstance())!;
    // DataBaseConfig.ip = (await HelperFunctions.gethostIP())!;
    // Map<Permission, PermissionStatus> statuses = await [
    //  await checkLocation();
    EncryptData enc = new EncryptData();
    if (Utils.langtitude!.isEmpty || Utils.langtitude == '') {
      Utils.langtitude = '0.000';
    }
    if (Utils.latitude!.isEmpty || Utils.latitude == '') {
      Utils.latitude = '0.000';
    }
    Utils.headerSetup =
        "${Utils.latitude};${Utils.langtitude};${Utils.ipname};${Utils.ipaddress}";

    String? encryValue = enc.encryptAES("${Utils.headerSetup}");
    // log("Encryped Location Header:::" + encryValue.toString());
    Utils.encryptedSetup = encryValue;
    notifyListeners();
    Future.delayed(Duration(seconds: 3));

    Utils.userId = (await HelperFunctions.getdbUserName())!;
    await DBOperation.truncareEnqType(db); //

    await DBOperation.truncarelevelofType(db); //
    await DBOperation.truncareorderType(db);

    await DBOperation.truncareCusTagType(db); //
    await DBOperation.trunstateMaster(db); //
    await DBOperation.truncareEnqReffers(db); //
    await DBOperation.truncateUserList(db); //
    await DBOperation.truncateLeadstatus(db);
    await DBOperation.truncateOfferZone(db);
    await DBOperation.truncateOfferZonechild1(db);
    await DBOperation.truncateOfferZonechild2(db);
    await DBOperation.truncateCustomerList(db);

    String meth = ConstantApiUrl.getCustomtagApi!;
    await customerTagTypeApi.getData(meth).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        customerTagTypeData = value.itemdata!;
      } else {
        exception = true;
        errorMsg = 'No data - Customer Tag Api..!!';
      }
      notifyListeners();
    });
    String meth1 = ConstantApiUrl.getEnqreffre!;

    await enquiryRefferesApi.getData(meth1).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        exception = false;
        if (value.enqReffersdata != null) {
          final stopwatch = Stopwatch()..start();
          log("Start:enqReffersdata ");
          String date = config.currentDate();

          enqReffdata = value.enqReffersdata!;
          stopwatch.stop();
          log('API enqReffersdata ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.enqReffersdata == null) {
          exception = true;
          errorMsg = 'No data - Enquiry Ref Api..!!';
          notifyListeners();
        }
        notifyListeners();
      } else {
        if (value.stcode! >= 400 && value.stcode! <= 410) {
          exception = true;
          errorMsg = '${value.exception}';
          notifyListeners();
        } else {
          exception = true;
          errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
          notifyListeners();
        }
      }
    });

    String meth2 = ConstantApiUrl.getEnqtype!;
    await enquiryTypeApi.getData(meth).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        exception = false;
        if (value.itemdata != null) {
          final stopwatch = Stopwatch()..start();
          String date = config.currentDate();
          enqTypeData = value.itemdata!;
          stopwatch.stop();
          log('API EnquiryType ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.itemdata == null) {
          exception = true;
          errorMsg = 'No data - Enquiry Type Api..!!';
          notifyListeners();
        }
        notifyListeners();
      } else {
        if (value.stcode! >= 400 && value.stcode! <= 410) {
          exception = true;
          errorMsg = '${value.exception}';
          notifyListeners();
        } else {
          exception = true;
          errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
          notifyListeners();
        }
      }
    });

    String meth3 = ConstantApiUrl.getstate!;
    await stateDetailsApi.getData(meth3).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.itemdata != null) {
          exception = false;
          final stopwatch = Stopwatch()..start();
          for (int i = 0; i <= value.itemdata!.datadetail!.length; i++) {
            stateData = value.itemdata!.datadetail!;

            notifyListeners();
          }
          stopwatch.stop();
          log('API stateData ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.itemdata == null) {
          exception = true;
          errorMsg = 'No data - State Api..!!';
          notifyListeners();
        }
      } else {
        if (value.stcode! >= 400 && value.stcode! <= 410) {
          exception = true;
          errorMsg =
              '${value.message}..! \n${value.exception}..!!${value.stcode}';

          notifyListeners();
        } else {
          exception = true;
          errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';

          notifyListeners();
        }
      }
    });

    String meth4 = ConstantApiUrl.levelOfApi!;
    await levelOfApi.getData(meth4).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        exception = false;
        if (value.itemdata != null) {
          final stopwatch = Stopwatch()..start();
          log("Start:LevelofApi ");
          String date = config.currentDate();
          // for (int i = 0; i < values.itemdata!.length; i++) {
          //     enqTypeData.add(EnquiryTypeData(
          //       Code: values.itemdata![i].Code,
          //       Name:  values.itemdata![i].Name));
          // }
          levelofdata = value.itemdata!;
          stopwatch.stop();
          log('API LevelofApi ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.itemdata == null) {
          exception = true;
          errorMsg = 'No data - Customer Tag Api..!!';
          notifyListeners();
        }
        notifyListeners();
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        exception = true;
        errorMsg = '${value.exception}';
        notifyListeners();
      } else if (value.stcode == 500) {
        exception = true;
        errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
        notifyListeners();
      }
    });
    loadingApi = "customerTagType";

    loadingApi = "userListData";

    String meth5 = ConstantApiUrl.getUserListApi(Utils.userId)!;
    await getUserApi.getData(meth5).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        exception = false;
        if (value.userLtData != null) {
          final stopwatch = Stopwatch()..start();
          log("Start:userListData ");
          // log("userListModal.userLtData!.length::" +
          //     userListModal.userLtData!.length.toString());
          for (int ik = 0; ik < value.userLtData!.length; ik++) {
            // if(userListModal.userLtData![ik].storeid ==ConstantValues.storeid ){
            // for(int i=0;i<userListModal.userLtData!.length;i++){
            userListData.add(UserListData(
                userCode: value.userLtData![ik].userCode,
                storeid: value.userLtData![ik].storeid,
                mngSlpcode: value.userLtData![ik].mngSlpcode,
                UserName: value.userLtData![ik].UserName,
                color: value.userLtData![ik].color,
                slpcode: value.userLtData![ik].slpcode,
                SalesEmpID: value.userLtData![ik].SalesEmpID));

            notifyListeners();
          }
          stopwatch.stop();
          log('API userListData ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.userLtData == null) {
          exception = true;
          errorMsg = 'No data - User Api..!!';
          notifyListeners();
        }
        notifyListeners();
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        exception = true;
        errorMsg = '${value.exception}';
        notifyListeners();
      } else if (value.stcode == 500) {
        exception = true;
        errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
        notifyListeners();
      }
    });
    String meth6 = ConstantApiUrl.getOrderTypeApi!;
    await orderTypeApi.getData(meth6).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        exception = false;
        if (value.itemdata != null) {
          final stopwatch = Stopwatch()..start();
          log("Start:OrderTypeApi ");
          String date = config.currentDate();

          ordertypedata = value.itemdata!;
          stopwatch.stop();
          log('API OrderTypeApi ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.itemdata == null) {
          exception = true;
          errorMsg = 'No data - Customer Tag Api..!!';
          notifyListeners();
        }
        notifyListeners();
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        exception = true;
        errorMsg = '${value.exception}';
        notifyListeners();
      } else if (value.stcode == 500) {
        exception = true;
        errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
        notifyListeners();
      }
    });

    loadingApi = "LeadStatusData";
    String meth7 = ConstantApiUrl.getLeadStatusApi!;
    await getLeadStatusApi.getData(meth7).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        ("statusINININ");
        exception = false;
        if (value.leadcheckdata != null) {
          final stopwatch = Stopwatch()..start();
          log("Start:LeadStatusData ");
          for (int i = 0; i < value.leadcheckdata!.length; i++) {
            if (value.leadcheckdata![i].status == 1) {
              leadcheckdata.add(GetLeadStatusData(
                code: value.leadcheckdata![i].code,
                name: value.leadcheckdata![i].name!,
                statusType: value.leadcheckdata![i].statusType,
              ));
            }
          }
          stopwatch.stop();
        } else if (value.leadcheckdata == null) {
          exception = true;
          errorMsg = 'No data - LeadStatus Api..!!';
          notifyListeners();
        }
        notifyListeners();
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        exception = true;
        errorMsg = '${value.exception}';
        notifyListeners();
      } else if (value.stcode == 500) {
        exception = true;
        errorMsg = '${value.stcode!}..!!Network Issue..\nTry again Later..!!';
        notifyListeners();
      }
    });

    String meth8 = ConstantApiUrl.getAllCustomerApi!;
    await getAllCustomerApi.getData(meth8).then((value) {
    if (value.stcode! >= 200 && value.stcode! <= 210) {
      ("statusINININ");
      allcustomerData=value.itemdata!;
      exception = false;
    }
   });

    print(
        "${userListData.length}-${levelofdata.length}-${ordertypedata.length}-${stateData.length}-${enqTypeData.length}-${customerTagTypeData.length}-${enqReffdata.length}");
    await DBOperation.inserstateMaster(stateData, db);
    await DBOperation.insertEnqType(enqTypeData, db);
    await DBOperation.insertCusTagType(customerTagTypeData, db);
    await DBOperation.insertEnqReffers(enqReffdata, db);
    await DBOperation.insertlevelofType(levelofdata, db);
    await DBOperation.insertUserList(userListData, db);
    await DBOperation.insertOrderTypeta(ordertypedata, db);
    await DBOperation.insertLeadStatusList(leadcheckdata, db);
    await DBOperation.insertAllCustomer(allcustomerData, db);
    final stopwatch = Stopwatch()..start();

    await HelperFunctions.saveDonloadednSharedPreference(true);
    Get.offAllNamed(ConstantRoutes.dashboard);
  }

  String? content;
  Future<void> updateDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return WillPopScope(
              onWillPop: dialogBackBun,
              child: AlertDialog(
                //content:
                title: Text(
                  "Upgrade Information",
                ),
                content: Container(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                      "This app is currently not supported.Please upgrade to enjoy our service.")
                ])),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        //  Navigator.of(context).pop();
                        // Navigator.of(context).pop(true);
                        exit(0);
                      },
                      child: Text(
                        "No",
                      ),
                      style: TextButton.styleFrom(foregroundColor: Colors.red)),
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          _launchInBrowser(toLaunch!);
                        });
                      },
                      child: Text(
                        "Yes",
                      ))
                ],
              ),
            );
          });
        });
  }

  String? toLaunch;
  //"https://drive.google.com/file/d/15zlBCFGgrZLuklr4dlGloltjCPryxEUv/view?usp=sharing";
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> dialogBackBun() {
    //if is not work check material app is on the code
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    // print("objectqqqqq");
    return Future.value(false);
  }

  Future<int> getDefaultValues() async {
    int i = 0;
    // await HelperFunctions.getSapURLSharedPreference().then((value) {
    //   if (value != null) {
    //     Utils.SLUrl = value;
    //     // print("url: ${ Url.SLUrl}");
    //   }
    //   i = i + 1;
    // });
    await HelperFunctions.getSlpCode().then((value) {
      if (value != null) {
        Utils.slpcode = value;
        log("Utils.slpcode : ${Utils.slpcode}");
      }
      i = i + 1;
    });
    await HelperFunctions.getTenetIDSharedPreference().then((value) {
      if (value != null) {
        Utils.tenetID = value;
        //   print("url: ${Utils.sapSessions}");
      }
      i = i + 1;
    });

    return i;
  }
}
