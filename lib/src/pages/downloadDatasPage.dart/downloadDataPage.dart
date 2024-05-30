import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/constans.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/src/controller/downLoadController/downloadController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:sellerkitcalllog/src/controller/DownLoadController/DownloadController.dart';
class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkInternetConnectivity();
      context.read<DownLoadController>().setURL();
      // context.read<DownLoadController>().createDB().then((value) {
      // context.read<DownLoadController>().getDefaultValues().then((value) {
      context.read<DownLoadController>().callApiNew(context);
      //  context.read<NotificationContoller>().getUnSeenNotify();
      // });
      // });
    });
  }

  bool? isNetwork1 = false;

  checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (this.mounted) {
        setState(() {
          isNetwork1 = false;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          isNetwork1 = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: Screens.width(context),
        height: Screens.bodyheight(context),
        padding: EdgeInsets.symmetric(
            horizontal: Screens.width(context) * 0.03,
            vertical: Screens.bodyheight(context) * 0.02),
        child: isNetwork1 == false
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: Screens.width(context),
                      //color: Colors.red,
                      padding: EdgeInsets.symmetric(
                          horizontal: Screens.width(context) * 0.03),
                      child: Text(
                        AppLocalizations.of(context)!.loadingInialData,
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )),
                  Lottie.asset(Assets.loadSettings,
                      animate: true,
                      repeat: true,
                      height: Screens.padingHeight(context) * 0.2,
                      width: Screens.width(context) * 0.2),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Screens.width(context) * 0.3),
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                      )),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.01,
                  ),
                ],
              ),
      ),
    ));
  }
}
