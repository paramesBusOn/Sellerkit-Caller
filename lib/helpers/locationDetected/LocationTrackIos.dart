// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_interpolation_to_compose_strings, unused_import, avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';

class LocationTrack2 {
  static String isChange = "";
  static String lat = "";
  static String long = "";
  static String ip = "";
  static String ipName = "";

  static LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  static Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // GeolocatorApple.getPositionStream.
      // log("Location permission true"+permission.toString());
      Geolocator.openLocationSettings();
    } else {
      permission = await Geolocator.checkPermission();
      log("Location permission true" + permission.toString());

      if (permission == LocationPermission.denied) {
        //  permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await HelperFunctions.saveLocationSharedPref('');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Geolocator.openAppSettings();
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        print('test2');
        await locationCheck();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await HelperFunctions.saveLocationSharedPref('true');
        await locationCheck();
      }
    }
  }

  static Future<void> locationCheck() async {
    print('test3');

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print("Long: " + long.toString());
      print("Lat: " + lat.toString());
      if (long.isEmpty) {
        long =
            position == null ? 'Unknown' : "${position.longitude.toString()}";
        Utils.langtitude = long;
      }

      if (lat.isEmpty) {
        lat = position == null ? 'Unknown' : "${position.latitude.toString()}";
        Utils.latitude = lat;
      }
      print("Utils.langtitude: " + Utils.langtitude.toString());
      print("Utils.latitude: " + Utils.latitude.toString());

      if (long.toString() != position!.longitude.toString()) {
        isChange = "Yes";
        long = "${position.longitude.toString()}";
        Utils.langtitude = long;
      }
      if (lat.toString() != position.latitude.toString()) {
        isChange = "Yes";

        lat = "${position.latitude.toString()}";
        Utils.latitude = lat;
      }
    });
  }

  static checkcamlocation() async {
    // PermissionStatus permission;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    log("checkcamlocation:::" + statuses[Permission.camera].toString());
    if (statuses[Permission.camera] == PermissionStatus.denied ||
        statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
      //  openAppSettings();
    } else {}
  }

  static checkPermission() async {
    bool result = false;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        //permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Geolocator.openAppSettings();
        } else if (permission == LocationPermission.deniedForever) {
          // Geolocator.openAppSettings();
        } else {
          await locationCheck();
          result = true;
        }
      } else if (permission == LocationPermission.deniedForever) {
        // Geolocator.openAppSettings();
      } else {
        await locationCheck();
        result = true;
      }
    }
    return result;
  }
}


// // ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_interpolation_to_compose_strings

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:sellerkit/Constant/ConstantSapValues.dart';

// class LocationTrack with ChangeNotifier {
//   static String isChange = "";
//   static String Lat = "";
//   static String Long = "";
//   static String Ip = "";
//   static String IpName = "";

//   static LocationSettings locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 0,
//   );

//   static Future<void> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
// print("object1");
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     locationCheck();
    
//   }

//   static locationCheck() {
//     print("object2");

//     StreamSubscription<Position> positionStream =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position? position) {
//           print("object3"+position!.longitude.toString());    
//       if (Long.isEmpty) {
//         Long =
//             position == null ? 'Unknown' : position.longitude.toString();
//               Utils.langtitude=Long;
//       }

//       if (Lat.isEmpty) {
//         Lat = position == null ? 'Unknown' : position.latitude.toString();
//          Utils.latitude=Lat;
//       }
    
//       if (Long.toString() != position!.longitude.toString()) {
//         isChange = "Yes";
//         Long = position.longitude.toString();
//         Utils.langtitude=Long;
//       }
//       if (Lat.toString() != position.latitude.toString()) {
//         isChange = "Yes";

//         Lat = position.latitude.toString();
//         Utils.latitude=Lat;
//       }
//     });
//   }

 
// }

