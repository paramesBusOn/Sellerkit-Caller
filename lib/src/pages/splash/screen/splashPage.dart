import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constans.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/nativeCode-java-swift/methodchannel.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/Widgets/LottieContainer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sellerkitcalllog/src/controller/splashController/splashController.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);
  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        checkInternetConnectivity();
        // Get.offAllNamed(ConstantRoutes.download);
        context.read<SplashController>().checkBeforeLoginApi(context);
      });
    });
  }

  bool? isNetwork1 = false;

  checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isNetwork1 = false;
      });
    } else {
      setState(() {
        isNetwork1 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            width: Screens.width(context),
            height: Screens.padingHeight(context),
            padding: const EdgeInsets.all(1),
            child: (Utils.network == 'none'||context.read<SplashController>().exceptionOnApiCall.contains('Internet'))
                    ? NoInternet(network: Utils.network)
                    : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(),
                        Container(
                          alignment: Alignment.center,
                          width: Screens.width(context),
                          //  height: Screens.padingHeight(context) * 0.3,
                          //  color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: Screens.width(context) * 0.4,
                                  height: Screens.padingHeight(context) * 0.2,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage(Assets.sellerkitCallerlogo),
                                    fit: BoxFit.fill,
                                  ))),
                              SizedBox(
                                height: Screens.padingHeight(context) * 0.02,
                              ),
                              Container(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .sellerkitCrm_name,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: Screens.padingHeight(context) * 0.03,
                              ),
                              (context.watch<SplashController>().isLoading ==
                                          true &&
                                      context
                                              .watch<SplashController>()
                                              .getexceptionOnApiCall ==
                                          '')
                                  ? SizedBox(
                                      width: Screens.width(context) * 0.5,
                                      // color: Colors.red,
                                      child: LinearProgressIndicator(
                                        color: theme.primaryColor,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                            width: Screens.width(context) * 0.3,
                                            //  color: Colors.red,
                                            child: context
                                                        .watch<
                                                            SplashController>()
                                                        .getexceptionOnApiCall ==
                                                    AppLocalizations.of(
                                                            context)!
                                                        .checkInternetConnectivity
                                                ? LottieContainer(
                                                    file: Assets.loginDisconect,
                                                    height:
                                                        Screens.padingHeight(
                                                                context) *
                                                            0.2,
                                                    width:
                                                        Screens.width(context) *
                                                            0.2,
                                                  )
                                                : LottieContainer(
                                                    file:
                                                        //"Assets/91069-like.json",
                                                        Assets.userDenied,
                                                    height:
                                                        Screens.padingHeight(
                                                                context) *
                                                            0.2,
                                                    width:
                                                        Screens.width(context) *
                                                            0.2,
                                                  )),
                                        Container(
                                          width: Screens.width(context),
                                          alignment: Alignment.center,
                                          child: Text(
                                            context
                                                .watch<SplashController>()
                                                .getexceptionOnApiCall,
                                            maxLines: 3,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              Screens.padingHeight(context) *
                                                  0.02,
                                        ),
                                        SizedBox(
                                            width: Screens.width(context) * 0.8,
                                            child: InkWell(
                                              onTap: () async {
                                                bool result =
                                                    await GetAppAvailabilityStatus
                                                        .isAppInstalled(
                                                            'com.busondigitalservice.sellerkit');
                                                if (result == true) {
                                                  Get.offAllNamed(ConstantRoutes
                                                      .loginwithSellerkit);
                                                } else {
                                                  Get.offAllNamed(
                                                      ConstantRoutes.login);
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .clickHeretoGo,
                                                    style: theme
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                                  )),
                                                  Container(
                                                      child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .login_name,
                                                    style: theme
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            color: theme
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  )),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Screens.padingHeight(context) * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: Screens.padingHeight(context) * 0.01),
                          child: SizedBox(
                            width: Screens.width(context),
                            // height: Screens.padingHeight(context) * 0.05,

                            //  color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.appversion),
                                SizedBox(
                                  width: Screens.width(context) * 0.02,
                                ),
                                Text(Utils.appversion),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Screens.padingHeight(context) * 0.002,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: Screens.padingHeight(context) * 0.01),
                          child: SizedBox(
                            width: Screens.width(context),
                            // height: Screens.padingHeight(context) * 0.05,

                            //  color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.apiversion),
                                SizedBox(
                                  width: Screens.width(context) * 0.02,
                                ),
                                Text(Utils.apIversion),
                              ],
                            ),
                          ),
                        ),
                      ]),
          ),
        ));
  }
}
