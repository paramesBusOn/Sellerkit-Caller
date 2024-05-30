import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/onBoardApi/onBoardApi.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<onBoardData> onboarddata = [];
  bool isloaing = false;
  void initState() {
    super.initState();
    setState(() {
      onboarddata.clear();
      isloaing = false;
      callApi();
    });
  }

  callApi() async {
    setState(() {
      isloaing = false;
    });
    String meth = ConstantApiUrl.onboardScreenApi!;
    await OnBoardApi.getData(meth).then((value) {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.itemdata != null) {
          final stopwatch = Stopwatch()..start();

          setState(() {
            onboarddata = value.itemdata!;
            log("message" + onboarddata.length.toString());
            isloaing = true;
          });

          stopwatch.stop();
          log('API EnquiryType ${stopwatch.elapsedMilliseconds} milliseconds');
        } else if (value.itemdata == null) {
          setState(() {
            isloaing = true;
          });
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        setState(() {
          isloaing = true;
        });
      } else if (value.stcode == 500) {
        setState(() {
          isloaing = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: isloaing == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isloaing == true && onboarddata.isNotEmpty
              ? SizedBox(
                  width: Screens.width(context),
                  height: Screens.padingHeight(context),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Screens.padingHeight(context),
                        width: Screens.width(context),
                        child: IntroductionScreen(
                          onSkip: () => gotoHome(context),
                          done: Text(
                            AppLocalizations.of(context)!.done_name,
                            style: theme.textTheme.bodyMedium,
                          ),
                          onDone: () => gotoHome(context),
                          next: Icon(
                            Icons.arrow_forward,
                            color: theme.primaryColor,
                          ),
                          showSkipButton: true,
                          skip: Text(
                            AppLocalizations.of(context)!.skip_name,
                            style: theme.textTheme.bodyMedium,
                          ),
                          dotsDecorator: dotsDecorations(theme),
                          // globalBackgroundColor: theme.primaryColor,
                          isProgressTap: false,
                          freeze: false,
                          rawPages: [
                            for (int i = 0; i < onboarddata.length; i++)
                              buildrawpage(context, i),
                          ],
                          // pages: [
                          //   PageViewModel(
                          //     title: "Great Sales App",
                          //     body: "we have a 100k++ products choose your product from our Store",
                          //     image: firstImage('Assets/boarding_1.png'),
                          //     decoration: getPageDecoration(theme),
                          //   ),
                          //   PageViewModel(
                          //     title: "Online Payment",
                          //     body:
                          //         "Easy checkout & Safe payment method trused by our customers from all over the world",
                          //     image: firstImage('Assets/boarding_2.png'),
                          //     decoration: getPageDecoration(theme),
                          //   ),
                          //   PageViewModel(
                          //     title: "Customer Services",
                          //     body:
                          //         "To make it easier for you to shop we provide customer service if you have any questions",
                          //     image: firstImage('Assets/boarding_3.png'),
                          //     decoration: getPageDecoration(theme),
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  ),
                )
              : IntroductionScreen(
                  onSkip: () => gotoHome(context),
                  done: Text(
                    AppLocalizations.of(context)!.done_name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  onDone: () => gotoHome(context),
                  next: Icon(
                    Icons.arrow_forward,
                    color: theme.primaryColor,
                  ),
                  showSkipButton: true,
                  skip: Text(
                    AppLocalizations.of(context)!.skip_name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  dotsDecorator: dotsDecorations(theme),
                  // globalBackgroundColor: theme.primaryColor,
                  isProgressTap: false,
                  freeze: false,
                  // rawPages: [
                  //   for (int i = 0; i < onboarddata.length; i++)
                  //     buildrawpage(context, i),
                  // ],
                  pages: [
                    PageViewModel(
                      title: "Great Sales App",
                      body:
                          "we have a 100k++ products choose your product from our Store",
                      image: firstImage('Assets/boarding_1.png'),
                      decoration: getPageDecoration(theme),
                    ),
                    PageViewModel(
                      title: "Online Payment",
                      body:
                          "Easy checkout & Safe payment method trused by our customers from all over the world",
                      image: firstImage('Assets/boarding_2.png'),
                      decoration: getPageDecoration(theme),
                    ),
                    PageViewModel(
                      title: "Customer Services",
                      body:
                          "To make it easier for you to shop we provide customer service if you have any questions",
                      image: firstImage('Assets/boarding_3.png'),
                      decoration: getPageDecoration(theme),
                    ),
                  ],
                ),
    );
  }

  Widget buildrawpage(BuildContext context, int ind) {
    return SizedBox(
      height: Screens.padingHeight(context),
      width: Screens.width(context),
      // color:Colors.red,
      child: firstImagelist(onboarddata[ind].urL1.toString()),
    );
  }

  Widget firstImage(String path) => Center(
        child: Image.asset(
          path,
          width: Screens.padingHeight(context) * 0.5,
        ),
      );

  Widget firstImagelist(String path) => Image.network(
        path,
        fit: BoxFit.fill,
      );

//image deco
  PageDecoration getPageDecoration(ThemeData theme) => PageDecoration(
      titleTextStyle:
          theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
      bodyTextStyle:
          theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w300),
      imagePadding: EdgeInsets.only(top: Screens.padingHeight(context) * 0.1),
      titlePadding: EdgeInsets.only(top: Screens.padingHeight(context) * 0.1),
      bodyPadding: EdgeInsets.only(top: Screens.padingHeight(context) * 0.05),
      pageColor: Colors.white);

  //

  void gotoHome(Context) async {
    await HelperFunctions.saveOnBoardSharedPreference(true);
    await HelperFunctions.getOnBoardSharedPreference().then((value) {
      log("onboard: $value");
    });
    Get.offAllNamed(ConstantRoutes.splash);
  }
//  Navigator.of(context).pushReplacement(
//   // MaterialPageRoute(builder: (_)=>SplashScreen())
//  );

  //
  DotsDecorator dotsDecorations(ThemeData theme) => DotsDecorator(
      color: Colors.grey, //theme.primaryColor.withOpacity(0.1),
      size: const Size(10, 10),
      activeSize: const Size(20, 10),
      activeColor: theme.primaryColor,
      activeShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)));
}
