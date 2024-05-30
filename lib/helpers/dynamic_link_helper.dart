
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DynamicLinkHelper {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks(
      Function(PendingDynamicLinkData openLink) dataObj) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      dataObj(dynamicLinkData);
    }).onError((error) {
    });
  }

  Future<String> createDYLinkFundTrnsPage(String fundId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://sellerkitcaller.page.link',
      link: Uri.parse("https://sellerkitcaller.page.link/callerId?fundId=$fundId"),
      androidParameters: const AndroidParameters(
        packageName: 'com.busondigitalservice.sellerkit',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.busondigitalservice.sellerkit',
        minimumVersion: '1',
      ),
    );

    Uri url;

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    return url.toString();
    // Share.share(url.toString());
  }

  void iniNavigateLink() async {
    final PendingDynamicLinkData? initialLink2 =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink2 != null) {
      // final Uri refeLink = initialLink2.link;
    }
  }

  static Future<void> receiveFundIdLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((event) async {
      //Get.toNamed(RoutesName.dashboard);

      if (event.link.toString().contains('callerId')) {

        // TabfundPageState.linkFundid = fundId;
        // await context.read<FunRsPCont>().restetAll();
        // if (fundId != '') {

        //   await Future.delayed(Duration(seconds: 2));
        //   FundByPidm? post =
        //       await context.read<FunRsPCont>().getListDetails(fundId);
        //   if (post != null) {
        //     context
        //         .read<FunRsPCont>()
        //         .gotoFPDetailsPage(post, post.isActive)
        //         ;
        //   }
        // }

        // Get.toNamed(RoutesName.fundRaising);
      }
    });
  }
}
