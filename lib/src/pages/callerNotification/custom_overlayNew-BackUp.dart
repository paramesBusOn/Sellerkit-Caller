// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:call_log/call_log.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get/get_utils/src/extensions/string_extensions.dart';
// import 'package:provider/provider.dart';
// import 'package:sellerkitcalllog/helpers/GetCallLog_NativeCode.dart';
// import 'package:sellerkitcalllog/helpers/Utils.dart';
// import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
// import 'package:sellerkitcalllog/helpers/helper.dart';
// import 'package:sellerkitcalllog/helpers/screen.dart';
// import 'package:sellerkitcalllog/main.dart';
// import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
// import 'package:sellerkitcalllog/src/api/getCustomerApi/getCustomerApi.dart';
// import 'package:sellerkitcalllog/src/api/getRefferalApi/getRefferalApi.dart';
// import 'package:sellerkitcalllog/src/api/stateApi/stateApi.dart';
// import 'package:sellerkitcalllog/src/controller/dashboardController/dashboardController.dart';
// import 'package:sellerkitcalllog/src/models/postQueryModel/EnquiriesModel/CutomerTagModel.dart';
// import 'package:system_alert_window/system_alert_window.dart';

// import '../../controller/CallNotificationController/CallNotificationController.dart';

// class CustomOverlayNew extends StatefulWidget {
//   @override
//   State<CustomOverlayNew> createState() => _CustomOverlayNewState();
// }

// class _CustomOverlayNewState extends State<CustomOverlayNew> {
//   static const String _mainAppPort = 'MainApp';
//   SendPort? mainAppPort;
//   bool update = false;
//   GetCallerData? callerList;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       calllog();
//     });
//     SystemAlertWindow.overlayListener.listen((event) async {
//       log("$event in overlay");
//       if (event is bool) {
//         setState(() {
//           update = event;
//         });
//       }
//     });
//   }

//   void callBackFunction(String tag) {
//     print("Got tag " + tag);
//     mainAppPort ??= IsolateNameServer.lookupPortByName(
//       _mainAppPort,
//     );
//     mainAppPort?.send('Date: ${DateTime.now()}');
//     mainAppPort?.send(tag);
//     // MyAppState.receivemethod();
//     // isolatemethod();
//     // SystemAlertWindow.closeSystemWindow(
//     //                                       prefMode: prefMode);
//     //  final Uri toLaunch = Uri(
//     //         scheme: 'https',
//     //         host: 'sellerkitcallerdsahboard.page.link',
//     //         path: 'headers/');

//     // config.launchInBrowser(toLaunch);
//   }
//   // callBackFunction("Close");
//   // callBackFunction("Action");

//   List<Callloginfo> callsInfo = [];
//   bool addenqVisible = false;
//   static bool callented = false;

//   calllog() async {
//     callsInfo = [];
//     // if (callented == false) return;
//     String mobileno = '';
//     String? getToken = await HelperFunctions.getTokenSharedPreference();
//     // Utils.token = getToken;
//     // getPermissionUser();
//     if (Utils.token != null) {
//       if (Platform.isAndroid) {
//         Iterable<CallLogEntry> entries = await CallLog.get();
//         setState(() {
//           for (var item in entries) {
//             // if (item.callType.toString().contains('incoming')) {
//             callsInfo.add(Callloginfo(
//                 name: item.callType.toString(),
//                 number: item.number,
//                 duration: item.name.toString()));
//             break;
//             // log(item.callType.toString()+item.number.toString());
//             // }
//           }
//           mobileno = callsInfo[0].number!.replaceAll('+91', '');
//         });
//         String? getUrl = await HelperFunctions.getHostDSP();
//         log("getUrl $getUrl");
//         Utils.queryApi = 'http://${getUrl.toString()}/api/';
//         String meth = '${ConstantApiUrl.getCustomerApi}';
//         GetCutomerpost reqpost = GetCutomerpost(customermobile: mobileno);
//         await GetCustomerDetailsApi.getData(meth, reqpost).then((value) {
//           if (value.stcode! <= 210 && value.stcode! >= 200) {
//             setState(() {
//               GetCustomerDetailsApitwo? itemdata;
//               itemdata = value.itemdata;
//               List<EnqOrderList>? enqOrderlist = [];
//               if (itemdata!.enquirydetails != null) {
//                 for (int i = 0; i < itemdata.enquirydetails!.length; i++) {
//                   enqOrderlist.add(EnqOrderList(
//                       doctype: itemdata.enquirydetails![i].DocType,
//                       docnum: itemdata.enquirydetails![i].DocNum.toString(),
//                       lastorder: itemdata.enquirydetails![i].DocDate,
//                       product: '----',
//                       assignto: itemdata.enquirydetails![i].AssignedTo));
//                 }
//               }
//               if (itemdata.customerdetails!.isNotEmpty) {
//                 callerList = GetCallerData(
//                   name: itemdata.customerdetails![0].customerName,
//                   mobile: itemdata.customerdetails![0].mobileNo,
//                   tag: itemdata.customerdetails![0].customerGroup,
//                   datalist: enqOrderlist,
//                 );
//               } else {
//                 setState(() {
//                   callerList = GetCallerData(
//                       name: 'Unknown Number', mobile: mobileno, tag: 'new');
//                 });
//               }
//             });
//           } else {
//             setState(() {
//               callerList = GetCallerData(
//                   name: 'Unknown Number', mobile: mobileno, tag: 'new');
//             });
//           }
//         });
//       } else {
//         List<Object?> result = await CallLogService.getCallLog();
//         List<dynamic> listWithoutNulls =
//             result.where((element) => element != null).toList();
//         List<Contact> contacts = listWithoutNulls
//             .map((item) => Contact(
//                   firstName: item['firstName'],
//                   lastName: item['lastName'],
//                   phoneNumbers: List<String>.from(item['phoneNumbers']),
//                 ))
//             .toList();
//         for (int i = 0; i < contacts.length; i++) {
//           callsInfo.add(Callloginfo(
//               name: contacts[i].firstName.toString(),
//               number: contacts[i].phoneNumbers.toString(),
//               duration: ''));
//         }
//       }
//     }
//   }

//   Widget overlay(CallNotificationController callCon) {
//     final theme = Theme.of(context);
//     return Stack(
//       children: [
//         callerList == null
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               )
//             : callerList!.name!.contains('Unknown')
//                 ? Container(
//                     color: theme.primaryColor,
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           children: [
//                             Container(
//                               height: Screens.bodyheight(context) * 0.2,
//                               decoration: BoxDecoration(
//                                   // borderRadius: BorderRadius.circular(100),
//                                   color: theme.primaryColor),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                                 "${callerList!.name!.capitalize} ",
//                                                 style: theme
//                                                     .textTheme.bodyLarge!
//                                                     .copyWith(
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                             Container(
//                                               alignment: Alignment.topCenter,
//                                               // padding: EdgeInsets.all(
//                                               //     Screens.bodyheight(context) * 0.01),
//                                               // height:
//                                               //     Screens.bodyheight(context) * 0.07,
//                                               // width: Screens.width(context) * 0.2,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.yellow[100],
//                                                   borderRadius:
//                                                       BorderRadius.circular(4)),
//                                               child: Text(
//                                                 '${callerList!.tag}',
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         Text(
//                                           "+91 ${callerList!.mobile}",
//                                           style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   IconButton(
//                                       padding: EdgeInsets.only(
//                                           right: Screens.bodyheight(context) *
//                                               0.08),
//                                       onPressed: () {
//                                         // callBackFunction("Close");
//                                         SystemAlertWindow.closeSystemWindow(
//                                             prefMode: prefMode);
//                                       },
//                                       icon: Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size:
//                                             Screens.bodyheight(context) * 0.06,
//                                       ))
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 SizedBox(
//                                   height: Screens.bodyheight(context) * 0.1,
//                                   width: Screens.width(context) * 0.4,
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.white,
//                                           // side: BorderSide(color: Colors.yellow, width: 5),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       onPressed: () async {
//                                         // final Uri toLaunch = Uri(
//                                         //     scheme: 'https',
//                                         //     host:
//                                         //         'sellerkitcallerdsahboard.page.link',
//                                         //     path: 'headers/');
//                                         // config.launchInBrowser(toLaunch);
//                                         // Get.offAllNamed(
//                                         //     ConstantRoutes.callnotification);
//                                         // await LaunchApp.openApp(
//                                         //   androidPackageName:
//                                         //       'com.example.sellerkitcallerdashboard',
//                                         //   // openStore: false
//                                         // );

//                                         // DynamicLinkSelfCreateApi

//                                         //         .getDynamicLinkCreateApiData(
//                                         //             'Add enquiry')
//                                         //     .then((value) async {
//                                         //   if (value.dynamiclinkData != null &&
//                                         //       value.dynamiclinkData!.shortlink!
//                                         //           .isNotEmpty) {
//                                         //     if (value.dynamiclinkData!.shortlink!
//                                         //         .isNotEmpty) {
//                                         //       if (!await launchUrl(
//                                         //           Uri.parse(value.dynamiclinkData!
//                                         //               .shortlink!),
//                                         //           mode: LaunchMode
//                                         //               .externalNonBrowserApplication)) {
//                                         //         throw 'Could not launch ${value.dynamiclinkData!.shortlink!}';
//                                         //       }
//                                         //     }
//                                         //   }
//                                         // }).then((value) {

//                                         // });

//                                         // if (!await launchUrl(
//                                         //     Uri.parse("https"),
//                                         //     mode:
//                                         //         LaunchMode.externalApplication)) {
//                                         //   throw 'Could not launch ';
//                                         // }

//                                         // Get.offAllNamed(
//                                         // ConstantRoutes.callnotification);

//                                         // var alarmPlugin =
//                                         //     FlutterAlarmBackgroundTrigger();
//                                         // alarmPlugin.addAlarm(
//                                         //     // Required
//                                         //     DateTime.now()
//                                         //         .add(Duration(seconds: 1)),

//                                         //     //Optional
//                                         //     uid: "YOUR_APP_ID_TO_IDENTIFY",
//                                         //     payload: {
//                                         //       "YOUR_EXTRA_DATA": "FOR_ALARM"
//                                         //     },

//                                         // screenWakeDuration: For how much time you want
//                                         // to make screen awake when alarm triggered
//                                         // screenWakeDuration:
//                                         //     Duration(seconds: 2));
//                                         MyAppState;
//                                         MyAppState.callBackFunction(
//                                             "Add Enquiry");
//                                       },
//                                       child: Text(
//                                         'Add Enquiry',
//                                         style: theme.textTheme.bodySmall!
//                                             .copyWith(
//                                                 color: theme.primaryColor),
//                                       )),
//                                 ),
//                                 SizedBox(
//                                   height: Screens.bodyheight(context) * 0.1,
//                                   width: Screens.width(context) * 0.4,
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.white,
//                                           // side: BorderSide(color: Colors.yellow, width: 5),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       onPressed: () {},
//                                       child: Text(
//                                         'Add to Contact',
//                                         style: theme.textTheme.bodySmall!
//                                             .copyWith(
//                                                 color: theme.primaryColor),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Container(
//                           width: Screens.width(context),
//                           height: Screens.bodyheight(context) * 0.8,
//                           padding: EdgeInsets.all(
//                               Screens.bodyheight(context) * 0.04),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20)),
//                           ),
//                           child: ListView(
//                             children: [
//                               TextFormField(
//                                   // focusNode: context
//                                   //     .read<NewEnqController>()
//                                   //     .focusNode2,
//                                   // controller: context
//                                   //     .read<NewEnqController>()
//                                   //     .mycontroller[0],
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return "Enter Mobile Number";
//                                     } else if (value.length > 10 ||
//                                         value.length < 10) {
//                                       return "Enter a valid Mobile Number";
//                                     }
//                                     return null;
//                                   },
//                                   // onChanged: (v) {
//                                   //   if (v.length == 10 &&
//                                   //       context
//                                   //               .read<NewEnqController>()
//                                   //               .getcustomerapicalled ==
//                                   //           false) {
//                                   //     context
//                                   //         .read<NewEnqController>()
//                                   //         .callApi(context);
//                                   //   } else if (v.length != 10) {
//                                   //     context
//                                   //         .read<NewEnqController>()
//                                   //         .clearnum();
//                                   //   }
//                                   // },
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     new LengthLimitingTextInputFormatter(10),
//                                   ],
//                                   keyboardType: TextInputType.number,
//                                   decoration: const InputDecoration(
//                                     // hintText: 'aa',
//                                     labelText: 'Mobile*',
//                                     border: UnderlineInputBorder(),
//                                     enabledBorder: UnderlineInputBorder(),
//                                     focusedBorder: UnderlineInputBorder(),
//                                     errorBorder: UnderlineInputBorder(),
//                                     focusedErrorBorder: UnderlineInputBorder(),
//                                   )),
//                               // Container(
//                               //   height: Screens.bodyheight(context) * 0.4,
//                               //   child: SingleChildScrollView(
//                               //     child: Column(
//                               //       children: [
//                               //         Center(
//                               //           child: Wrap(
//                               //               spacing: 8.0, // width
//                               //               runSpacing: 3.0, // height
//                               //               children: listContainersCustomerTag(
//                               //                   theme, callCon)),
//                               //         ),
//                               //       ],
//                               //     ),
//                               //   ),
//                               // ),
//                               SizedBox(
//                                 // height: Screens.padingHeight(context) * 0.1,
//                                 child: DropdownButtonFormField(
//                                   decoration: const InputDecoration(
//                                     // hintText: 'Email',
//                                     labelText: 'Customer Group',
//                                     border: UnderlineInputBorder(),
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     focusedBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     errorBorder: UnderlineInputBorder(),
//                                     focusedErrorBorder: UnderlineInputBorder(),
//                                   ),

//                                   //dropdownColor:Colors.green,
//                                   icon: const Icon(Icons.arrow_drop_down),
//                                   iconSize: 30,
//                                   style: const TextStyle(
//                                       color: Colors.black, fontSize: 16),
//                                   // isExpanded: true,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       callCon.choosedCustomerGroupType(
//                                           val.toString());
//                                     });
//                                   },
//                                   items: callCon.getCusTagList
//                                       .map((CustomerTagTypeData2 cusTag) {
//                                     return DropdownMenuItem<String>(
//                                       value: cusTag.Code,
//                                       child: Text(cusTag.Name!),
//                                     );
//                                   }).toList(),
//                                   value: callCon.cusTagValue,
//                                 ),
//                               ),
//                               SizedBox(
//                                 // height: Screens.padingHeight(context) * 0.1,
//                                 child: DropdownButtonFormField(
//                                   decoration: const InputDecoration(
//                                     // hintText: 'Email',
//                                     labelText: 'Looking for',
//                                     border: UnderlineInputBorder(),
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     focusedBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     errorBorder: UnderlineInputBorder(),
//                                     focusedErrorBorder: UnderlineInputBorder(),
//                                   ),

//                                   value: callCon.categoryValue,
//                                   //dropdownColor:Colors.green,
//                                   icon: Icon(Icons.arrow_drop_down),
//                                   iconSize: 30,
//                                   style: const TextStyle(
//                                       color: Colors.black, fontSize: 16),
//                                   isExpanded: true,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       callCon.choosedType(val.toString());
//                                     });
//                                   },
//                                   items: callCon.filtercatagorydata
//                                       .map((String name) {
//                                     return DropdownMenuItem<String>(
//                                       value: name,
//                                       child: Text(name),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               SizedBox(
//                                 // height: Screens.padingHeight(context) * 0.1,
//                                 child: DropdownButtonFormField(
//                                   decoration: const InputDecoration(
//                                     // hintText: 'Email',
//                                     labelText: 'Enq Reffer',
//                                     border: UnderlineInputBorder(),
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     focusedBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     errorBorder: UnderlineInputBorder(),
//                                     focusedErrorBorder: UnderlineInputBorder(),
//                                   ),

//                                   value: callCon.enqReffeValue,
//                                   //dropdownColor:Colors.green,
//                                   icon: Icon(Icons.arrow_drop_down),
//                                   iconSize: 30,
//                                   style: const TextStyle(
//                                       color: Colors.black, fontSize: 16),
//                                   isExpanded: true,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       callCon.choosedRefferType(val.toString());
//                                     });
//                                   },
//                                   items: callCon.enqReffList
//                                       .map((EnqRefferesData data) {
//                                     return DropdownMenuItem<String>(
//                                       value: data.Code,
//                                       child: Text(data.Name!),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               SizedBox(
//                                 // height: Screens.padingHeight(context) * 0.1,
//                                 child: DropdownButtonFormField(
//                                   decoration: const InputDecoration(
//                                     // hintText: 'Email',
//                                     labelText: 'State',
//                                     border: UnderlineInputBorder(),
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     focusedBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.grey),
//                                     ),
//                                     errorBorder: UnderlineInputBorder(),
//                                     focusedErrorBorder: UnderlineInputBorder(),
//                                   ),

//                                   value: callCon.stateValue,
//                                   //dropdownColor:Colors.green,
//                                   icon: const Icon(Icons.arrow_drop_down),
//                                   iconSize: 30,
//                                   style: const TextStyle(
//                                       color: Colors.black, fontSize: 16),
//                                   isExpanded: true,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       callCon.choosedStateType(val.toString());
//                                     });
//                                   },
//                                   items: callCon.filterstateData
//                                       .map((StateHeaderData data) {
//                                     return DropdownMenuItem<String>(
//                                       value: data.statecode,
//                                       child: Text(data.stateName!),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: Screens.bodyheight(context) * 0.02,
//                               ),
//                               const Row(
//                                 children: [Text('Reminder On*')],
//                               ),
//                               SizedBox(
//                                 height: Screens.bodyheight(context) * 0.02,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     // height: context
//                                     //             .read<NewEnqController>()
//                                     //             .reminderDatebool ==
//                                     //         false
//                                     //     ? Screens.bodyheight(context) * 0.06
//                                     //     : null,
//                                     width: Screens.width(context) * 0.5,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: Colors.grey.withOpacity(0.01),
//                                     ),

//                                     child: TextFormField(
//                                       // controller: context
//                                       //     .read<NewEnqController>()
//                                       //     .mycontroller[16],

//                                       onTap: () {
//                                         // setState(() {
//                                         //   context
//                                         //       .read<NewEnqController>()
//                                         //       .clearbool2();
//                                         //   context
//                                         //       .read<NewEnqController>()
//                                         //       .getDate2(context);
//                                         // });
//                                         callCon.getDate2(context);
//                                       },
//                                       autofocus: true,
//                                       readOnly: true,
//                                       // controller: posC.mycontroller[24],
//                                       cursorColor: Colors.grey,
//                                       style: theme.textTheme.bodyText2
//                                           ?.copyWith(
//                                               backgroundColor: Colors.white),
//                                       onChanged: (v) {},
//                                       // validator: context
//                                       //             .read<NewEnqController>()
//                                       //             .mycontroller[16]
//                                       //             .text
//                                       //             .isEmpty &&
//                                       //         context
//                                       //             .read<NewEnqController>()
//                                       //             .mycontroller[17]
//                                       //             .text
//                                       //             .isEmpty
//                                       //     ? null
//                                       //     : (value) {
//                                       //         if (value!.isEmpty &&
//                                       //             context
//                                       //                     .read<
//                                       //                         NewEnqController>()
//                                       //                     .reminderDatebool ==
//                                       //                 false) {
//                                       //           setState(() {
//                                       //             context
//                                       //                 .read<NewEnqController>()
//                                       //                 .reminderDatebool = true;
//                                       //           });

//                                       //           return 'Please Enter Date';
//                                       //         } else if (value.isNotEmpty) {
//                                       //           setState(() {
//                                       //             context
//                                       //                 .read<NewEnqController>()
//                                       //                 .reminderDatebool = false;
//                                       //           });

//                                       //           return null;
//                                       //         }
//                                       //       },
//                                       decoration: InputDecoration(
//                                         fillColor: Colors.white,
//                                         suffixIcon: IconButton(
//                                             padding: EdgeInsets.only(
//                                                 top: Screens.bodyheight(
//                                                         context) *
//                                                     0.002),
//                                             onPressed: () {
//                                               // context
//                                               //     .read<NewEnqController>()
//                                               //     .getDate2(context);
//                                             },
//                                             icon: Icon(
//                                               Icons.date_range,
//                                               color: theme.primaryColor,
//                                             )),
//                                         filled: true,
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide:
//                                               BorderSide(color: Colors.red),
//                                         ),
//                                         errorBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide:
//                                               BorderSide(color: Colors.red),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide:
//                                               BorderSide(color: Colors.grey),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide:
//                                               BorderSide(color: Colors.grey),
//                                         ),
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                           vertical: 11,
//                                           horizontal: 10,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: Screens.bodyheight(context) * 0.01,
//                                   ),
//                                   Container(
//                                     // height: Screens.bodyheight(context) * 0.06,

//                                     width: Screens.width(context) * 0.37,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),

//                                     child: TextFormField(
//                                       // controller: context
//                                       //     .read<NewEnqController>()
//                                       //     .mycontroller[17],

//                                       onTap: () {
//                                         setState(() {
//                                           // context
//                                           //     .read<NewEnqController>()
//                                           //     .selectTime2(context);
//                                         });
//                                       },
//                                       autofocus: true,
//                                       readOnly: true,
//                                       cursorColor: Colors.grey,
//                                       style: theme.textTheme.bodyText2
//                                           ?.copyWith(
//                                               backgroundColor: Colors.white),
//                                       onChanged: (v) {},

//                                       decoration: InputDecoration(
//                                         fillColor: Colors.white,
//                                         suffixIcon: IconButton(
//                                             padding: EdgeInsets.only(
//                                                 top: Screens.bodyheight(
//                                                         context) *
//                                                     0.002),
//                                             onPressed: () {
//                                               setState(() {
//                                                 // context
//                                                 //     .read<NewEnqController>()
//                                                 //     .selectTime2(context);
//                                               });
//                                             },
//                                             icon: Icon(
//                                               Icons.timer,
//                                               color: theme.primaryColor,
//                                             )),
//                                         filled: true,
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide: const BorderSide(
//                                               color: Colors.red),
//                                         ),
//                                         errorBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide: const BorderSide(
//                                               color: Colors.red),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide: const BorderSide(
//                                               color: Colors.grey),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           borderSide: const BorderSide(
//                                               color: Colors.grey),
//                                         ),
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                           vertical: 11,
//                                           horizontal: 10,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 : Container(
//                     color: theme.primaryColor,
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: callerList == null
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                             ),
//                           )
//                         // Column(
//                         //     mainAxisAlignment: MainAxisAlignment.center,
//                         //     children: [
//                         //       InkWell(
//                         //         onTap: () {
//                         //           // calllog();

//                         //           // SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
//                         //         },
//                         //         child: Icon(Icons.open_in_browser),
//                         //       ),
//                         //       SizedBox(
//                         //         height: 20,
//                         //       ),
//                         //       InkWell(
//                         //         onTap: () {
//                         //           // calllog();

//                         //           SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
//                         //         },
//                         //         child: const Center(child: Icon(Icons.close)),
//                         //       ),
//                         //     ],
//                         //   )
//                         : Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 height: Screens.bodyheight(context) * 0.2,
//                                 decoration: BoxDecoration(
//                                     // borderRadius: BorderRadius.circular(100),
//                                     color: theme.primaryColor),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                   "${callerList!.name!.capitalize} ",
//                                                   style: theme
//                                                       .textTheme.bodyLarge!
//                                                       .copyWith(
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold)),
//                                               Container(
//                                                 alignment: Alignment.topCenter,
//                                                 // padding: EdgeInsets.all(
//                                                 //     Screens.bodyheight(context) * 0.01),
//                                                 // height:
//                                                 //     Screens.bodyheight(context) * 0.07,
//                                                 // width: Screens.width(context) * 0.2,
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.yellow[100],
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             4)),
//                                                 child: Text(
//                                                   '${callerList!.tag}',
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           Text(
//                                             "+91 ${callerList!.mobile}",
//                                             style: const TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     IconButton(
//                                         padding: EdgeInsets.only(
//                                             right: Screens.bodyheight(context) *
//                                                 0.08),
//                                         onPressed: () {
//                                           // callBackFunction("Close");
//                                           SystemAlertWindow.closeSystemWindow(
//                                               prefMode: prefMode);
//                                         },
//                                         icon: Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: Screens.bodyheight(context) *
//                                               0.06,
//                                         ))
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 height: Screens.bodyheight(context) * 0.95,
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20)),
//                                     color: Colors.grey[300]!),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     callerList!.datalist == null
//                                         ? Container()
//                                         : SizedBox(
//                                             height:
//                                                 Screens.bodyheight(context) *
//                                                     0.7,
//                                             width:
//                                                 Screens.width(context) * 0.85,
//                                             // color: Colors.grey[300]!,
//                                             child: ListView.builder(
//                                                 itemCount: callerList!
//                                                     .datalist!.length,
//                                                 itemBuilder:
//                                                     (BuildContext context,
//                                                         int index) {
//                                                   var data = callerList!
//                                                       .datalist![index];
//                                                   return Container(
//                                                     padding: EdgeInsets.all(
//                                                         Screens.bodyheight(
//                                                                 context) *
//                                                             0.01),
//                                                     margin: EdgeInsets.all(
//                                                         Screens.bodyheight(
//                                                                 context) *
//                                                             0.01),
//                                                     // height: Screens.bodyheight(context)*0.08,
//                                                     decoration: BoxDecoration(
//                                                         border: Border.all(
//                                                             color: Colors.grey),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10),
//                                                         color: Colors.white,
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                               color: Colors
//                                                                   .grey[400]!,
//                                                               spreadRadius: 1.0,
//                                                               offset:
//                                                                   const Offset(
//                                                                       0, 1.0),
//                                                               blurRadius: 1.0)
//                                                         ]),
//                                                     child: Column(
//                                                       children: [
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Text(
//                                                                 "Last ${data.doctype} on "),
//                                                             Text(config
//                                                                 .alignDate(data
//                                                                     .lastorder
//                                                                     .toString())),
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Text(
//                                                                 "${data.doctype} DocNum "),
//                                                             Text(
//                                                                 "#${data.docnum}"),
//                                                           ],
//                                                         ),
//                                                         Text("${data.product}"),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             const Text(
//                                                                 "Handled by "),
//                                                             Text(
//                                                                 "${data.assignto}"),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   );
//                                                 }),
//                                           ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         SizedBox(
//                                           height:
//                                               Screens.bodyheight(context) * 0.1,
//                                           width: Screens.width(context) * 0.4,
//                                           child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                   backgroundColor:
//                                                       theme.primaryColor,
//                                                   // side: BorderSide(color: Colors.yellow, width: 5),
//                                                   shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10))),
//                                               onPressed: () async {
//                                                 // final Uri toLaunch = Uri(
//                                                 //     scheme: 'https',
//                                                 //     host:
//                                                 //         'sellerkitcallerdsahboard.page.link',
//                                                 //     path: 'headers/');
//                                                 // config.launchInBrowser(toLaunch);
//                                                 // Get.offAllNamed(
//                                                 //     ConstantRoutes.callnotification);
//                                                 // await LaunchApp.openApp(
//                                                 //   androidPackageName:
//                                                 //       'com.example.sellerkitcallerdashboard',
//                                                 //   // openStore: false
//                                                 // );

//                                                 // DynamicLinkSelfCreateApi

//                                                 //         .getDynamicLinkCreateApiData(
//                                                 //             'Add enquiry')
//                                                 //     .then((value) async {
//                                                 //   if (value.dynamiclinkData != null &&
//                                                 //       value.dynamiclinkData!.shortlink!
//                                                 //           .isNotEmpty) {
//                                                 //     if (value.dynamiclinkData!.shortlink!
//                                                 //         .isNotEmpty) {
//                                                 //       if (!await launchUrl(
//                                                 //           Uri.parse(value.dynamiclinkData!
//                                                 //               .shortlink!),
//                                                 //           mode: LaunchMode
//                                                 //               .externalNonBrowserApplication)) {
//                                                 //         throw 'Could not launch ${value.dynamiclinkData!.shortlink!}';
//                                                 //       }
//                                                 //     }
//                                                 //   }
//                                                 // }).then((value) {

//                                                 // });

//                                                 // if (!await launchUrl(
//                                                 //     Uri.parse("https"),
//                                                 //     mode:
//                                                 //         LaunchMode.externalApplication)) {
//                                                 //   throw 'Could not launch ';
//                                                 // }

//                                                 // Get.offAllNamed(
//                                                 // ConstantRoutes.callnotification);

//                                                 // var alarmPlugin =
//                                                 //     FlutterAlarmBackgroundTrigger();
//                                                 // alarmPlugin.addAlarm(
//                                                 //     // Required
//                                                 //     DateTime.now()
//                                                 //         .add(Duration(seconds: 1)),

//                                                 //     //Optional
//                                                 //     uid: "YOUR_APP_ID_TO_IDENTIFY",
//                                                 //     payload: {
//                                                 //       "YOUR_EXTRA_DATA": "FOR_ALARM"
//                                                 //     },

//                                                 // screenWakeDuration: For how much time you want
//                                                 // to make screen awake when alarm triggered
//                                                 // screenWakeDuration:
//                                                 //     Duration(seconds: 2));
//                                                 MyAppState;
//                                                 MyAppState.callBackFunction(
//                                                     "Add Enquiry");
//                                               },
//                                               child: Text(
//                                                 'Add Enquiry',
//                                                 style: theme
//                                                     .textTheme.bodySmall!
//                                                     .copyWith(
//                                                         color: Colors.white),
//                                               )),
//                                         ),
//                                         SizedBox(
//                                           height:
//                                               Screens.bodyheight(context) * 0.1,
//                                           width: Screens.width(context) * 0.4,
//                                           child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                   backgroundColor:
//                                                       theme.primaryColor,
//                                                   // side: BorderSide(color: Colors.yellow, width: 5),
//                                                   shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10))),
//                                               onPressed: () {},
//                                               child: Text(
//                                                 'Analyse',
//                                                 style: theme
//                                                     .textTheme.bodySmall!
//                                                     .copyWith(
//                                                         color: Colors.white),
//                                               )),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//       ],
//     );
//   }

//   SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<CallNotificationController>(
//         create: (context) => CallNotificationController(),
//         builder: (context, child) {
//           return Consumer<CallNotificationController>(
//               builder: (BuildContext context, callCon, Widget? child) {
//             return Scaffold(
//               body: overlay(callCon),
//             );
//           });
//         });
//   }

//   List<Widget> listContainersCustomerTag(
//       ThemeData theme, CallNotificationController callCont) {
//     return List.generate(
//       callCont.getCusTagList.length,
//       (index) => InkWell(
//         onTap: () {
//           callCont.selectCsTag(callCont.getCusTagList[index].Code.toString());
//         },
//         child: Container(
//           width: Screens.width(context) * 0.3,
//           height: Screens.bodyheight(context) * 0.045,
//           //  padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: callCont.getisSelectedCsTag ==
//                       callCont.getCusTagList[index].Code.toString()
//                   ? const Color(
//                       0xffB299A5) //theme.primaryColor.withOpacity(0.5)
//                   : Colors.white,
//               border: Border.all(color: theme.primaryColor, width: 1),
//               borderRadius: BorderRadius.circular(10)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(callCont.getCusTagList[index].Name.toString(),
//                   textAlign: TextAlign.center,
//                   maxLines: 8,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     fontSize: 10,
//                     color: callCont.getisSelectedCsTag ==
//                             callCont.getCusTagList[index].Code.toString()
//                         ? theme.primaryColor //,Colors.white
//                         : theme.primaryColor,
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GetCallerData {
//   String? name;
//   String? mobile;
//   String? tag;
//   List<EnqOrderList>? datalist = [];
//   GetCallerData({
//     this.name,
//     this.mobile,
//     this.tag,
//     this.datalist,
//   });
// }

// class EnqOrderList {
//   String? doctype;
//   String? lastorder;
//   String? docnum;
//   String? product;
//   String? assignto;
//   EnqOrderList({
//     this.doctype,
//     this.lastorder,
//     this.docnum,
//     this.product,
//     this.assig nto,
//   });
// }
