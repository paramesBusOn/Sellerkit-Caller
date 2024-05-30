

// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:sellerkitcalllog/helpers/Configuration.dart';
// import 'package:sellerkitcalllog/helpers/Utils.dart';
// import 'package:sellerkitcalllog/helpers/encripted.dart';
// import 'package:sellerkitcalllog/helpers/helper.dart';
// import 'package:sellerkitcalllog/src/Models/LoginModel/LoginModel.dart';


// class LoginAPi {
//   static Future<LoginModel> getData(PostLoginData postLoginData) async {
//     int resCode = 500;

//     try {
     
//       final response = await http.post(
//           Uri.parse("${Utils.queryApi}PortalAuthenticate/MOBILELOGIN"),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode({
//             "tenantId": Utils.tenetID.toString().trim(),
//             "userCode": postLoginData.username.toString().trim(),
//             "password": postLoginData.password.toString().trim(),
//             "deviceCode": "${postLoginData.deviceCode}",
//             "fcmToken": "${postLoginData.fcmToken}",
//             "ip": Utils.ipaddress,
//             "ssid": Utils.ipname,
//             "lattitude": Utils.latitude == 'null' ||
//                     Utils.latitude == ''
//                 ? 0.0
//                 : double.parse(Utils.latitude.toString()),
//             "longitude": Utils.langtitude == 'null' ||
//                     Utils.langtitude == ''
//                 ? 0.0
//                 : double.parse(Utils.langtitude.toString()),
//                 "devicename":"${postLoginData.devicename}",
//           }));
//       print("Login Req Body::${jsonEncode({
//             "tenantId": Utils.tenetID.toString().trim(),
//             "userCode": postLoginData.username.toString().trim(),
//             "password": postLoginData.password.toString().trim(),
//             "deviceCode": "${postLoginData.deviceCode}",
//             "fcmToken": "${postLoginData.fcmToken}",
//             "ip": Utils.ipaddress,
//             "ssid": Utils.ipname,
//             "lattitude": Utils.latitude == 'null' ||
//                     Utils.latitude == ''
//                 ? 0.0
//                 : double.parse(Utils.latitude.toString()),
//             "longitude": Utils.langtitude == 'null' ||
//                     Utils.langtitude == ''
//                 ? 0.0
//                 : double.parse(Utils.langtitude.toString()),
//                  "devicename":"${postLoginData.devicename}",
//           })}");
     
//       // log("ADADADDAD" + "${response.statusCode.toString()}");
//       log("bodylogin::" "${response.body}");

//       resCode = response.statusCode;
//       if (response.statusCode == 200) {
//         //
        
//         Config config = Config();
//          Map<String, dynamic> tokenNew3=json.decode(response.body);
//         Map<String, dynamic> jres = config.parseJwt(tokenNew3['token'].toString());
//         log("ABCD7333:::$jres");
//         EncryptData Encrupt = EncryptData();
//         String? testData2 = Encrupt.decrypt(jres['encrypted']);

//         Map<String, dynamic> jres2 = jsonDecode(testData2);
//         log("jres2:::$jres2");
//         Map<String, dynamic> tokenNew=json.decode(response.body);
//                 log("token::::${tokenNew['token']}");
//        Utils.token = tokenNew['token'];
//              HelperFunctions.saveTokenSharedPreference(tokenNew['token']);

//         return LoginModel.fromJson(jres2,json.decode(response.body) ,response.statusCode);
//       } else if(response.statusCode >= 400 && response.statusCode <= 410) {
//         print("Error: error");
//         return LoginModel.issue(response.statusCode, json.decode(response.body));
//       }else{
//         log("APIERRor::${json.decode(response.body)}");
//         return LoginModel.issue(response.statusCode, json.decode(response.body));
//       }
//     } catch (e) {
//       print("Catch:$e");
//       return LoginModel.error(resCode, "$e");
//     }
//   }
// }

// // body: jsonEncode({
// //             "deviceCode": "${postLoginData.deviceCode}",
// //             "userName":"${postLoginData.username}",
// //             "password": postLoginData.password.toString().isEmpty || postLoginData.password == null?"null":"${postLoginData.password}",
// //             "licenseKey":postLoginData.licenseKey.toString().isEmpty  || postLoginData.licenseKey == null?"null": "${postLoginData.licenseKey}",
// //            "fcmToken":"${postLoginData.fcmToken}"
// //           }));
