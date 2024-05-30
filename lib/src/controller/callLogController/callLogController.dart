import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:sellerkitcalllog/src/DBHelper/DBOperation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../helpers/Utils.dart';
import '../../../helpers/constantApiUrl.dart';
import '../../../helpers/getCallLog_NativeCode.dart';
import '../../../helpers/helper.dart';
import '../../api/getCustomerApi/getCustomerApi.dart';
import '../../dBHelper/dBHelper.dart';
import 'package:intl/intl.dart';

class CallLogController extends ChangeNotifier {
  CallLogController() {
    calllog();
  }
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  List<Callloginfo> callsInfo = [];
  List<Contact> contactList = [];
  List<GetenquiryData>? customerDatalist = [];
  GetCallerData? callerList;
  bool apiloading = false;
  void calllog() async {
    apiloading = true;
    String? getToken = await HelperFunctions.getTokenSharedPreference();
    Utils.token = getToken;
    callsInfo = [];

    // if (callented == false) return;
    String mobileno = '';

    // getPermissionUser();
    if (Platform.isAndroid) {
      Iterable<CallLogEntry> entries = await CallLog.get();
      for (var item in entries) {
        int timestampInSeconds = item.timestamp!; // Example timestamp
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            timestampInSeconds); //for Convert Timestamp to DateTime
        DateTime now = DateTime.now();
        DateTime before24Hours = now.subtract(
            const Duration(hours: 24)); // Get the date and time 24 hours before

        DateTime before24 = DateTime.parse("$before24Hours"); // 2:00 PM
        DateTime after24 = DateTime.parse("$dateTime"); // 6:00 PM
        String time = DateFormat('HH:mm:ss').format(dateTime);
        // Check if time2 is greater than time1
        if (after24.isAfter(before24)) {
          mobileno = item.number!.replaceAll('+91', '');
          notifyListeners();
          if (mobileno.length == 10) {
            final Database db = (await DBHelper.getInstance())!;

            List<Map<String, Object?>> result =
                await DBOperation.getCallCustomer(db, mobileno);

            if (result.isEmpty) {
              callsInfo.add(Callloginfo(
                  name: 'Unknown Number',
                  number: item.number,
                  customerTag: 'New',
                  calltype: item.callType.toString(),
                  time: '$after24'));
            } else {
              callsInfo.add(Callloginfo(
                  name: result[0]['cardname'].toString(),
                  number: result[0]['cardcode'].toString(),
                  customerTag: result[0]['tag'].toString(),
                  calltype: item.callType.toString(),
                  time: '$after24'));
            }
          }
        }

        apiloading = false;
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
      apiloading = false;

      notifyListeners();
    }

    notifyListeners();
  }
}

class Callloginfo {
  String? name;
  String? number;
  String? customerTag;
  String? calltype;
  String? time;

  Callloginfo(
      {this.name,
      required this.number,
      required this.customerTag,
      required this.calltype,
      required this.time});
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

class GetCallerData {
  String? name;
  String? mobile;
  String? tag;
  String? calltype;
  // List<EnqOrderList>? datalist = [];
  GetCallerData({this.name, this.mobile, this.tag, required this.calltype
      // this.datalist,
      });
}
