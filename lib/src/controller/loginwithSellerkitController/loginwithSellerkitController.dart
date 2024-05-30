// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../helpers/Configuration.dart';
import '../../api/dynamicLinkApi/dynamicLinkCreateApi.dart';

class LoginwithSellerkitContoller extends ChangeNotifier {
  bool? createlinkload = false;
  bool? TCbool = false;
  LoginwithSellerkitContoller(BuildContext context) {
    // createlink();
  }
  Config config = Config();
//
  createlink() async {
    createlinkload = true;
    String? dynamicfundLink = '';
    String? fcmTken = await config.getToken();
    await DynamicLinkCreateApi.getDynamicLinkCreateApiData(fcmTken)
        .then((value) {
      dynamicfundLink = value.dynamiclinkData!.shortlink;
    });
    // String? token = await config.getToken();
    // String? dynamicfundLink = 'https://sellerkitcaller.page.link/';
    // await dHelper.createDYLinkFundTrnsPage('');
    if (dynamicfundLink!.isNotEmpty) {
      createlinkload = false;
      Utils.token = '';
      await HelperFunctions.saveTokenSharedPreference('');

      if (!await launchUrl(Uri.parse(dynamicfundLink!),
          mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $dynamicfundLink';
      }
    } else {
      createlinkload = false;
    }

    // Share.share(temp);
    notifyListeners();
  }

  

  setTermsAConditionsValue(bool? val) {
    print(val);

    TCbool = (TCbool! == true) ? false : val;
    notifyListeners();
  }
}
