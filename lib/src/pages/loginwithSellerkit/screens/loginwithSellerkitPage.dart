import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constans.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/controller/loginwithSellerkitController/loginwithSellerkitController.dart';

import 'package:sellerkitcalllog/src/pages/Login/Widgets/TermsAndConditions.dart';

class LoginwithSellerKit extends StatefulWidget {
  const LoginwithSellerKit({super.key});

  @override
  State<LoginwithSellerKit> createState() => _LoginwithSellerKitState();
}

class _LoginwithSellerKitState extends State<LoginwithSellerKit> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider<LoginwithSellerkitContoller>(
        create: (context) => LoginwithSellerkitContoller(context),
        builder: (context, child) {
          return Consumer<LoginwithSellerkitContoller>(
              builder: (BuildContext context, loginCnt, Widget? child) {
            return Scaffold(
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Utils.network == 'none'
                    ? NoInternet(network: Utils.network)
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom: Screens.bodyheight(context) * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            headertitle(context, theme),
                            loginbtn(loginCnt, context, theme),
                            termsandCondition(loginCnt, context, theme)
                          ],
                        ),
                      ),
              ),
            );
          });
        });
  }

  SizedBox termsandCondition(LoginwithSellerkitContoller loginCnt,
      BuildContext context, ThemeData theme) {
    return SizedBox(
      width: Screens.width(context),
      height: Screens.bodyheight(context) * 0.1,
      // color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            visualDensity:
                const VisualDensity(horizontal: -4.0, vertical: -4.0),
            value: loginCnt.TCbool,
            onChanged: (value) {
              setState(() {
                loginCnt.setTermsAConditionsValue(value);
                // _acceptTerms = value ?? false;
              });
            },
          ),
          Text(
            AppLocalizations.of(context)!.iaccept,
          ),
          InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsAndCondition()),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.termsandCondition,
              style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox headertitle(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: Screens.bodyheight(context) * 0.12,
      width: Screens.width(context) * 0.5,
      child: Text(
        AppLocalizations.of(context)!.sellerkitCaller_appname,
        textAlign: TextAlign.center,
        style:
            theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  GestureDetector loginbtn(LoginwithSellerkitContoller loginCnt,
      BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: (loginCnt.TCbool == false)
          ? null
          : () {
              setState(() {
                loginCnt.createlink();
              });
            },
      child: Container(
        height: Screens.bodyheight(context) * 0.07,
        width: Screens.width(context) * 0.6,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius:
                BorderRadius.circular(Screens.bodyheight(context) * 0.01)),
        child: loginCnt.createlinkload == true
            ? const Center(child: CircularProgressIndicator())
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      height: Screens.bodyheight(context) * 0.07,
                      width: Screens.width(context) * 0.07,
                      child: Image.asset(
                        Assets.sellerkit,
                      )),
                  Text(
                    AppLocalizations.of(context)!.login_with_sellerkit,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
      ),
    );
  }
}
