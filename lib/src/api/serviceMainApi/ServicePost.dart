// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print
import 'dart:convert';
import 'dart:developer';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class ServicePost {
  static Future<Responce> callApi(
      String url, String token, Map<String, dynamic> body) async {
    int resCode = 500;
    Map<String, String>? headers1 = {};
    if (url.contains('PortalAuthenticate/MOBILELOGIN') ||
        url.contains('Sellerkit_Flexi/v2/Logout')) {
      headers1 = {
        "content-type": "application/json",
      };
    } else {
      headers1 = {
        "content-type": "application/json",
        "Authorization": "bearer $token"
      };
    }

    try {
      String? getUrl = await HelperFunctions.getHostDSP();
      Utils.queryApi = 'http://${getUrl.toString()}/api/';

      log("url: " + Utils.queryApi + url);
      final response = await http.post(Uri.parse(Utils.queryApi + url),
          headers: headers1, body: jsonEncode(body));
      log("Body req: " + jsonEncode(body));
      log("Body message body: " + response.body.toString());
      log("Status code : " + response.statusCode.toString());
      resCode = response.statusCode;
      if (response.statusCode == 200) {
        // Map data = json.decode(response.body);
        return Responce.getRes(resCode, response.body);
      } else if (response.statusCode >= 400 && response.statusCode <= 410) {
        return Responce.getRes(resCode, response.body);
      } else {
        // print("Error: ${json.decode(response.body)}");
        // throw Exception("Error");
        return Responce.getRes(
          resCode,
          response.body,
        );
      }
    } catch (e) {
      print("Exception: " + e.toString());
      //  throw Exception(e.toString());
      return Responce.getRes(
        resCode,
        e.toString(),
      );
    }
  }
}

class ServicePostNoBody {
  static Future<Responce> callApi(String url, String token) async {
    int resCode = 500;
    String mainUrl;
    if (url.contains('164.52.217.188:81')) {
      mainUrl = url;
    } else {
      mainUrl = Utils.queryApi + url;
    }

    try {
      log("url: " + Utils.queryApi + url);
      final response = await http.post(Uri.parse(mainUrl), headers: {
        "content-type": "application/json",
        "Authorization": "bearer $token"
      });
      log("Body message body: " + response.body.toString());
      log("Status code : " + response.statusCode.toString());
      resCode = response.statusCode;
      if (response.statusCode == 200) {
        return Responce.getRes(resCode, response.body);
      } else {
        print("Error: ${json.decode(response.body)}");
        return Responce.getRes(
          resCode,
          response.body,
        );
      }
    } catch (e) {
      print("Exception: " + e.toString());
      return Responce.getRes(
        resCode,
        e.toString(),
      );
    }
  }
}
