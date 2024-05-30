import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantValidate.dart';
import 'package:sellerkitcalllog/helpers/padings.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/Widgets/custom_shake_transtition.dart';
import 'package:sellerkitcalllog/src/controller/LoginController/LoginController.dart';
import 'package:sellerkitcalllog/src/pages/Login/Widgets/TermsAndConditions.dart';
import 'package:sellerkitcalllog/src/widgets/custom_text_form_field.dart';
import '../../splash/widgets/custom_elevatedBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Paddings constant = Paddings();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: ChangeNotifierProvider<LoginController>(
            create: (context) => LoginController(context),
            builder: (context, child) {
              return Consumer<LoginController>(
                  builder: (BuildContext context, prdlog, Widget? child) {
                return SizedBox(
                  width: Screens.width(context),
                  height: Screens.fullHeight(context),
                  child:Utils.network=='none'?NoInternet(network:Utils.network ) : Stack(
                    children: [
                      header(context, theme),
                      Positioned(
                          top: Screens.padingHeight(context) * 0.3,
                          child: Container(
                            width: Screens.width(context),
                            height: Screens.padingHeight(context) * 0.7,
                            decoration: const BoxDecoration(
                                //color: Colors.red,
                                //borderRadius: BorderRadius.only(bottomLeft:Radius.circular( Screens.width(context)*0.2))
                                ),
                            padding: EdgeInsets.symmetric(
                                vertical: Screens.padingHeight(context) * 0.05,
                                horizontal: Screens.width(context) * 0.05),
                            child: Form(
                              key: prdlog.formkey,
                              child: Column(
                                children: [
                                  errorMethod(prdlog, context, theme),
                                  body(prdlog, theme, context),
                                  // InkWell(
                                  //     onTap: () {
                                  //       LoginController.loginPageScrn = true;
                                  //       // ForgotPasswordController.loginscrn = true;
                                  //       // print("LoginController.loginpage:${LoginController.loginPageScrn}");
                                  //       Get.toNamed(ConstantRoutes.forgotregister);
                                  //     },
                                  //     child: Text("Forgot password?")),

                                  footer(context, prdlog, theme),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              });
            }));
  }

  Visibility errorMethod(
      LoginController prdlog, BuildContext context, ThemeData theme) {
    return Visibility(
      visible: prdlog.geterroMsgVisble,
      child: Container(
        alignment: Alignment.center,
        width: Screens.width(context),
        child: Column(
          children: [
            Text(
              prdlog.errorMsh,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
              maxLines: 4,
            ),
            SizedBox(
              height: Screens.bodyheight(context) * 0.02,
            )
          ],
        ),
      ),
    );
  }

  Row footer(BuildContext context, LoginController prdlog, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
            onTap: () async {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        contentPadding: const EdgeInsets.all(0),
                        insetPadding:
                            EdgeInsets.all(Screens.bodyheight(context) * 0.02),
                        content: settings(context, prdlog));
                  });
            },
            child: SizedBox(
                //color: Colors.amber,
                width: Screens.width(context) * 0.1,
                child: Icon(
                  Icons.settings,
                  color: theme.primaryColor,
                ))),
        Text(
          Utils.appversion.isEmpty ? Utils.defaultversion : Utils.appversion,
          // 'V 1.0.8',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Column body(LoginController prdlog, ThemeData theme, BuildContext context) {
    CustomValidator custoevalidate = CustomValidator(context);
    return Column(
      children: [
        CustomShakeTransition(
          duration: const Duration(milliseconds: 900),
          child: SizedBox(
            child: CustomTextform(
              controller: prdlog.mycontroller[0],
              keyboardType: TextInputType.text,
              style: theme.textTheme.bodyMedium,
              validator: custoevalidate.validateNormal,
              contentpading: ContentPadingType.type2,
              fillColor: Colors.grey[200],
              filled: true,
              prefixIcon: const Icon(
                Icons.account_circle_outlined,
                size: 25,
              ),
              labelText: AppLocalizations.of(context)!.username,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                ),
              ),
              focusborder: FocusBorderType.type7,
              enableborder: EnableBorderType.type7,
              errorborder: ErrorBorderType.type3,
              focusErrorborderType: FocusErrorBorderType.type4,

              // ),
            ),
          ),
        ),
        SizedBox(
          height: Screens.padingHeight(context) * 0.03,
        ),
        CustomShakeTransition(
          duration: const Duration(milliseconds: 900),
          child: SizedBox(
            child: CustomTextform(
              controller: prdlog.mycontroller[1],
              validator: custoevalidate.validateNormal,
              obscureText: prdlog.getHidepassword,
              style: theme.textTheme.bodyMedium,
              // decoration: InputDecoration(
              contentpading: ContentPadingType.type2,
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                ),
              ),
              prefixIcon: const Icon(
                Icons.lock_outlined,
                size: 25,
              ),
              suffixIcon: IconButton(
                icon: prdlog.getHidepassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  prdlog.obsecure();
                },
              ),
              labelText: AppLocalizations.of(context)!.password,

              focusborder: FocusBorderType.type7,
              enableborder: EnableBorderType.type7,
              errorborder: ErrorBorderType.type4,
              focusErrorborderType: FocusErrorBorderType.type4,

              // ),
            ),
          ),
        ),
        SizedBox(
          height: Screens.padingHeight(context) * 0.01,
        ),
        SizedBox(
          width: Screens.width(context),
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -4.0),
                value: prdlog.TCbool,
                onChanged: (value) {
                  setState(() {
                    prdlog.setTermsAConditionsValue(value);
                    // _acceptTerms = value ?? false;
                  });
                },
              ),
              Text(AppLocalizations.of(context)!.iaccept),
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
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Screens.padingHeight(context) * 0.01,
        ),
        prdlog.TCbool == false
            ? CustomSpinkitdButton(
                color: Colors.grey[300],
                onTap: () {
                  // setState(() {
                  //  prdlog.erroMsgVisble=true;
                  //  prdlog.errorMsh=''
                  // });
                },
                isLoading: prdlog.isLoading,
                label: AppLocalizations.of(context)!.login_name,
                labelLoading: AppLocalizations.of(context)!.login_name,
                textcolor: Colors.grey,
                // labelLoading: AppLocalizations.of(context)!.signing,
                // label: AppLocalizations.of(context)!.sign_in,
              )
            : CustomSpinkitdButton(
                // color: Colors.grey[300],
                onTap:
                    prdlog.getsettingError == true || prdlog.isLoading == true
                        ? null
                        : () async {
                            prdlog.validateLogin(context);
                            // prdlog.testApi();
                          },
                isLoading: prdlog.isLoading,
                label: AppLocalizations.of(context)!.login_name,
                labelLoading: AppLocalizations.of(context)!.login_name,
                textcolor: Colors.white,
                // labelLoading: AppLocalizations.of(context)!.signing,
                // label: AppLocalizations.of(context)!.sign_in,
              ),
        SizedBox(
          height: Screens.padingHeight(context) * 0.06,
        ),
      ],
    );
  }

  Container header(BuildContext context, ThemeData theme) {
    return Container(
      width: Screens.width(context),
      height: Screens.padingHeight(context) * 0.3,
      decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Screens.width(context) * 0.2))),
      padding: EdgeInsets.symmetric(
          vertical: Screens.padingHeight(context) * 0.1,
          horizontal: Screens.width(context) * 0.1),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.login_name,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }

  locateAlert() {
    return StatefulBuilder(builder: (context, st) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Screens.width(context),
            height: Screens.padingHeight(context) * 0.05,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(08),
                    topLeft: Radius.circular(08),
                  ),
                )),
                child: Text(AppLocalizations.of(context)!.alert)),
          ),
          Container(
            padding: EdgeInsets.only(
              left: Screens.width(context) * 0.05,
              right: Screens.width(context) * 0.05,
              top: Screens.bodyheight(context) * 0.02,
              bottom: Screens.bodyheight(context) * 0.01,
            ),
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.locationAlert,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    });
  }

  settings(BuildContext context, LoginController logCon) {
    final theme = Theme.of(context);
    return StatefulBuilder(builder: (context, st) {
      return Container(
        padding: EdgeInsets.only(
            top: Screens.padingHeight(context) * 0.01,
            left: Screens.width(context) * 0.03,
            right: Screens.width(context) * 0.03,
            bottom: Screens.padingHeight(context) * 0.01),
        width: Screens.width(context) * 1.1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Screens.width(context),
                height: Screens.padingHeight(context) * 0.05,
                color: theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: Screens.padingHeight(context) * 0.02,
                          right: Screens.padingHeight(context) * 0.02),
                      // color: Colors.red,
                      width: Screens.width(context) * 0.7,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.configure_name,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: Screens.padingHeight(context) * 0.025,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Screens.bodyheight(context) * 0.01,
              ),
              Form(
                key: logCon.formkey2,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.grey.withOpacity(0.001),
                      ),
                      child: CustomTextform(
                        autofocus: true,
                        controller: logCon.mycontroller[3],
                        cursorColor: Colors.grey,
                        //keyboardType: TextInputType.number,
                        onChanged: (v) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .enterCustomerId;
                          } else {
                            return null;
                          }
                        },
                        errorborder: ErrorBorderType.type4,
                        focusErrorborderType: FocusErrorBorderType.type4,
                        enableborder: EnableBorderType.type8,
                        focusborder: FocusBorderType.type8,
                        hintText: AppLocalizations.of(context)!.customerId_name,
                        hintStyle: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey),
                        filled: false,
                        contentpading: ContentPadingType.type10,
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.01,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: logCon.progrestext == true
                    ? null
                    : () {
                        st(() {
                          logCon.settingvalidate(context);
                        });
                      },
                child: Container(
                  alignment: Alignment.center,
                  height: Screens.padingHeight(context) * 0.045,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                  ),
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: logCon.progrestext == true
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              AppLocalizations.of(context)!.ok_btn,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
