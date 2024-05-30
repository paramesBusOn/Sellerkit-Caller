import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/controller/configurationController/configurationController.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {});
      // checkInternetConnectivity();
    });
  }

  // bool? isNetwork1 = false;

  // checkInternetConnectivity() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     setState(() {
  //       isNetwork1 = false;
  //     });
  //   } else {
  //     setState(() {
  //       isNetwork1 = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider<ConfigurationController>(
        create: (context) => ConfigurationController(context),
        builder: (context, child) {
          return Consumer<ConfigurationController>(
              builder: (BuildContext context, loginCnt, Widget? child) {
            return Scaffold(
              body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Utils.network == 'none'
                    ? NoInternet(network: Utils.network)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          });
        });
  }
}
