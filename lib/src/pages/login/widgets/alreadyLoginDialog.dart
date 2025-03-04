// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, unused_local_variable, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable, use_build_context_synchronously, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/helpers/constantApiUrl.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/helper.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/src/api/LoginVerificationApi/LoginVerificationApi.dart';
import 'package:sellerkitcalllog/src/api/loginApi/loginApiNew.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlreadyLoginDialogbox extends StatefulWidget {
  AlreadyLoginDialogbox(
      {Key? key,
      required this.errormsg,
      required this.msg,
      required this.customerId,
      required this.userCode,
      required this.password})
      : super(key: key);
  String? msg;
  String? errormsg;
  String? customerId;
  String? userCode;
  String? password;

  @override
  State<AlreadyLoginDialogbox> createState() => ShowSearchDialogState();
}

class ShowSearchDialogState extends State<AlreadyLoginDialogbox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmesg();
  }

  getmesg() {
    log("widget.msg::" + widget.msg.toString());
    if (widget.msg!.isNotEmpty) {
      setState(() {
        loginmessage = widget.msg.toString();
      });
    } else {
      setState(() {
        loginmessage = widget.errormsg.toString();
      });
    }
  }

  bool? progress = false;
  validate() async {
    setState(() {
      progress = true;
    });
    String? fcm2 = await HelperFunctions.getFCMTokenSharedPreference();
    String? deviceID = await HelperFunctions.getDeviceIDSharedPreference();
    String? passsword = await HelperFunctions.getPasswordSharedPreference();
    if (deviceID == null) {
      deviceID = await Config.getdeviceId();
      print("deviceID" + deviceID.toString());
      await HelperFunctions.saveDeviceIDSharedPreference(deviceID!);
    }

    LoginVerfiReqbody reqBody = LoginVerfiReqbody();
    reqBody.fcmCode = fcm2;
    reqBody.deviceCode = deviceID;
    reqBody.password = widget.password;
    reqBody.userCode = widget.userCode;
    reqBody.tenantId = widget.customerId;
    reqBody.logoutTypeId = 2;
    LoginVerificationApi.getData(ConstantApiUrl.loginVerificationApi, reqBody)
        .then((value) async {
      if (value.stcode! >= 200 && value.stcode! <= 210) {
        if (value.status == true) {
          Navigator.pop(context);
          validateFinal(context);
        } else {
          setState(() {
            progress = false;
            Navigator.pop(context);
          });
          await showDialog<dynamic>(
              context: context,
              builder: (_) {
                return AlreadyLoginDialogbox(
                  errormsg:
                      '${value.message} ${value.stcode} ${value.datalist!.devicename}',
                  msg: '',
                  customerId: widget.customerId,
                  userCode: '${widget.userCode}',
                  password: '${widget.password}',
                );
              });
        }
      } else if (value.stcode! >= 400 && value.stcode! <= 410) {
        setState(() {
          progress = false;
          Navigator.pop(context);
        });
        await showDialog<dynamic>(
            context: context,
            builder: (_) {
              return AlreadyLoginDialogbox(
                  errormsg: '${value.message} ${value.stcode}',
                  msg: '',
                  customerId: widget.customerId,
                  userCode: '${widget.userCode}',
                  password: '${widget.password}');
            });
      } else {
        setState(() {
          progress = false;
          Navigator.pop(context);
        });
        await showDialog<dynamic>(
            context: context,
            builder: (_) {
              return AlreadyLoginDialogbox(
                  errormsg: '${value.exception} ${value.stcode}',
                  msg: '',
                  customerId: widget.customerId,
                  userCode: '${widget.userCode}',
                  password: '${widget.password}');
            });
      }
    });
  }

  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  validateFinal(BuildContext context) async {
    //**** */
    //  await config.getSetup();

    //Get URL APi

    //Get Url Api

    //**** */
    log("is is is ");
    PostLoginData postLoginData = new PostLoginData();

    postLoginData.deviceCode =
        await HelperFunctions.getDeviceIDSharedPreference();
    postLoginData.licenseKey =
        await HelperFunctions.getLicenseKeySharedPreference();
    postLoginData.fcmToken =
        await HelperFunctions.getFCMTokenSharedPreference();
    // log("fcmmmm: "+postLoginData.fcmToken.toString());
    postLoginData.username = widget.userCode;
    postLoginData.password = '${widget.password}';
    Utils.tenetID = widget.customerId;
    String? model = await Config.getdeviceModel();
    String? brand = await Config.getdeviceBrand();
    postLoginData.devicename = '${brand} ${model}';
    String meth = ConstantApiUrl.loginapi;

    await LoginPostApi.getData(postLoginData, meth).then((value) async {
      if (value.resCode! >= 200 && value.resCode! <= 200) {
        if (value.loginstatus!.toLowerCase().contains('success') &&
            value.data != null) {
          setState(() {
            // DashBoardController.isLogout = false;
            widget.errormsg = '';
            Utils.userNamePM = widget.userCode;
          });

          await HelperFunctions.saveUserName(value.data!.userCode.toString());
          await HelperFunctions.saveFSTNameSharedPreference(
              value.data!.urlColumn);

          await HelperFunctions.saveLicenseKeySharedPreference(
              value.data!.licenseKey);
          await HelperFunctions.saveLogginUserCodeSharedPreference(
              widget.userCode.toString());
          // await HelperFunctions.saveSapUrlSharedPreference(
          //     value.data!.endPointUrl);
          await HelperFunctions.saveTenetIDSharedPreference(
              value.data!.tenantId);
          await HelperFunctions.saveUserIDSharedPreference(value.data!.UserID);
          Utils.userId = value.data!.UserID;
          Utils.usercode = value.data!.userCode;

          Utils.storeid = int.parse(value.data!.storeid.toString());
          Utils.storecode = value.data!.storecode.toString();
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.savePasswordSharedPreference(
              '${widget.password}');
          await HelperFunctions.getFSTNameSharedPreference().then((value) {
            if (value != null) {
              Utils.firstName = value;
            }
          });
          log("message");
          // await HelperFunctions.saveuserDB(value.data!.userDB);
          await HelperFunctions.savedbUserName(value.data!.UserID);
          // await HelperFunctions.savedbPassword(value.data!.dbPassword);

          await HelperFunctions.saveUserType(value.data!.userType);
          await HelperFunctions.saveSlpCode(value.data!.slpcode);
          Get.offAllNamed(ConstantRoutes.download);
        } else if (value.loginstatus!.toLowerCase().contains("failed") &&
            value.data == null) {
          setState(() {
            widget.errormsg = '${value.loginMsg!} ${value.resCode!}';
          });
        }
      } else if (value.resCode! >= 400 && value.resCode! <= 410) {
        setState(() {
          widget.errormsg = value.excep!;
        });
      } else {
        if (value.excep == 'No route to host') {
          setState(() {
            widget.errormsg = 'Check your Internet Connection...!!';
          });
        } else {
          setState(() {
            widget.errormsg =
                '${value.resCode!}..!!Network Issue..\nTry again Later..!!';
          });
        }
      }
    });
  }

  String? loginmessage = '';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: Container(
        width: Screens.width(context),
        // height: Screens.bodyheight(context) * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            progress == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: Screens.width(context) * 0.55,
                              // color: Colors.amber,
                              child: Text(
                                "${loginmessage}",
                                style: widget.errormsg!.isNotEmpty
                                    ? theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.redAccent)
                                    : theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.green),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: Screens.bodyheight(context) * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Screens.width(context) * 0.3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                ),
                                onPressed: widget.msg!.isNotEmpty
                                    ? () async {
                                        validate();
                                      }
                                    : () {
                                        Navigator.pop(context);
                                        // Get.offAllNamed(ConstantRoutes.login);
                                      },
                                child: widget.msg!.isNotEmpty
                                    ? Text(AppLocalizations.of(context)!
                                        .logout_btn)
                                    : Text(AppLocalizations.of(context)!
                                        .close_btn)),
                          ),
                          // Container(
                          //   width: Screens.width(context) * 0.3,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: theme.primaryColor,
                          //       ),
                          //       onPressed: widget.msg!.isNotEmpty
                          //           ? () async {
                          //               validate();
                          //             }
                          //           : () {
                          //               Navigator.pop(context);
                          //               // Get.offAllNamed(ConstantRoutes.login);
                          //             },
                          //       child: widget.msg!.isNotEmpty
                          //           ? Text('Logout')
                          //           : Text('Close')),
                          // ),
                        ],
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
