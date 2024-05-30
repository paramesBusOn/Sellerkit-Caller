// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_local_variable, unnecessary_new

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:dart_ipify/dart_ipify.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Config {
  msgDialog(BuildContext context, String title, String msg) {
    final theme = Theme.of(context);
    // Get.defaultDialog(
    //   title: "$title",
    //   titleStyle: TextStyle(color: Colors.black),
    //   middleTextStyle: TextStyle(color: Colors.black),
    //   buttonColor: Colors.red,
    //   barrierDismissible: false,
    //   content: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Text(
    //         "$msg",
    //         style: theme.textTheme.bodyMedium?.copyWith(),
    //       ),
    //     ],
    //   ),
    // );
  }

  showSnackBars(String title, String msg, Color color) {
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: msg,
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<List<String>> getIosNetworkInfo() async {
    const platform = MethodChannel('your_channel_name');
    List<String>? NetworkinfoIos = ["", ""];

    try {
      var ipAddress = IpAddress(type: RequestType.text);
      String data = await ipAddress.getIpAddress();
      //
      final result = await platform.invokeMethod('getSwiftVariable');
      NetworkinfoIos[0] = result == null ? 'Local Network' : result.toString();
      NetworkinfoIos[1] = data == null ? '00.00.0.00' : data.toString();

      return NetworkinfoIos;
    } on PlatformException catch (e) {
      var ipAddress = IpAddress(type: RequestType.text);
      String data = await ipAddress.getIpAddress();
      //
      NetworkinfoIos[0] = 'Local Network';
      NetworkinfoIos[1] = data == null ? '00.00.0.00' : data.toString();
      return NetworkinfoIos;
    }
  }

  static Future<String?> getdeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'

      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  Future<String> getNetworkName() async {
    final MethodChannel networkInfoChannel = MethodChannel('network_info');
    try {
      return await networkInfoChannel.invokeMethod('getNetworkName');
    } catch (e) {
      return 'Error getting network name: $e';
    }
  }

  final firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> getToken() async {
    return await firebaseMessaging.getToken();
  }

  Future<String> getNetworkIPAddress() async {
    final MethodChannel _networkInfoChannel = MethodChannel('network_info');
    try {
      return await _networkInfoChannel.invokeMethod('getNetworkIPAddress');
    } catch (e) {
      return 'Error getting network IP address: $e';
    }
  }

  String subtractDateTime4(String datetime) {
    final parsedDate = DateFormat("dd-MM-yyyy").parse(datetime);

    final outputFormat = DateFormat("yyyy-MM-dd");
    String test = outputFormat.format(parsedDate);

    final birthday = DateTime.parse(test);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    log(difference.toString());
    String result = '';
    if (difference == 0) {
      result = 'Today';
    } else {
      result = '$difference days';
    }

    return result.toString();
  }

// reminder
  Future<void> addEventToCalendar(
      TZDateTime chosenDate, String? title, String? description) async {
    try {
      final calendars = await DeviceCalendarPlugin().retrieveCalendars();
      final calendar = calendars.data;

      final reminder = Reminder(minutes: 30);
      // final tz.TZDateTime reminderDateTime = chosenDate.subtract(Duration(minutes: 30));

      final event = Event(
        "1",
        title: title,
        description: description,
        // location: 'Event Location',
        start: chosenDate,
        reminders: [reminder],
        end: chosenDate.add(Duration(hours: 1)), // Adjust end time as needed
      );

      await DeviceCalendarPlugin().createOrUpdateEvent(event);
      log("DONE");
    } catch (e) {
      log(e.toString());
    }
  }

  String currentDateOnly2() {
    String date;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
    final String formatted = formatter.format(now);
    date = formatter.toString();
    return date.toString();
  }

  String currentTimeOnly2() {
    String time;
    time = DateFormat.jm().toString();
    // somethin
    return time.toString();
  }

  String alignmeetingdate333(String date1) {
    String dateT = date1.replaceAll("T", " ");
    log("DATATTA" + dateT.toString());
    final timestamp = DateTime.parse('$date1');

    // Define the desired date and time format
    final formattedDateTime = DateFormat('dd-MM-yyyy').format(timestamp);
    log("DATE::" + formattedDateTime);
    return formattedDateTime;
  }

  showMsg(String msg, BuildContext context, Color col) {
    final having = SnackBar(
      content: Text(msg),
      backgroundColor: col,
    );
    ScaffoldMessenger.of(context).showSnackBar(having);
  }

  disableKeyBoard(BuildContext context) {
    FocusScopeNode focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus) {
      focus.unfocus();
    }
  }

  Map<String, dynamic> parseJwt(String token) {
    log("String token::" + token.toString());

    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = decodeBase64(parts[1]);
    // log("payload"+payload.toString());
    final payloadMap = json.decode(payload);
    log("payloadMap" + payloadMap.toString());
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  Future<List<String>> setNetwork() async {
    final info = NetworkInfo();

    List<String>? wifiinfo = ["", ""];
    var locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      // await Permission.locationWhenInUse.request();
      if (Platform.isAndroid) {
        await Permission.location.request();
      }
      //await Permission.locationAlways.request();
    }
    if (locationStatus.isGranted) {
      // await Permission.locationWhenInUse.request();
      await HelperFunctions.saveLocationSharedPref('true');
      //await Permission.locationAlways.request();
    }

    if (await Permission.location.isRestricted) {
      // openAppSettings();
    }
    if (locationStatus.isPermanentlyDenied) {
      // openAppSettings();
    }

    wifiinfo[0] =
        await info.getWifiName() == null ? '' : (await info.getWifiName())!;
    wifiinfo[1] =
        await info.getWifiIP() == null ? '0' : (await info.getWifiIP())!;
    // var wifiName = await info.getWifiIP();
    log('wifiName $wifiinfo');

    return wifiinfo;
  }

  String decodeBase64(String str) {
    //'-', '+' 62nd char of encoding,  '_', '/' 63rd char of encoding
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      // Pad with trailing '='
      case 0: // No pad chars in this case
        break;
      case 2: // Two pad chars
        output += '==';
        break;
      case 3: // One pad char
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  String alignDateforFollow(String time, String date) {
    // log("ANBU"+date1.toString());
    // log("ANBU"+date2.toString());
    final inputTime = "$time";
    final inputDate = "$date";

    final outputFormat = DateFormat("HH:mm:ss.SSS");
    final parsedTime = DateFormat("h:mm a").parse(inputTime);

    final formattedTime = outputFormat.format(parsedTime);
    log("FORMAT" + formattedTime);

    final formatdatetime = "${inputDate}T$formattedTime";
    log("formatdatetime" + formatdatetime);
    return formatdatetime;
  }

  String aligndatefollow(String date) {
    final inputDate = "$date";
    final outputFormat = DateFormat("yyyy-MM-dd");
    final parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(inputDate);
    final formattedDate = outputFormat.format(parsedDate);

    return formattedDate;
  }

  String alignDateFollowTime(String date) {
    final inputDate = "$date";
    final outputFormat = DateFormat("h:mm a");
    final parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(inputDate);

    final formattedDate = outputFormat.format(parsedDate);
    log(formattedDate);
    // print(
    //     "${dates.year.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day}");
    return formattedDate;
  }

  String currentDate() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return currentDateTime;
  }

  String currentPDFDateOnly() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().padLeft(2, '0')}";
    return currentDateTime;
  }

  String currentTimelead() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return currentDateTime;
  }

  String currentDatepdf() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "${now.day.toString()}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return currentDateTime;
  }

  String currentTmeonly() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return currentDateTime;
  }

  String firstDate() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${"1".toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return currentDateTime;
  }
// String currentDateOnly() {
//     DateTime now = DateTime.now();

//     String currentDateTime =
//         "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
//     print("date: " + currentDateTime.toString());
//     return currentDateTime;
//   }
  String currentDateOnly() {
    DateTime now = DateTime.now();

    String currentDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return currentDateTime;
  }

  //for Enquiry
  String remainderontime(String time) {
    // log("ANBU"+date1.toString());
    // log("ANBU"+date2.toString());
    final inputTime = "$time";
    final outputFormat = DateFormat("HH:mm:ss.SSS'Z'");
    final parsedTime = DateFormat("h:mm a").parse(inputTime);

    final formattedTime = outputFormat.format(parsedTime);
    log("FORMAT" + formattedTime);

    //  String dateT = date1.replaceAll("T", "");
    //  String dateT2 = date2.replaceAll("Z", "");
    //   var dates = DateTime.parse(date1);
    //   var dates2 = DateTime.parse(date2);
    //   log("SUBBBBB"+
    //       "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}${dates2.hour.toString().padLeft(2, '0')}:${dates2.minute.toString().padLeft(2, '0')}:${dates2.second.toString().padLeft(2, '0')}");
    return formattedTime;
  }

  String remainderonalign(String date) {
    final inputDate = "$date";
    final outputFormat = DateFormat("yyyy-MM-dd");
    final parsedDate = DateFormat("dd-MM-yyyy").parse(inputDate);

    final formattedDate = outputFormat.format(parsedDate);
    // print(
    //     "${dates.year.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day}");
    return formattedDate;
  }

  String alignDateforvisit(String time) {
    // log("ANBU"+date1.toString());
    // log("ANBU"+date2.toString());
    final inputTime = "$time";
    final outputFormat = DateFormat("HH:mm:ss.SSS'Z'");
    final parsedTime = DateFormat("h:mm a").parse(inputTime);

    final formattedTime = outputFormat.format(parsedTime);
    log("FORMAT" + formattedTime);
    //  String dateT = date1.replaceAll("T", "");
    //  String dateT2 = date2.replaceAll("Z", "");
    //   var dates = DateTime.parse(date1);
    //   var dates2 = DateTime.parse(date2);
    //   log("SUBBBBB"+
    //       "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}${dates2.hour.toString().padLeft(2, '0')}:${dates2.minute.toString().padLeft(2, '0')}:${dates2.second.toString().padLeft(2, '0')}");
    return formattedTime;
  }

  //
  String alignDateforleave(String time, String date) {
    log("ANBU" + date.toString());
    // log("ANBU"+date2.toString());
    final inputTime = "$time";
    final inputdata = "$date";
    final outputFormat2 = DateFormat("yyyy-MM-dd");
    final parsedDate = DateFormat("dd-MM-yyyy").parse(inputdata);

    final formattedDate = outputFormat2.format(parsedDate);
    log("GGGGGG" + formattedDate);
    final outputFormat = DateFormat("HH:mm:ss.SSS'Z'");
    final parsedTime = DateFormat("h:mm a").parse(inputTime);

    final formattedTime = outputFormat.format(parsedTime);
    log("FORMAT" + formattedTime);
    final formatdataTime = "${formattedDate}T$formattedTime";
    log("formatdataTime" + formatdataTime);
    return formatdataTime;
  }

  String aligndateleave(String date) {
    String inputDateString = "$date";
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(inputDateString);

    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(inputDate.toUtc());
    log("Dateeee" + formattedDate.toString());
    return formattedDate;
  }

  String aligndateleavereq(String date) {
    String inputDateString = "$date";
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(inputDateString);
    log("Dateeee1" + inputDate.toString());
    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(inputDate);
    log("Dateeee222222222" + formattedDate.toString());
    return formattedDate;
  }

  String aligndateforsiteout(String date) {
    String inputDateString = "$date";
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(inputDateString);

    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(inputDate.toUtc());

    return formattedDate;
  }

  String alignmeetingdate(String date1) {
    String dateT = date1.replaceAll("T", " ");
    log("DATATTA" + dateT.toString());
    final timestamp = DateTime.parse('$date1');

    // Define the desired date and time format
    final formattedDateTime = DateFormat('dd-MM-yyyy h:mma').format(timestamp);
    log("DATE::" + formattedDateTime);
    return formattedDateTime;
  }

  String alignTimeforleavepermission(String date1) {
    String dateT = date1.replaceAll("T", " ");
    log("DATATTA" + dateT.toString());
    final timestamp = DateTime.parse('$date1');

    // Define the desired date and time format
    final formattedDateTime = DateFormat('h:mma').format(timestamp);
    log("DATE::" + formattedDateTime);
    return formattedDateTime;
  }

  String alignDatelead(String date) {
    log("ANBU::" + date.toString());
    final inputDate = "$date";
    final outputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
    final parsedDate = DateFormat("dd-MM-yyyy").parse(inputDate);

    final formattedDate = outputFormat.format(parsedDate);
    // print(
    //     "${dates.year.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day}");
    return formattedDate;
  }

  String alignDatelead2(String date) {
    log("ANBU::" + date.toString());
    final inputDate = "$date";
    final outputFormat = DateFormat("dd-MM-yyyy");
    final parsedDate = DateFormat("yyyy-MM-ddThh:mm:ss").parse(inputDate);

    final formattedDate = outputFormat.format(parsedDate);
    // print(
    //     "${dates.year.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day}");
    return formattedDate;
  }

  String alignDatevisit(String date) {
    final inputDate = "$date";
    final outputFormat = DateFormat("yyyy-MM-dd");
    final parsedDate = DateFormat("dd-MM-yyyy").parse(inputDate);

    final formattedDate = outputFormat.format(parsedDate);
    // print(
    //     "${dates.year.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.day}");
    return formattedDate;
  }

  String aligndateorder(String date) {
    String inputDateString = '$date';

    // Parse the input date string
    DateTime inputDate = DateTime.parse(inputDateString);

    // Format the date to "dd-MM-yyyy"
    String formattedDate = DateFormat('dd-MM-yyyy').format(inputDate);

    return formattedDate;
  }

  String alignDate(String date) {
    if (date.isNotEmpty) {
      String dateT = date.replaceAll("T", "");
      var dates = DateTime.parse(date);
      return "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}";
    } else {
      return "00-00-0000";
    }
  }

  String alignDateTime(String date) {
    if (date.isNotEmpty) {
      String dateT = date.replaceAll("T", "");
      var dates = DateTime.parse(date);
      return "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}";
    } else {
      return "00-00-0000";
    }
  }

  String alignTime(String date) {
    if (date.isNotEmpty) {
      String dateT = date.replaceAll("T", "");
      var dates = DateTime.parse(date);
      return "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}";
    } else {
      return "00-00-0000";
    }
  }

  String alignTimeleave(String date) {
    if (date.isNotEmpty) {
      String dateT = date.replaceAll("T", "");
      var dates = DateTime.parse(date);
      return "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}";
    } else {
      return "00-00-0000";
    }
  }

  String alignDateT(String date) {
    var dates = DateTime.parse(date);
    return "${dates.day.toString().padLeft(2, '0')}-${dates.month.toString().padLeft(2, '0')}-${dates.year}";
  }

  String alignDate2(String date) {
    var dates = DateTime.parse(date);

    return "${dates.day.toString().padLeft(2, '0')} " +
        DateFormat.MMMM().format(dates).toString().substring(0, 3);
  }

  String alignDate3(String date) {
    var dates = DateTime.parse(date);
//         String time = DateFormat('HH:mm:ss').format(dateTime);
//  final inputTime = dates.hour;
    final parsedTime = DateFormat("h:mm a").format(dates);//for Time format
    return "${dates.day.toString().padLeft(2, '0')}'" +
        DateFormat.MMMM().format(dates).toString().substring(0, 3) +
        DateFormat.y().format(dates).toString().substring(2, 4) +
        " $parsedTime";
  }

  static String k_m_b_generator(String numbers) {
    int num = int.parse(numbers);

    int absnum = num.abs();
    if (absnum > 999 && absnum < 99999) {
      return "${(num / 1000).toStringAsFixed(2)} K";
    } else if (absnum > 99999 && absnum < 999999) {
      return "${(num / 1000).toStringAsFixed(2)} K";
    } else if (absnum > 999999 && absnum < 999999999) {
      return "${(num / 1000000).toStringAsFixed(2)} M";
    } else if (absnum > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(2)} B";
    } else {
      return num.toString();
    }
  }

  static Future<String?> getdeviceModel() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'

      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model; // unique ID on Android
    }
    return null;
  }

  static Future<String> getipaddress() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      final ipv4 = await Ipify.ipv4();

      final ipv6 = await Ipify.ipv64();

      final ipv4json = await Ipify.ipv64(format: Format.JSON);
      return ipv4;
    } else {
      return "No internet connection.";
    }
  }

  static Future<String?> getdeviceBrand() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'

      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.brand; // unique ID on Android
    }
    return null;
  }

  static String k_m_b_generator22(String numbers) {
    double num = double.parse(numbers);
    double absnum = num.abs();
    if (absnum > 999 && absnum < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (absnum > 99999 && absnum < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (absnum > 999999 && absnum < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (absnum > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  static String k_m_b_generator2(double numbers) {
    String? number = numbers.toString();
    int num = int.parse(number);
    int absnum = num.abs();
    if (absnum > 999 && absnum < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (absnum > 99999 && absnum < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (absnum > 999999 && absnum < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (absnum > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  // String subtractDateTime(String datetime) {
  //   log(Jiffy("$datetime", "yyyy-MM-ddThh:mm:ss").fromNow());
  //   return Jiffy("$datetime", "yyyy-MM-ddThh:mm:ss").fromNow();
  // }

  // String subtractDateTime3(String datetime) {
  //   log(Jiffy("$datetime", "yyyy-MM-ddThh:mm:ss").fromNow());
  //   return Jiffy("$datetime", "yyyy-MM-ddThh:mm:ss").fromNow();
  // }

  // String subtractDTWith(String datetime) {
  //   return Jiffy("$datetime", "yyyy-MM-dd hh:mm:ss").fromNow();
  // }

  // String subtractDTWith2(String datetime) {
  //   return Jiffy("$datetime", "yyyy-MM-ddThh:mm:ss").fromNow();
  // }

  String subtractDateTime2(String datetime) {
    String subDate = '';
    String sub = Jiffy("$datetime", "yyyy-MM-ddThh:mm:ss").fromNow();
    //T  2022-10-05 13:33:10
    log(sub);
    log(sub.substring(0, 3));
    // if(sub.contains("ago")){
    // subDate =  sub.replaceAll("ago", "");
    // }else

    if (sub.contains("an hour ago")) {
      subDate = sub.replaceAll("an hour ago", "an hrs");
    } else if (sub.contains("minute")) {
      // print("sub date 111: "+subDate);
      subDate = sub.substring(0, 6);
    } else if (sub.contains("a few seconds ago")) {
      subDate = sub.replaceAll("a few seconds ago", "a sec");
    } else if (sub.contains("hours ago")) {
      subDate = sub.replaceAll("hours ago", "hrs");
    } else if (sub.contains("days ago")) {
      subDate = sub.replaceAll("days ago", "days");
    } else if (sub.contains("a month ago")) {
      subDate = sub.replaceAll("a month ago", "a month");
    } else if (sub.contains("months ago")) {
      subDate = sub.replaceAll("months ago", "mths");
    } else if (sub.contains("years ago")) {
      subDate = sub.replaceAll("years ago", "years");
    } else {
      subDate = sub.replaceAll("a ", "");
    }
    //log("sub date: "+subDate);
    return subDate;
  }

  String slpitCurrency(String value) {
    int values = int.parse(value);
    var format = NumberFormat.currency(
      name: "INR", locale: 'en_IN',
      decimalDigits: 2, // change it to get decimal places
      symbol: '₹ ',
    );
    String formattedCurrency = format.format(values);
    return formattedCurrency;
  }

  String slpitCurrency22(String value) {
    double values = double.parse(value);
    var format = NumberFormat.currency(
      name: "INR", locale: 'en_IN',
      decimalDigits: 2, // change it to get decimal places
      symbol: '',
    );
    String formattedCurrency = format.format(values);
    // log("formattedCurrency::" + formattedCurrency.toString());
    return formattedCurrency;
  }

  String slpitCurrencypdf(String value) {
    double values = double.parse(value);
    var format = NumberFormat.currency(
      name: "INR", locale: 'en_IN',
      decimalDigits: 2, // change it to get decimal places
      symbol: '',
    );
    String formattedCurrency = format.format(values);
    // log("formattedCurrency::" + formattedCurrency.toString());
    return formattedCurrency;
  }

  String slpitCurrency2(String value) {
    int values = int.parse(value);
    var format = NumberFormat.currency(
      name: "INR", locale: 'en_IN',
      decimalDigits: 2, // change it to get decimal places
      symbol: '',
    );
    String formattedCurrency = format.format(values);
    return formattedCurrency;
  }

  // get ip

  // Future<String>  getIP()async{
  //   String ipv4 = await Ipify.ipv4();
  //   return ipv4;
  // }
}

class NumberFormatter {
  static String formatter(String currentBalance) {
    try {
      // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
      double value = double.parse(currentBalance);
      if (value >= 1000 && value < 10000) {
        // less than a million
        return value.toStringAsFixed(0) + 'K';
      }
      if (value >= 10000 && value < 100000) {
        // less than a million
        return value.toStringAsFixed(1) + 'K';
      } else if (value >= 100000 && value < 1000000) {
        // less than a million
        return value.toStringAsFixed(0) + 'K';
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // less than 100 million
        double result = value / 1000000;
        return result.toStringAsFixed(0) + "M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // less than 100 billion
        double result = value / (1000000 * 10 * 100);
        return result.toStringAsFixed(0) + "B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // less than 100 trillion
        double result = value / (1000000 * 10 * 100 * 100);
        return result.toStringAsFixed(0) + "T";
      }
    } catch (e) {
      return e.toString();
    }

    return currentBalance;
  }
}

// void showDialogBox(String title, String msg, BuildContext context) {
//   showDialog<dynamic>(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           final theme = Theme.of(context);
//           return AlertDialog(
//             title: Center(
//                 child: Text(
//               "$title",
//               style: theme.textTheme.subtitle1?.copyWith(color: Colors.black),
//             )),
//             content: Container(
//               width: Screens.width(context) * 0.8,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "$msg",
//                     style: theme.textTheme.bodyMedium?.copyWith(),
//                   ),
//                   SizedBox(
//                     height: Screens.bodyheight(context) * 0.01,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// void loginDialogBox(BuildContext context) {
//   showDialog<dynamic>(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           final theme = Theme.of(context);
//           return AlertDialog(
//             title: Center(
//                 child: Text(
//               "Welcome to login",
//               style: theme.textTheme.subtitle1?.copyWith(),
//             )),
//             content: Container(
//               width: Screens.width(context) * 0.8,
//               child: Form(
//                 key: context.watch<LoginController>().formkey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       controller:
//                           context.read<LoginController>().mycontroller[0],
//                       keyboardType: TextInputType.text,
//                       style: theme.textTheme.bodyText2,
//                       validator: (data) {
//                         if (data!.isEmpty) {
//                           return "Required*";
//                         }
//                         // else if (!data.contains("@")) {
//                         //   return "Enter Valid Email*";
//                         // }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 10.0),
//                         fillColor: Colors.grey[200],
//                         filled: true,
//                         prefixIcon: const Icon(
//                           Icons.account_circle_outlined,
//                           size: 25,
//                         ),
//                         labelText: "Username",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: const BorderSide(
//                             color: Colors.lightBlueAccent,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: Screens.bodyheight(context) * 0.02,
//                     ),
//                     TextFormField(
//                       controller:
//                           context.read<LoginController>().mycontroller[1],
//                       validator: (data) {
//                         if (data!.isEmpty) {
//                           return "Required*";
//                         }
//                         return null;
//                       },
//                       obscureText:
//                           context.watch<LoginController>().getHidepassword,
//                       style: theme.textTheme.bodyText2,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 10.0),
//                         fillColor: Colors.grey[200],
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: const BorderSide(
//                             color: Colors.lightBlueAccent,
//                           ),
//                         ),
//                         prefixIcon: const Icon(
//                           Icons.lock_outlined,
//                           size: 25,
//                         ),
//                         suffixIcon: IconButton(
//                           icon:
//                               context.watch<LoginController>().getHidepassword
//                                   ? const Icon(Icons.visibility_off)
//                                   : const Icon(Icons.visibility),
//                           onPressed: () {
//                             context.read<LoginController>().obsecure();
//                           },
//                         ),
//                         labelText: "Password",
//                       ),
//                     ),
//                     SizedBox(
//                       height: Screens.bodyheight(context) * 0.02,
//                     ),
//                     ElevatedButton(
//                         onPressed: () {
//                           context.read<LoginController>().validateLogin(context);
//                         },
//                         child: Text("Login"))
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
