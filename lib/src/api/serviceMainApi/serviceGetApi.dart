// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class ServiceGet {
  static Future<Responce> callApi(String url, String token) async {
    int resCode = 500;
    log("url " + url);
    try {
      String? getUrl = await HelperFunctions.getHostDSP();
      Utils.queryApi = 'http://${getUrl.toString()}/api/';
      final response = await http.get(
        Uri.parse(Utils.queryApi + url),
        headers: {
          "content-type": "application/json",
          "Authorization": "bearer $token"
        },
      );
      log("Body message: " + response.body);
      log("Body message: " + response.statusCode.toString());

      resCode = response.statusCode;

      if (response.statusCode == 200) {
        // Map data = json.decode(response.body);
        return Responce.getRes(resCode, response.body);
      } else {
        print("Error: ${response.body}");
        // throw Exception("Error");
        return Responce.getRes(
          resCode,
          response.body,
        );
      }
    } catch (e) {
      resCode = 500;
      print("Exception: " + e.toString());
      //  throw Exception(e.toString());
      return Responce.getRes(
        resCode,
        e.toString(),
      );
    }
  }
}
