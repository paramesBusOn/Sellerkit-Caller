// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class ServicePatch {
  static Future<Responce> callApi(String url, String token) async {
    int resCode = 500;
    log("url " + url);
    try {
      final response = await http.patch(
        Uri.parse(Utils.queryApi + url),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      log("Body message: " + response.body);
      log("Body code: " + response.statusCode.toString());

      resCode = response.statusCode;

      if (response.statusCode == 200) {
        // Map data = json.decode(response.body);
        return Responce.getRes(resCode, response.body);
      } else {
        print("Error: ${response.body}");
        // throw Exception("Error");
        return Responce.getRes(
          resCode,
          'Error',
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

class ServicePatchwithBody {
  static Future<Responce> callApi(
      String url, String token, Map<String, dynamic> body) async {
    int resCode = 0;
    try {
      log("url: " + Utils.queryApi + url);
      final response = await http.patch(Uri.parse(Utils.queryApi + url),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
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
          'Error',
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
