//
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:call_log/call_log.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/GetCallLog_NativeCode.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/nativeCode-java-swift/methodchannel.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/api/dynamicLinkApi/dynamiclinkCreateSelf.dart';
import 'package:sellerkitcalllog/src/api/getCustomerApi/getCustomerApi.dart';
import 'package:sellerkitcalllog/src/api/selfNotificationApi/selfNotificationApi.dart';
import 'package:sellerkitcalllog/src/controller/dashboardController/dashboardController.dart';
import 'package:sellerkitcalllog/src/pages/dasboard/screens/dashboardPage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/CallNotificationController/CallNotificationController.dart';
import '../../dBHelper/dBHelper.dart';
import '../../dBHelper/dBOperation.dart';
import '../../dBModel/outstandingDBmodel.dart';
import '../../dBModel/outstandinglinechild.dart';

class CustomOverlayNew extends StatefulWidget {
  const CustomOverlayNew({super.key});

  @override
  State<CustomOverlayNew> createState() => CustomOverlayNewState();
}

class CustomOverlayNewState extends State<CustomOverlayNew>
    with WidgetsBindingObserver {
  static const String _mainAppPort = 'MainApp';
  SendPort? mainAppPort;
  bool update = false;
  GetCallerData? callerList;
  static String token = '';
  static String getUrl = '';
  List<outstandingDBModel> valueDBmodel = [];
  List<outstandinglineDBModel> valueDBmodelchild = [];
  @override
  void initState() {
    super.initState();
    // setState(() {
    WidgetsBinding.instance.addObserver(this);
    // });

    SystemAlertWindow.overlayListener.listen((event) async {
      log("$event in overlay");
      await calllog();
      if (event is bool) {
        setState(() {
          update = event;
        });
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    //don't forget to dispose of it when not needed anymore
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void callBackFunction(String tag) {
    mainAppPort ??= IsolateNameServer.lookupPortByName(
      _mainAppPort,
    );
    mainAppPort?.send('Date: ${DateTime.now()}');
    mainAppPort?.send(tag);
  }
  // callBackFunction("Close");
  // callBackFunction("Action");

  List<Callloginfo> callsInfo = [];
  bool addenqVisible = false;
  static bool callented = false;
  List<GetenquiryData>? customerDatalist = [];

  calllog() async {
    await getdbmodel();
    callsInfo = [];
    customerDatalist = [];
    // if (callented == false) return;
    String mobileno = '';
    // String? getToken = await HelperFunctions.getTokenSharedPreference();
    // Utils.token = getToken;

    // getPermissionUser();
    if (token.isEmpty) {
      if (Platform.isAndroid) {
        Iterable<CallLogEntry> entries = await CallLog.get();
        setState(() {
          for (var item in entries) {
            // if (item.callType.toString().contains('incoming')) {
            callsInfo.add(Callloginfo(
                name: item.callType.toString(),
                number: item.number,
                duration: item.name.toString()));
            break;
            // log(item.callType.toString()+item.number.toString());
            // }
          }
          mobileno = callsInfo[0].number!.replaceAll('+91', '');
        });

        String? getUrl = await HelperFunctions.getHostDSP();
        Utils.queryApi = 'http://${getUrl.toString()}/api/';
        String meth = '${ConstantApiUrl.getCustomerApi}';
        GetCutomerpost reqpost = GetCutomerpost(customermobile: mobileno);
        await GetCustomerDetailsApi.getData(meth, reqpost).then((value) {
          if (value.stcode! <= 210 && value.stcode! >= 200) {
            setState(() {
              GetCustomerDetailsApitwo? itemdata;
              itemdata = value.itemdata;
              customerDatalist = [];
              // List<EnqOrderList>? enqOrderlist = [];
              if (itemdata!.enquirydetails != null) {
                for (int i = 0; i < itemdata.enquirydetails!.length; i++) {
                  if ((itemdata.enquirydetails![i].DocType == 'Order' ||
                          itemdata.enquirydetails![i].DocType ==
                              'Outstanding' ||
                          itemdata.enquirydetails![i].DocType == 'Lead') &&
                      value.itemdata!.enquirydetails![i].Status!
                          .contains('Open')) {
                    customerDatalist!.add(GetenquiryData(
                        DocType: itemdata.enquirydetails![i].DocType,
                        AssignedTo: itemdata.enquirydetails![i].AssignedTo,
                        BusinessValue:
                            itemdata.enquirydetails![i].BusinessValue,
                        CurrentStatus:
                            itemdata.enquirydetails![i].CurrentStatus,
                        DocDate: itemdata.enquirydetails![i].DocDate,
                        DocNum: itemdata.enquirydetails![i].DocNum,
                        Status: itemdata.enquirydetails![i].Status,
                        Store: itemdata.enquirydetails![i].Store));
                    // enqOrderlist.add(EnqOrderList(
                    //     doctype: itemdata.enquirydetails![i].DocType,
                    //     docnum: itemdata.enquirydetails![i].DocNum.toString(),
                    //     lastorder: itemdata.enquirydetails![i].DocDate,
                    //     product: '----',
                    //     assignto: itemdata.enquirydetails![i].AssignedTo));
                  }
                }
              }
              if (itemdata.customerdetails!.isNotEmpty) {
                callerList = GetCallerData(
                  name: itemdata.customerdetails![0].customerName,
                  mobile: itemdata.customerdetails![0].mobileNo,
                  tag: itemdata.customerdetails![0].customerGroup,
                  // datalist: enqOrderlist,
                );
              } else {
                setState(() {
                  callerList = GetCallerData(
                      name: 'Unknown Number', mobile: mobileno, tag: 'new');
                });
              }
            });
          } else {
            setState(() {
              callerList = GetCallerData(
                  name: 'Unknown Number', mobile: mobileno, tag: 'new');
            });
          }
        });
        callerList ??=
            GetCallerData(name: 'Unknown Number', mobile: mobileno, tag: 'new');
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
      }

      if (valueDBmodel.isNotEmpty) {
        for (int i = 0; i < valueDBmodel.length; i++) {
          if (valueDBmodel[i].customerCode == mobileno) {
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
    }
  }

  getdbmodel() async {
    valueDBmodel = [];
    final Database db = (await DBHelper.getInstance())!;
    valueDBmodel = await DBOperation.getoutstandingMaster(db);
  }

  bool _inforeground = true;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          _inforeground = true;
        });
        break;
      case AppLifecycleState.inactive:
        setState(() {
          _inforeground = true;
        });
        break;
      case AppLifecycleState.paused:
        setState(() {
          _inforeground = false;
        });
        break;

      default:
        setState(() {
          _inforeground = false;
        });
        break;
    }
  }

  Widget overlay(CallNotificationController callCon) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        callerList == null
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              )
            : callerList!.name!.contains('Unknown')
                ? Container(
                    color: theme.primaryColor,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: Screens.bodyheight(context) * 0.2,
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(100),
                                  color: theme.primaryColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${callerList!.name!.capitalize} ",
                                                style: theme
                                                    .textTheme.bodyLarge!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            Container(
                                              alignment: Alignment.topCenter,
                                              // padding: EdgeInsets.all(
                                              //     Screens.bodyheight(context) * 0.01),
                                              // height:
                                              //     Screens.bodyheight(context) * 0.07,
                                              // width: Screens.width(context) * 0.2,
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow[100],
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Text(
                                                '${callerList!.tag}',
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "+91 ${callerList!.mobile}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      padding: EdgeInsets.only(
                                          right: Screens.bodyheight(context) *
                                              0.08),
                                      onPressed: () {
                                        // callBackFunction("Close");
                                        SystemAlertWindow.closeSystemWindow(
                                            prefMode: prefMode);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size:
                                            Screens.bodyheight(context) * 0.06,
                                      ))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: Screens.bodyheight(context) * 0.1,
                                  width: Screens.width(context) * 0.4,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () async {
                                        Config config = Config();
                                        GetAppAvailabilityStatus
                                            .openAppInBackground(); //3

                                        //1  // String? fcmtoken =
                                        //     await config.getToken();

                                        //2 // DynamicLinkSelfCreateApi
                                        //         .getDynamicLinkCreateApiData(
                                        //             'Add enquiry')
                                        //     .then((value) async {
                                        //   if (value.dynamiclinkData != null &&
                                        //       value.dynamiclinkData!.shortlink!
                                        //           .isNotEmpty) {
                                        //     if (value.dynamiclinkData!
                                        //         .shortlink!.isNotEmpty) {
                                        //       if (!await launchUrl(
                                        //           Uri.parse(value
                                        //               .dynamiclinkData!
                                        //               .shortlink!),
                                        //           mode: LaunchMode
                                        //               .externalNonBrowserApplication)) {
                                        //         throw 'Could not launch ${value.dynamiclinkData!.shortlink!}';
                                        //       }
                                        //     }
                                        //   }
                                        // }).then((value) {});
                                        //1  // await LaunchApp.openApp(
                                        //   androidPackageName:
                                        //       'com.example.sellerkitcallerdashboard',
                                        //   iosUrlScheme: 'pulsesecure://',
                                        //   appStoreLink:
                                        //       'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                        //   // openStore: false
                                        // );
                                        //1 // SelfNotificationSendApi.getData(
                                        //         'Add Enquiry',
                                        //         fcmtoken!,
                                        //         'CallerApp',
                                        //         callerList!.mobile!)
                                        //     .then((value) async {
                                        //   if (value.sucesscode == 1) {
                                        //   } else {}
                                        // });
                                        //1 // SystemAlertWindow.closeSystemWindow(
                                        //     prefMode: prefMode);
                                      },
                                      child: Text(
                                        'Add Enquiry',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      )),
                                ),
                                SizedBox(
                                  height: Screens.bodyheight(context) * 0.1,
                                  width: Screens.width(context) * 0.4,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () async {
                                        Config config = Config();
                                        String? fcmtoken =
                                            await config.getToken();
                                        await LaunchApp.openApp(
                                          androidPackageName:
                                              'com.example.sellerkitcallerdashboard',
                                          iosUrlScheme: 'pulsesecure://',
                                          appStoreLink:
                                              'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                          // openStore: false
                                        ).then((value) {
                                          SelfNotificationSendApi.getData(
                                                  'Add Customer',
                                                  fcmtoken!,
                                                  'CallerApp',
                                                  callerList!.mobile!)
                                              .then((value) async {
                                            if (value.sucesscode == 1) {
                                            } else {}
                                          });
                                        });
                                        // if (_inforeground) {

                                        SystemAlertWindow.closeSystemWindow(
                                            prefMode: prefMode);
                                      },
                                      child: Text(
                                        'Add Customer',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: Screens.width(context),
                          height: Screens.bodyheight(context) * 0.8,
                          padding: EdgeInsets.all(
                              Screens.bodyheight(context) * 0.04),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          child: ListView(
                            children: const [],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    color: theme.primaryColor,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: callerList == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        // Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       InkWell(
                        //         onTap: () {
                        //           // calllog();

                        //           // SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
                        //         },
                        //         child: Icon(Icons.open_in_browser),
                        //       ),
                        //       SizedBox(
                        //         height: 20,
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           // calllog();

                        //           SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
                        //         },
                        //         child: const Center(child: Icon(Icons.close)),
                        //       ),
                        //     ],
                        //   )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: Screens.bodyheight(context) * 0.2,
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(100),
                                    color: theme.primaryColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  "${callerList!.name!.capitalize} ",
                                                  style: theme
                                                      .textTheme.bodyLarge!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              Container(
                                                alignment: Alignment.topCenter,
                                                // padding: EdgeInsets.all(
                                                //     Screens.bodyheight(context) * 0.01),
                                                // height:
                                                //     Screens.bodyheight(context) * 0.07,
                                                // width: Screens.width(context) * 0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Text(
                                                  '${callerList!.tag}',
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                            //  DynamicLinkSelfCreateApi
                                            //           .getDynamicLinkCreateApiData(
                                            //               'Add enquiry')
                                            //       .then((value) async {
                                            //     if (value.dynamiclinkData != null &&
                                            //         value.dynamiclinkData!.shortlink!
                                            //             .isNotEmpty) {
                                            //       if (value.dynamiclinkData!
                                            //           .shortlink!.isNotEmpty) {
                                            //         if (!await launchUrl(
                                            //             Uri.parse(value
                                            //                 .dynamiclinkData!
                                            //                 .shortlink!),
                                            //             mode: LaunchMode
                                            //                 .externalNonBrowserApplication)) {
                                            //           throw 'Could not launch ${value.dynamiclinkData!.shortlink!}';
                                            //         }
                                            //       }
                                            //     }
                                            //   }).then((value) {});
                                              // await LaunchApp.openApp(

                                              //   androidPackageName:
                                              //       'com.example.sellerkitcallerdashboard',
                                              //   iosUrlScheme: 'pulsesecure://',
                                              //   appStoreLink:
                                              //       'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                              //   openStore: false
                                              // );
                                              GetAppAvailabilityStatus
                                                  .openAppInBackground(); //3
                                            },
                                            child: Text(
                                              "+91 ${callerList!.mobile}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.only(
                                            right: Screens.bodyheight(context) *
                                                0.08),
                                        onPressed: () {
                                          // callBackFunction("Close");
                                          SystemAlertWindow.closeSystemWindow(
                                              prefMode: prefMode);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: Screens.bodyheight(context) *
                                              0.06,
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                height: Screens.bodyheight(context) * 0.95,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    color: Colors.grey[300]!),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    customerDatalist == null
                                        ? Container()
                                        : SizedBox(
                                            height:
                                                Screens.bodyheight(context) *
                                                    0.7,
                                            width:
                                                Screens.width(context) * 0.85,
                                            // color: Colors.grey[300]!,
                                            child: ListView.builder(
                                                itemCount:
                                                    customerDatalist!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var data =
                                                      customerDatalist![index];
                                                  return Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            Screens.width(
                                                                    context) *
                                                                0.01,
                                                        vertical: Screens
                                                                .padingHeight(
                                                                    context) *
                                                            0.002),
                                                    child: Container(
                                                      width: Screens.width(
                                                          context),
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              Screens.width(
                                                                      context) *
                                                                  0.02,
                                                          vertical: Screens
                                                                  .padingHeight(
                                                                      context) *
                                                              0.01),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black26)),
                                                      child: Column(children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Doc Number",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            Text(
                                                              "Doc Date",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${data.DocNum}",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: theme
                                                                          .primaryColor),
                                                            ),
                                                            Text(
                                                              data.DocDate!
                                                                      .isEmpty
                                                                  ? '-'
                                                                  : config.alignDate(
                                                                      data.DocDate
                                                                          .toString()),
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: theme
                                                                          .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: Screens
                                                                  .padingHeight(
                                                                      context) *
                                                              0.002,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Doc Type",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            Text(
                                                              "Status",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${data.DocType}",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: theme
                                                                          .primaryColor),
                                                            ),
                                                            Text(
                                                              "${data.Status}",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: theme
                                                                          .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: Screens
                                                                  .padingHeight(
                                                                      context) *
                                                              0.002,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Assigned To",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            Text(
                                                              "Business Value",
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              data.AssignedTo
                                                                  .toString(),
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: theme
                                                                          .primaryColor),
                                                            ),
                                                            Text(
                                                              config.slpitCurrency22(
                                                                  data.BusinessValue
                                                                      .toString()),
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: theme
                                                                          .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                    ),
                                                  );
                                                }),
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // SizedBox(
                                        //   height:
                                        //       Screens.bodyheight(context) * 0.1,
                                        //   width: Screens.width(context) * 0.4,
                                        //   child: ElevatedButton(
                                        //       style: ElevatedButton.styleFrom(
                                        //           backgroundColor:
                                        //               theme.primaryColor,
                                        //           // side: BorderSide(color: Colors.yellow, width: 5),
                                        //           shape: RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                       10))),
                                        //       onPressed: () async {
                                        //         Config config = Config();
                                        //         String? fcmtoken =
                                        //             await config.getToken();
                                        //         await LaunchApp.openApp(
                                        //           androidPackageName:
                                        //               'com.example.sellerkitcallerdashboard',
                                        //           iosUrlScheme:
                                        //               'pulsesecure://',
                                        //           appStoreLink:
                                        //               'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                        //           // openStore: false
                                        //         );
                                        //         // if (_inforeground) {
                                        //         SelfNotificationSendApi.getData(
                                        //                 'Add Enquiry',
                                        //                 fcmtoken!,
                                        //                 'CallerApp',
                                        //                 callerList!.mobile!)
                                        //             .then((value) async {
                                        //           if (value.sucesscode == 1) {
                                        //             print('sucess-afterApi');
                                        //           } else {
                                        //             print('failure');
                                        //           }
                                        //         });

                                        //         SystemAlertWindow
                                        //             .closeSystemWindow(
                                        //                 prefMode: prefMode);
                                        //       },
                                        //       child: Text(
                                        //         'Add Enquiry',
                                        //         style: theme
                                        //             .textTheme.bodySmall!
                                        //             .copyWith(
                                        //                 color: Colors.white),
                                        //       )),
                                        // ),
                                        SizedBox(
                                          height:
                                              Screens.bodyheight(context) * 0.1,
                                          width: Screens.width(context) * 0.8,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      theme.primaryColor,
                                                  // side: BorderSide(color: Colors.yellow, width: 5),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () async {
                                                Config config = Config();
                                                String? fcmtoken =
                                                    await config.getToken();
                                                setState(() {
                                                  // GetAppAvailabilityStatus
                                                  //     .isAppInstalled("com.example.sellerkitcallerdashboard");
                                                });
                                                // await Future.delayed(const Duration(seconds: 2));
                                                await LaunchApp.openApp(
                                                  androidPackageName:
                                                      'com.example.sellerkitcallerdashboard',
                                                  iosUrlScheme:
                                                      'pulsesecure://',
                                                  appStoreLink:
                                                      'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                                  // openStore: false
                                                );

                                                // if (_inforeground) {
                                                SelfNotificationSendApi.getData(
                                                        'Analyse',
                                                        fcmtoken!,
                                                        'CallerApp',
                                                        callerList!.mobile!)
                                                    .then((value) async {
                                                  setState(() {
                                                    DashboardPageState.test =
                                                        'asasd';
                                                  });

                                                  if (value.sucesscode == 1) {
                                                  } else {}
                                                });

                                                SystemAlertWindow
                                                    .closeSystemWindow(
                                                        prefMode: prefMode);
                                              },
                                              child: Text(
                                                'Analyse',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.white),
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
      ],
    );
  }

  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CallNotificationController>(
        create: (context) => CallNotificationController(),
        builder: (context, child) {
          return Consumer<CallNotificationController>(
              builder: (BuildContext context, callCon, Widget? child) {
            // callCon.init();
            return Scaffold(
              body: callCon.apiFdate == '' ? overlay(callCon) : Container(),
            );
          });
        });
  }

  List<Widget> listContainersCustomerTag(
      ThemeData theme, CallNotificationController callCont) {
    return List.generate(
      callCont.getCusTagList.length,
      (index) => InkWell(
        onTap: () {
          callCont.selectCsTag(callCont.getCusTagList[index].Code.toString());
        },
        child: Container(
          width: Screens.width(context) * 0.3,
          height: Screens.bodyheight(context) * 0.045,
          //  padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: callCont.getisSelectedCsTag ==
                      callCont.getCusTagList[index].Code.toString()
                  ? const Color(
                      0xffB299A5) //theme.primaryColor.withOpacity(0.5)
                  : Colors.white,
              border: Border.all(color: theme.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(callCont.getCusTagList[index].Name.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: callCont.getisSelectedCsTag ==
                            callCont.getCusTagList[index].Code.toString()
                        ? theme.primaryColor //,Colors.white
                        : theme.primaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class GetCallerData {
  String? name;
  String? mobile;
  String? tag;
  // List<EnqOrderList>? datalist = [];
  GetCallerData({
    this.name,
    this.mobile,
    this.tag,
    // this.datalist,
  });
}

// class EnqOrderList {
//   String? doctype;
//   String? lastorder;
//   String? docnum;
//   String? product;
//   String? assignto;
//   String? currentStatus;
//   String? status;
//   EnqOrderList({
//     this.doctype,
//     this.lastorder,
//     this.docnum,
//     this.product,
//     this.assignto,
//     this.currentStatus,
//     this.status,
//   });
// }
