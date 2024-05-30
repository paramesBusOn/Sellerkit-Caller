import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sellerkitcalllog/helpers/Configuration.dart';
// import 'package:sellerkit/main.dart';

class DynamicLinkSelfCreateApi {
  static Future<DynamicLinkModel> getDynamicLinkCreateApiData(
      String naviScreen) async {
    int resCode = 500;
    try {
      Config config = Config();

      final response = await http.post(
          Uri.parse(
              'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCbOz7GIL_9_D2G8M9zQvaMFN0uLV6J4kQ'),
          headers: {
            "content-type": "application/json",
          },
          body: jsonEncode({
            "dynamicLinkInfo": {
              "domainUriPrefix": "https://sellerkitcallerdsahboard.page.link",
              "link":
                  "https://sellerkitcallerdsahboard.page.link/callerappid?naviScreen=$naviScreen",
              "androidInfo": {
                "androidPackageName": "com.example.sellerkitcallerdashboard"
              },
              "iosInfo": {"iosBundleId": "com.example.sellerkitcallerdashboard"}
            }
          }));
      print(response.body);
      resCode = response.statusCode;
      if (response.statusCode == 200) {
        return DynamicLinkModel.fromJson(
            jsonDecode(response.body), response.statusCode);
      } else {
        return DynamicLinkModel.issue(
            jsonDecode(response.body), response.statusCode);
      }
    } catch (e) {
      return DynamicLinkModel.error('Error', 500);
    }
  }
}

class DynamicLinkModel {
  DynamicLinkData? dynamiclinkData;
  String? message;
  bool? status;
  String? exception;
  int? stcode;
  DynamicLinkModel(
      {required this.dynamiclinkData,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
  factory DynamicLinkModel.fromJson(Map<String, dynamic> jsons, int stcode) {
    if (jsons.isNotEmpty) {
      print("After Api calling::" + jsons.toString());
      // var list = jsons as List;
      // List<DynamicLinkData> dataList =
      //     list.map((data) => DynamicLinkData.fromJson(data)).toList();
      return DynamicLinkModel(
          dynamiclinkData: DynamicLinkData.fromJson(jsons['shortLink']),
          message: 'Sucess',
          status: true,
          stcode: stcode,
          exception: null);
    } else {
      return DynamicLinkModel(
          dynamiclinkData: null,
          message: "Failure",
          status: false,
          stcode: stcode,
          exception: null);
    }
  }
  factory DynamicLinkModel.issue(Map<String, dynamic> jsons, int stcode) {
    return DynamicLinkModel(
        dynamiclinkData: null,
        message: 'Failure',
        status: null,
        stcode: stcode,
        exception: 'Something went wrong');
  }
  factory DynamicLinkModel.error(String jsons, int stcode) {
    return DynamicLinkModel(
        dynamiclinkData: null,
        message: null,
        status: null,
        stcode: stcode,
        exception: jsons);
  }
}

class DynamicLinkData {
  String? shortlink;
  DynamicLinkData({
    required this.shortlink,
  });

  factory DynamicLinkData.fromJson(String json) => DynamicLinkData(
        shortlink: json ?? "",
      );
}
