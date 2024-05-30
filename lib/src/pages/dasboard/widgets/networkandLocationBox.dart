// ignore_for_file: avoid_unnecessary_containers, unnecessary_string_interpolations, camel_case_types, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/main.dart';

import '../../../../helpers/nativeCode-java-swift/methodchannel.dart';
import '../../../../helpers/screen.dart';
import '../../../api/googleAddresGetApi.dart/googleAddressGetApi.dart';

class setupAlerbox extends StatefulWidget {
  const setupAlerbox({Key? key,}) : super(key: key);
  // String address;
  @override
  State<setupAlerbox> createState() => _setupAlerboxState();
}

class _setupAlerboxState extends State<setupAlerbox> {
  String address = '';

  @override
  void initState() {
    super.initState();
    getAddress();
    // print(_controller);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future getAddress() async {
    // List<String>? wifiiInfo = await config.setNetwork();

    setState(() {
      Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        // Got a new connectivity status!
        if (result.name == 'none') {
          Utils.ipaddress = '';
          Utils.ipname = '';
        } else if (result.name == 'mobile') {
          if (Platform.isAndroid) {
            final MobileNetworkInfo mobileNetworkInfo = MobileNetworkInfo();
            final String name = await Config.getipaddress();

            // List<String>? wifiiInfo = await config.setNetwork();
            //
            final String? data = await mobileNetworkInfo.getMobileNetworkName();
            //
            Utils.ipaddress = name == null ? 'null' : name;
            Utils.ipname = data == null ? 'null' : data;
          } else if (Platform.isIOS) {
            List<String>? wifiiInfo = await config.getIosNetworkInfo();
            Utils.ipaddress = wifiiInfo[1];
            Utils.ipname = wifiiInfo[0];
          }
        }
       
        else if (result.name == 'wifi') {
          List<String>? wifiiInfo = await config.setNetwork();
          Utils.ipaddress = wifiiInfo[1];
          Utils.ipname = wifiiInfo[0];
        }
      });
      // await LocationTrack.checkcamlocation();
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      await GetgoogleAddressApi.getData(
              Utils.latitude.toString(), Utils.langtitude.toString())
          .then((value) {

        if (200 >= value.stcode! && value.stcode! <= 210) {
          setState(() {
            address = value.results[1].formattedAddress;
          });
        } else {
        }
      });
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target:
        LatLng(double.parse(Utils.latitude!), double.parse(Utils.langtitude!)),
    zoom: 14.7,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        // height: Screens.bodyheight(context) * 0.4,
        width: Screens.width(context) * 0.65,
        padding: EdgeInsets.all(Screens.bodyheight(context) * 0.01),
        // ignore: sort_child_properties_last
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Screens.width(context) * 0.2,
                  // color: Colors.amber,
                  child: Text(
                    'Lat',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: Screens.width(context) * 0.3,
                  // color: Colors.amber,
                  child: Text('${Utils.latitude}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
                double.parse(Utils.latitude.toString()) > 0
                    ? Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: Screens.bodyheight(context) * 0.001,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Screens.width(context) * 0.2,
                  // color: Colors.amber,
                  child: Text(
                    'Long',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: Screens.width(context) * 0.3,
                  // color: Colors.amber,
                  child: Text('${Utils.langtitude}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
                double.parse(Utils.langtitude.toString()) > 0
                    ? Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: Screens.bodyheight(context) * 0.001,
            ),
            Stack(
              children: [
                SizedBox(
                  height: Screens.bodyheight(context) * 0.2,
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: Screens.bodyheight(context) * 0.2,
                  // child: GoogleMap(
                  //   mapType: MapType.normal,
                  //   myLocationEnabled: true,
                  //   initialCameraPosition: _kGooglePlex,
                  //   onMapCreated: (GoogleMapController controller) {
                  //     _controller.complete(controller);
                  //   },
                  // ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  // alignment: Alignment.centerLeft,
                  width: Screens.width(context) * 0.6,
                  // color: Colors.amber,
                  child: Text('${address}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Screens.width(context) * 0.2,
                  // color: Colors.amber,
                  child: Text(
                    'Network',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: Screens.width(context) * 0.3,
                  // color: Colors.amber,
                  child: Text('${Utils.ipname}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
                Utils.ipname.toString() != '' &&
                        Utils.ipname.toString() != 'null'
                    ? Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: Screens.bodyheight(context) * 0.001,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Screens.width(context) * 0.2,
                  // color: Colors.amber,
                  child: Text(
                    'IP',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: Screens.width(context) * 0.3,
                  // color: Colors.amber,
                  child: Text('${Utils.ipaddress}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
                Utils.ipaddress.toString() != '' &&
                        Utils.ipaddress.toString() != 'null' &&
                        Utils.ipaddress.toString() != '0'
                    ? Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        // width: Screens.width(context)*0.1,
                        // color: Colors.amber,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
          ],
        ),
        margin: EdgeInsets.only(top: Screens.bodyheight(context) * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
