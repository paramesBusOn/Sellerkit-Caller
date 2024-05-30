import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/constantRoutes.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:sellerkitcalllog/src/controller/dashboardController/dashboardController.dart';
import 'package:sellerkitcalllog/src/pages/splash/widgets/custom_elevatedBtn.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/pages/dasboard/widgets/pdfView.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../main.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.title});

  final String title;

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  late String mobileno = '';
  late String screen = '';
  static String test = '';
  // dynamic data;
  Timer? timer;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Paddings paddings = Paddings();
  var tabIndex = 0;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Feeds'),
    Tab(text: 'KPI'),
    Tab(text: 'Analytics'),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (!mounted) return false;

      context.read<DashboardController>().clearInit();
      context.read<DashboardController>().init();

      if (Get.arguments != null) {
        setState(() {
          if (!mounted) return;

          if (Get.arguments != null) {
            setState(() {
              dynamic data = Get.arguments;
              mobileno = data[0]['Mobile'];
              screen = data[1]['Screen'];
            });
            if (screen.contains('Analyse')) {
              setState(() {
                context
                    .read<DashboardController>()
                    .showdialog(context, mobileno);
              });
            }
            // context.read<DashboardController>().setArgument(context,mobileno.toString());
          }
        });
      }
    });
  }

  // @override
  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  // showdialog()
                  // dasboardCnt.popupmenu(context);
                  context.read<DashboardController>().popupmenu(context);
                });
              },
              icon: const Icon(Icons.list))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: Screens.bodyheight(context) * 0.02,
                horizontal: Screens.bodyheight(context) * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Screens.bodyheight(context) * 0.06,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Screens.width(context) * 0.01),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: CustomTextform(
                    controller: context
                        .read<DashboardController>()
                        .dashbordTextController,
                    onTap: () {
                      // Get.toNamed(ConstantRoutes.screenshot);
                    },
                    autocorrect: false,
                    onChanged: (v) {
                      // dasboardCnt.SearchFilter(v);
                    },
                    // decoration: InputDecoration(
                    filled: false,
                    hintText: 'Search',
                    hintStyle: theme.textTheme.bodyMedium,
                    enableborder: EnableBorderType.type1,
                    focusborder: FocusBorderType.type1,
                    suffixIcon: IconButton(
                      color: theme.primaryColor,
                      onPressed: () {
                        setState(() {
                          
                          context.read<DashboardController>().init();
                          context.read<DashboardController>().showdialog(
                              context,
                              context
                                  .read<DashboardController>()
                                  .dashbordTextController
                                  .text);
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                    contentpading: ContentPadingType.type10,
                    // ),
                  ),
                )
                // TabBar(
                //   controller: controller,
                //   tabs: myTabs,
                // ),
              ],
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              // color: Colors.amber,
              width: Screens.width(context) * 0.5,
              // height: Screens.bodyheight(context) * 0.1,
              child: Text(
                'Hi, ${Utils.firstName}',
                textAlign: TextAlign.center,
                maxLines: 10,
                style:
                    theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(Screens.bodyheight(context) * 0.001),
        width: Screens.width(context),
        height: Screens.bodyheight(context),
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Utils.network == 'none'
              ? NoInternet(network: Utils.network)
              : Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomSpinkitdButton(
                        width: Screens.width(context) * 0.95,
                        label: "Click to Call",
                        labelLoading: "Please Wait",
                        onTap: () async {
                          final call = Uri(
                              scheme: 'https',
                              host: 'obd-api.myoperator.co',
                              path: '/obd-api-v1',
                              queryParameters: {
                                "company_id": "66275712a289e160",
                                "secret_token":
                                    "7026e44937b0bfb94949586355a5783c026bb363f3a1c825c4b2c26feb1c4fbb",
                                "type": "1", //1 for peer to peer
                                "number": "+917092571625",
                                "number_2":
                                    "+917092571625", //e.g. +919212992129
                                "public_ivr_id": "664c6304e6bc3119",
                                "reference_id":
                                    "27861760jiasd9", //e.g. abd9238dh21ss
                                "region": "BANGALORE",
                                "caller_id": "08062277298",
                                "group": "group-782"
                              });
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
                        }),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.002,
                    ),
                    CustomSpinkitdButton(
                        width: Screens.width(context) * 0.95,
                        label: "Call Log",
                        labelLoading: "Call Log",
                        onTap: () {
                          Get.toNamed(ConstantRoutes.callLog);
                        }),
                  ],
                ),
        ),
        //  ListView.builder(
        //     itemCount: dasboardCnt.callsInfo.length,
        //     itemBuilder: (context, index) {
        //       final calllog=dasboardCnt.callsInfo[index];
        //       return ListTile(
        //         leading: const Icon(Icons.call),
        //         title: Text('${calllog.name}'),
        //         subtitle: Text('${calllog.number}'),
        //         trailing:
        //             Text("${calllog.duration}"),
        //       );
        //     })
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Future.delayed(const Duration(seconds: 2));
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const testpage()),
      //     );
      //   },
      // ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return (context.read<DashboardController>().viewDefault == false &&
            context.read<DashboardController>().viewLeadDtls == false &&
            context.read<DashboardController>().viewOutStatndingDtls == false &&
            context.read<DashboardController>().viewOrderDtls == true)
        ? orderDetailsDialog(context)
        : (context.read<DashboardController>().viewDefault == false &&
                context.read<DashboardController>().viewLeadDtls == true &&
                context.read<DashboardController>().viewOutStatndingDtls ==
                    false &&
                context.read<DashboardController>().viewOrderDtls == false)
            ? updateLeadDialog(
                context,
                theme,
                '',
              )
            : (context.read<DashboardController>().viewDefault == false &&
                    context.read<DashboardController>().viewLeadDtls == false &&
                    context.read<DashboardController>().viewOutStatndingDtls ==
                        true &&
                    context.read<DashboardController>().viewOrderDtls == false)
                ? viewOutstandingdetails(
                    context,
                    theme,
                  )
                : viewDefault(context, theme);
  }

  SizedBox viewDefault(BuildContext context, ThemeData theme) {
    Config config = Config();
    // context.read<DashboardController>().refershAfterClosedialog();
    return SizedBox(
      width: Screens.width(context),
      // height: Screens.bodyheight(context),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: Screens.width(context),
                height: Screens.padingHeight(context) * 0.06,
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(
                      alignment: Alignment.center,
                      child: Text("View Details",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white)),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 18,
                    )
                  ],
                )),
            SizedBox(
              height: Screens.padingHeight(context) * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screens.width(context) * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.watch<DashboardController>().customerdetails!.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          width: Screens.width(context),
                          padding: EdgeInsets.symmetric(
                              horizontal: Screens.width(context) * 0.01,
                              vertical: Screens.bodyheight(context) * 0.008),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black26)),
                          child: IntrinsicHeight(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Screens.width(context) * 0.45,
                                  // height:Screens.padingHeight(context)*0.2 ,
                                  // color: Colors.amber,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.03,
                                        child: const Text("Customer Info"),
                                      ),
                                      const Divider(
                                        color: Colors.black26,
                                      ),
                                      Text(
                                        "Name ",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        '${context.watch<DashboardController>().customerdetails![0].customerName}',
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                      Text(
                                        "Phone ",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        "${context.watch<DashboardController>().customerdetails![0].customerCode}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                      Text(
                                        "City/State ",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        "${context.watch<DashboardController>().customerdetails![0].City},${context.watch<DashboardController>().customerdetails![0].State == null || context.watch<DashboardController>().customerdetails![0].State == "null" ? "" : context.watch<DashboardController>().customerdetails![0].State}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                // VerticalDivider(
                                //     width: Screens.width(context) * 0.001,
                                //     color: Colors.red,
                                //     thickness: 10.0),
                                SizedBox(
                                  width: Screens.width(context) * 0.40,
                                  // height:Screens.padingHeight(context)*0.2 ,
                                  // color: Colors.red,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.03,
                                        child: const Text(""),
                                      ),
                                      const Divider(
                                        color: Colors.black26,
                                      ),
                                      Text(
                                        "Status",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        "${context.watch<DashboardController>().customerdetails![0].status}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                      Text(
                                        "Potential Value",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        "${context.watch<DashboardController>().customerdetails![0].PotentialValue}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                      Text(
                                        "Email",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        "${context.watch<DashboardController>().customerdetails![0].email}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.002,
                  ),
                  const Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.002,
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.45,
                    child: context
                            .watch<DashboardController>()
                            .customerDatalist!
                            .isEmpty
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: context
                                .watch<DashboardController>()
                                .customerDatalist!
                                .length,
                            itemBuilder: (BuildContext context, int i) {
                              final customerDatalist = context
                                  .watch<DashboardController>()
                                  .customerDatalist![i];
                              return InkWell(
                                onDoubleTap: () async {
                                  await context
                                      .read<DashboardController>()
                                      .viewDetailsMethod(
                                          context
                                              .read<DashboardController>()
                                              .customerdetails![0]
                                              .customerCode
                                              .toString(),
                                          customerDatalist.DocNum.toString(),
                                          customerDatalist.DocType!,
                                          context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Screens.width(context) * 0.01,
                                      vertical: Screens.padingHeight(context) *
                                          0.002),
                                  child: Container(
                                    width: Screens.width(context),
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Screens.width(context) * 0.02,
                                        vertical:
                                            Screens.padingHeight(context) *
                                                0.01),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: Colors.black26)),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Doc Number",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                          Text(
                                            "Doc Date",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${customerDatalist.DocNum}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                          Text(
                                            customerDatalist.DocDate!.isEmpty
                                                ? '-'
                                                : config.alignDate(
                                                    customerDatalist.DocDate
                                                        .toString()),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.002,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Doc Type",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                          Text(
                                            "Status",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${customerDatalist.DocType}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                          Text(
                                            "${customerDatalist.Status}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.002,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Assigned To",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                          Text(
                                            "Business Value",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            customerDatalist.AssignedTo
                                                .toString(),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                          Text(
                                            config.slpitCurrency22(
                                                customerDatalist.BusinessValue
                                                    .toString()),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ),
                              );
                            }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox orderDetailsDialog(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: Screens.width(context),
      // height: Screens.bodyheight(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    // fontSize: 12,
                    ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )), //Radius.circular(6)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: const Text(""),
                  // ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Order Details",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Container(
                  //       alignment: Alignment.centerRight,
                  //       child: const Icon(
                  //         Icons.close,
                  //         color: Colors.white,
                  //       )),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.87,
            padding: EdgeInsets.only(
              top: Screens.bodyheight(context) * 0.01,
              bottom: Screens.bodyheight(context) * 0.01,
              left: Screens.width(context) * 0.03,
              right: Screens.width(context) * 0.01,
            ),
            child: (context
                        .watch<DashboardController>()
                        .getOrderDeatilsQTHData
                        .isEmpty &&
                    context.watch<DashboardController>().loadOrderViewDtlsApi ==
                        false)
                ? Center(
                    child: Text(
                      'No data..',
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: Colors.black),
                    ),
                  )
                : (context
                            .watch<DashboardController>()
                            .getOrderDeatilsQTHData
                            .isEmpty &&
                        context
                                .watch<DashboardController>()
                                .loadOrderViewDtlsApi ==
                            true)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Screens.width(context) * 0.4,
                                  child: Text(
                                    "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].CardName}",
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                ),
                                Container(
                                  width: Screens.width(context) * 0.4,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: const Color(0xffC6AC5F),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Open since "
                                      "${context.read<DashboardController>().config.subtractDateTime2(
                                          // "2020-05-18T00:00:00"
                                          "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].OrderCreatedDate}")}",
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Screens.width(context) * 0.4,
                                  child: Text(
                                    "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].Address1}",
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: Screens.width(context) * 0.43,
                                  child: Text(
                                    "Worth of Rs."
                                    "${context.watch<DashboardController>().config.slpitCurrency22(
                                          context
                                              .watch<DashboardController>()
                                              .getOrderDeatilsQTHData[0]
                                              .DocTotal!
                                              .toString(),
                                        )}"
                                    '/-',
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Screens.width(context) * 0.4,
                                  child: Text(
                                    "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].Address2}",
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: Screens.width(context) * 0.4,
                                  child: Text(
                                    "# ${context.watch<DashboardController>().getOrderDeatilsQTHData[0].OrderNum}",
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Screens.width(context) * 0.4,
                                  child: Text(
                                    "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].City}",
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: Screens.width(context) * 0.4,
                                  child: Text(
                                    "Created on ${context.watch<DashboardController>().config.alignDate3("${context.watch<DashboardController>().getOrderDeatilsQTHData[0].OrderCreatedDate}" //.LastFUPUpdate
                                        )}",
                                    textAlign: TextAlign.right,
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                context
                                                .watch<DashboardController>()
                                                .getOrderDeatilsQTHData[0]
                                                .CardCode ==
                                            null ||
                                        context
                                                .watch<DashboardController>()
                                                .getOrderDeatilsQTHData[0]
                                                .CardCode ==
                                            "null" ||
                                        context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .CardCode!
                                            .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          context
                                              .read<DashboardController>()
                                              .makePhoneCall(context
                                                  .read<DashboardController>()
                                                  .getOrderDeatilsQTHData[0]
                                                  .CardCode!);
                                        },
                                        child: SizedBox(
                                          width: Screens.width(context) * 0.4,
                                          child: Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].CardCode}",
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue),
                                          ),
                                        ),
                                      ),
                              ],
                            ),

                            // createTable(theme),

                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),

                            SizedBox(
                              height: Screens.bodyheight(context) * 0.015,
                            ),
                            createOrderTable(theme, context),
                            const Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            //

                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      // color: Colors.amber,
                                      width: Screens.width(context) * 0.4,
                                      // height: Screens.padingHeight(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Delivery Address :",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Address1}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Address2}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Area}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_City}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_State}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Pincode}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      //  color: Colors.red,
                                      width: Screens.width(context) * 0.5,

                                      // height: Screens.padingHeight(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Sub Total",
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  context
                                                      .read<
                                                          DashboardController>()
                                                      .config
                                                      .slpitCurrency22(context
                                                          .watch<
                                                              DashboardController>()
                                                          .getOrderDeatilsQTHData[
                                                              0]
                                                          .subtotal!
                                                          .toString()),
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Base Amount",
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                              Text(
                                                context
                                                    .read<DashboardController>()
                                                    .config
                                                    .slpitCurrency22(context
                                                        .watch<
                                                            DashboardController>()
                                                        .getOrderDeatilsQTHData[
                                                            0]
                                                        .basetotal!
                                                        .toString()),
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Tax Amount",
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                              Text(
                                                context
                                                    .read<DashboardController>()
                                                    .config
                                                    .slpitCurrency22(context
                                                        .watch<
                                                            DashboardController>()
                                                        .getOrderDeatilsQTHData[
                                                            0]
                                                        .taxAmount!
                                                        .toString()),
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Round Off",
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                              Text(
                                                context
                                                    .read<DashboardController>()
                                                    .config
                                                    .slpitCurrency22(context
                                                        .watch<
                                                            DashboardController>()
                                                        .getOrderDeatilsQTHData[
                                                            0]
                                                        .RoundOff!
                                                        .toString()),
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                Screens.padingHeight(context) *
                                                    0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total Amount",
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                              Text(
                                                context
                                                    .read<DashboardController>()
                                                    .config
                                                    .slpitCurrency22(context
                                                        .watch<
                                                            DashboardController>()
                                                        .getOrderDeatilsQTHData[
                                                            0]
                                                        .DocTotal!
                                                        .toString()),
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            SizedBox(
                              height: Screens.padingHeight(context) * 0.02,
                            ),
                            context
                                        .watch<DashboardController>()
                                        .getOrderDeatilsQTHData[0]
                                        .isDelivered ==
                                    1
                                ? Container(
                                    width: Screens.width(context),
                                    padding: EdgeInsets.symmetric(
                                        // horizontal: Screens.width(context) * 0.03,
                                        vertical:
                                            Screens.bodyheight(context) * 0.02),
                                    decoration: BoxDecoration(
                                        color: theme.primaryColor
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.black26)),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.8,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Delivered on ${context.watch<DashboardController>().config.alignDate('${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryDate}')} by referenced ${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryNo}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: Screens.padingHeight(context) * 0.01,
                            ),

                            context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .isDelivered ==
                                        1 &&
                                    context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .DeliveryURL1 !=
                                        null &&
                                    context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .DeliveryURL2 !=
                                        null
                                ? Container(
                                    width: Screens.width(context),
                                    padding: EdgeInsets.symmetric(
                                        // horizontal: Screens.width(context) * 0.03,
                                        vertical:
                                            Screens.bodyheight(context) * 0.02),
                                    decoration: BoxDecoration(
                                        // color: theme.primaryColor.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.black26)),
                                    child: Column(
                                      children: [
                                        Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryURL1}"),
                                        SizedBox(
                                          height: Screens.bodyheight(context) *
                                              0.01,
                                        ),
                                        Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryURL2}"),
                                      ],
                                    ),
                                  )
                                : Container(),
                            // Wrap(
                            //     spacing: 0.0, // width
                            //     runSpacing: 0.0, // height
                            //     children: listTimeLine(theme)),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            context
                                        .watch<DashboardController>()
                                        .getOrderDeatilsQTHData[0]
                                        .isInvoiced ==
                                    1
                                ? Container(
                                    width: Screens.width(context),
                                    padding: EdgeInsets.symmetric(
                                        // horizontal: Screens.width(context) * 0.03,
                                        vertical:
                                            Screens.bodyheight(context) * 0.02),
                                    decoration: BoxDecoration(
                                        color: theme.primaryColor
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.black26)),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: Screens.width(context) * 0.8,
                                          child: Text(
                                            "Invoiced on ${context.watch<DashboardController>().config.alignDate('${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceDate}')} by referenced ${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceNo}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: Screens.padingHeight(context) * 0.01,
                            ),

                            (context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .isInvoiced ==
                                        1) &&
                                    (context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .InvoiceURL1 !=
                                        null) &&
                                    (context
                                            .watch<DashboardController>()
                                            .getOrderDeatilsQTHData[0]
                                            .InvoiceURL2 !=
                                        null)
                                ? Container(
                                    width: Screens.width(context),
                                    padding: EdgeInsets.symmetric(
                                        // horizontal: Screens.width(context) * 0.03,
                                        vertical:
                                            Screens.bodyheight(context) * 0.02),
                                    decoration: BoxDecoration(
                                        // color: theme.primaryColor.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.black26)),
                                    child: Column(
                                      children: [
                                        Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceURL1}"),
                                        SizedBox(
                                          height: Screens.bodyheight(context) *
                                              0.01,
                                        ),
                                        Text(
                                            "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceURL2}"),
                                      ],
                                    ),
                                  )
                                : Container(),

                            InkWell(
                              onTap: () async {
                                await context
                                    .read<DashboardController>()
                                    .callcustomerapi();
                                for (int i = 0;
                                    i <
                                        context
                                            .read<DashboardController>()
                                            .paymode
                                            .length;
                                    i++) {
                                  if (context
                                          .read<DashboardController>()
                                          .paymode[i]
                                          .CODE ==
                                      context
                                          .read<DashboardController>()
                                          .getOrderDeatilsQTHData[0]
                                          .PaymentTerms) {
                                    pdfviewState.paymode = context
                                        .read<DashboardController>()
                                        .paymode[i]
                                        .description
                                        .toString();
                                  }
                                }

                                pdfviewState.data = context
                                    .read<DashboardController>()
                                    .getOrderDeatilsQTLData;
                                pdfviewState.orderMasterdata2 = context
                                    .read<DashboardController>()
                                    .getOrderDeatilsQTHData;
                                pdfviewState.customermodeldata = context
                                    .read<DashboardController>()
                                    .customermodeldata;

                                // PdfPreview(build: (format)=>pdfState().generatePdf(format, 'title'),);
                                // pdfviewState.paymode=paymode;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const pdfview()));
                              },
                              child: const Text(
                                "Convert as Pdf",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
                onPressed: () {
                  context.read<DashboardController>().setviewBool('', context);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                      // fontSize: 12,
                      ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )), //Radius.circular(6)
                ),
                child: const Text("Close")),
          ),
        ],
      ),
    );
  }

  Widget createOrderTable(ThemeData theme, BuildContext context) {
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Product",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Price",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Qty",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
    ]));
    for (int i = 0;
        i < context.watch<DashboardController>().getOrderDeatilsQTLData.length;
        ++i) {
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context
                .watch<DashboardController>()
                .getOrderDeatilsQTLData[i]
                .ItemName!,
            textAlign: TextAlign.left,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context.watch<DashboardController>().config.slpitCurrency(context
                .watch<DashboardController>()
                .getOrderDeatilsQTLData[i]
                .Price!
                .toStringAsFixed(0)),
            // '${context.watch<DashboardController>().getleadDeatilsQTLData[i].Price!.toStringAsFixed(2)}',
            textAlign: TextAlign.left,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context
                .watch<DashboardController>()
                .getOrderDeatilsQTLData[i]
                .Quantity!
                .toStringAsFixed(0),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
      ]));
    }
    return Table(columnWidths: const {
      0: FlexColumnWidth(4),
      1: FlexColumnWidth(2.2),
      2: FlexColumnWidth(0.8),
    }, children: rows);
  }

  Widget createTable(ThemeData theme, BuildContext context) {
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Product",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Price",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Qty",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
    ]));
    for (int i = 0;
        i < context.watch<DashboardController>().getleadDeatilsQTLData.length;
        ++i) {
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context
                .watch<DashboardController>()
                .getleadDeatilsQTLData[i]
                .ItemName!,
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context.watch<DashboardController>().config.slpitCurrency(context
                .watch<DashboardController>()
                .getleadDeatilsQTLData[i]
                .Price!
                .toStringAsFixed(0)),
            // '${context.watch<DashboardController>().getleadDeatilsQTLData[i].Price!.toStringAsFixed(2)}',
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context
                .watch<DashboardController>()
                .getleadDeatilsQTLData[i]
                .Quantity!
                .toStringAsFixed(0),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
      ]));
    }
    return Table(columnWidths: const {
      0: FlexColumnWidth(4),
      1: FlexColumnWidth(2.2),
      2: FlexColumnWidth(0.8),
    }, children: rows);
  }

  SizedBox updateLeadDialog(
    BuildContext context,
    ThemeData theme,
    String docentry,
  ) {
    return (context.read<DashboardController>().getupdateFollowUpDialog ==
                false &&
            context.read<DashboardController>().getleadForwarddialog == true &&
            context.read<DashboardController>().getleadLoadingdialog == false &&
            context.read<DashboardController>().getviewDetailsdialog == false &&
            context
                    .read<DashboardController>()
                    .getupdateConvertToQuatationUpdialog ==
                false &&
            context
                .read<DashboardController>()
                .getforwardSuccessMsg
                .isNotEmpty &&
            context.read<DashboardController>().getisSameBranch == true)
        ? displaySucessDialog(context, theme)
        : SizedBox(
            width: Screens.width(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: Screens.width(context),
                      //  height: Screens.bodyheight(context)*0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.only(
                        left: Screens.width(context) * 0.05,
                        right: Screens.width(context) * 0.05,
                        top: Screens.bodyheight(context) * 0.03,
                        //  bottom: Screens.bodyheight(context)*0.03,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'How you made the follow up?',
                              context.watch<DashboardController>().followup!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: context
                                        .watch<DashboardController>()
                                        .getfollowup!
                                        .contains(" *")
                                    ? Colors.red
                                    : theme.primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            Center(
                              child: Wrap(
                                  spacing: 5.0, // width
                                  runSpacing: 10.0, // height
                                  children: listContainersCustomerTag(
                                      theme, context)),
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            SizedBox(
                              child: Text(
                                "What is the case status now?",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: theme.primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Wrap(
                                      spacing: 7.0, // width
                                      runSpacing: 10.0, // height
                                      children: listContainersOpenTag(
                                          theme, context)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            Visibility(
                              visible: context
                                          .watch<DashboardController>()
                                          .getcaseStatusSelected ==
                                      'Open'
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  Container(
                                    width: Screens.width(context),
                                    // height: Screens.,
                                    padding: const EdgeInsets.only(
                                        top: 1, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButton(
                                      hint: Text(
                                        context
                                            .watch<DashboardController>()
                                            .gethinttextforOpenLead!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: context
                                                        .watch<
                                                            DashboardController>()
                                                        .gethinttextforOpenLead!
                                                        .contains(" *")
                                                    ? Colors.red
                                                    : Colors.black),
                                      ),
                                      value: context
                                          .read<DashboardController>()
                                          .valueChosedStatus,
                                      //dropdownColor:Colors.green,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      isExpanded: true,
                                      onChanged: (val) {
                                        // setState(() {
                                        context
                                            .read<DashboardController>()
                                            .choosedStatus(val.toString());
                                        // });
                                      },
                                      items: context
                                          .read<DashboardController>()
                                          .leadStatusOpen
                                          .map((e) {
                                        return DropdownMenuItem(
                                            // ignore: unnecessary_brace_in_string_interps
                                            value: "${e.code}",
                                            child: Text("${e.name}"));
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Screens.bodyheight(context) * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Plan of Purchase Date", // "Next Follow up",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color:
                                              // context
                                              //         .watch<DashboardController>()
                                              //         .getorderBillDate!
                                              //         .contains(" *")
                                              //     ? Colors.red
                                              //     :
                                              Colors.grey,
                                        ), // fontSize: 12
                                      ),
                                      InkWell(
                                        onTap: context
                                                    .read<DashboardController>()
                                                    .getcaseStatusSelected ==
                                                'Open'
                                            ? () {
                                                context
                                                    .read<DashboardController>()
                                                    .showpurchaseupateDate(
                                                        context);
                                              }
                                            : null,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Screens.width(context) *
                                                      0.015),
                                          width: Screens.width(context) * 0.4,
                                          height: Screens.bodyheight(context) *
                                              0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: Screens.width(context) *
                                                    0.25,
                                                // color: Colors.red,
                                                child: Text(
                                                  context
                                                      .watch<
                                                          DashboardController>()
                                                      .nextpurchasedate,
                                                  // context.read<DashboardController>().getnextFD,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(), //fontSize: 12
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: Screens.width(context) *
                                                    0.10,
                                                // color: Colors.red,
                                                child: Icon(
                                                  Icons.calendar_month,
                                                  // size: Screens.,
                                                  color: theme.primaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: context
                                          .read<DashboardController>()
                                          .getcaseStatusSelected ==
                                      'Won'
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  Container(
                                    width: Screens.width(context),
                                    padding: const EdgeInsets.only(
                                        top: 1, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButton(
                                      hint: Text(
                                        context
                                            .read<DashboardController>()
                                            .gethinttextforWonLead!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: context
                                                        .read<
                                                            DashboardController>()
                                                        .gethinttextforWonLead!
                                                        .contains(" *")
                                                    ? Colors.red
                                                    : Colors.black),
                                      ),
                                      value: context
                                          .read<DashboardController>()
                                          .valueChosedStatusWon,
                                      //dropdownColor:Colors.green,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      isExpanded: true,
                                      onChanged: (val) {
                                        // setState(() {
                                        context
                                            .read<DashboardController>()
                                            .choosedStatusWon(val.toString());
                                        // });
                                      },
                                      items: context
                                          .read<DashboardController>()
                                          .leadStatusWon
                                          .map((e) {
                                        return DropdownMenuItem(
                                            // ignore: unnecessary_brace_in_string_interps
                                            value: "${e.code}",
                                            child: Text(e.name.toString()));
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Screens.bodyheight(context) * 0.01,
                                  ),
                                  TextFormField(
                                    controller: context
                                        .read<DashboardController>()
                                        .mycontroller[0],
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        hintText: context
                                            .read<DashboardController>()
                                            .getorderBillRefer!,
                                        hintStyle: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: context
                                                  .read<DashboardController>()
                                                  .getorderBillRefer!
                                                  .contains(" *")
                                              ? Colors.red
                                              : Colors.black,
                                          // fontSize: 14
                                        ),
                                        // TextStyle(
                                        //     color: context
                                        //             .read<DashboardController>()
                                        //             .getorderBillRefer!
                                        //             .contains(" *")
                                        //         ? Colors.red
                                        //         : Colors.black),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10)),
                                  ),
                                  SizedBox(
                                    height: Screens.bodyheight(context) * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context
                                            .watch<DashboardController>()
                                            .getorderBillDate!, // "Next Follow up",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: context
                                                  .watch<DashboardController>()
                                                  .getorderBillDate!
                                                  .contains(" *")
                                              ? Colors.red
                                              : Colors.grey,
                                        ), // fontSize: 12
                                      ),
                                      InkWell(
                                        onTap: context
                                                    .read<DashboardController>()
                                                    .getcaseStatusSelected ==
                                                'Won'
                                            ? () {
                                                context
                                                    .read<DashboardController>()
                                                    .showFollowupWonDate(
                                                        context);
                                              }
                                            : null,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Screens.width(context) *
                                                      0.015),
                                          width: Screens.width(context) * 0.5,
                                          height: Screens.bodyheight(context) *
                                              0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: Screens.width(context) *
                                                    0.3,
                                                // color: Colors.red,
                                                child: Text(
                                                  context
                                                      .watch<
                                                          DashboardController>()
                                                      .getnextWonFD,
                                                  // context.read<DashboardController>().getnextFD,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(), //fontSize: 12
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: Screens.width(context) *
                                                    0.15,
                                                // color: Colors.red,
                                                child: Icon(
                                                  Icons.calendar_month,
                                                  // size: Screens.,
                                                  color: theme.primaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Screens.bodyheight(context) * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: context
                                          .read<DashboardController>()
                                          .getcaseStatusSelected ==
                                      'Lost'
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  Container(
                                    width: Screens.width(context),
                                    padding: const EdgeInsets.only(
                                        top: 1, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButton(
                                      hint: Text(
                                        context
                                            .read<DashboardController>()
                                            .gethinttextforLostLead!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: context
                                                        .read<
                                                            DashboardController>()
                                                        .gethinttextforLostLead!
                                                        .contains(" *")
                                                    ? Colors.red
                                                    : Colors.black),
                                      ),
                                      value: context
                                          .read<DashboardController>()
                                          .valueChosedReason,
                                      //dropdownColor:Colors.green,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      isExpanded: true,
                                      onChanged: (val) {
                                        // setState(() {
                                        context
                                            .read<DashboardController>()
                                            .choosedReason(val.toString());
                                        // });
                                      },
                                      items: context
                                          .read<DashboardController>()
                                          .leadStatusLost
                                          .map((e) {
                                        return DropdownMenuItem(
                                            // ignore: unnecessary_brace_in_string_interps
                                            value: "${e.code}",
                                            child: Text(e.name.toString()));
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Screens.bodyheight(context) * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              context
                                  .watch<DashboardController>()
                                  .getfeedbackLead!, // "Feedback",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: context
                                        .watch<DashboardController>()
                                        .getfeedbackLead!
                                        .contains(" *")
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            TextFormField(
                              controller: context
                                  .watch<DashboardController>()
                                  .mycontroller[1],
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[400]!, width: 2.0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            context
                                        .read<DashboardController>()
                                        .getcaseStatusSelected !=
                                    'Open'
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context
                                            .watch<DashboardController>()
                                            .getnextFollowupDate!, // "Next Follow up",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: context
                                                  .watch<DashboardController>()
                                                  .getnextFollowupDate!
                                                  .contains(" *")
                                              ? Colors.red
                                              : Colors.grey,
                                        ), // fontSize: 12
                                      ),
                                      InkWell(
                                        onTap: context
                                                    .read<DashboardController>()
                                                    .getcaseStatusSelected ==
                                                'Open'
                                            ? () {
                                                context
                                                    .read<DashboardController>()
                                                    .showFollowupDate(context);
                                              }
                                            : null,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Screens.width(context) *
                                                      0.015),
                                          width: Screens.width(context) * 0.5,
                                          height: Screens.bodyheight(context) *
                                              0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: Screens.width(context) *
                                                    0.3,
                                                // color: Colors.red,
                                                child: Text(
                                                  context
                                                      .watch<
                                                          DashboardController>()
                                                      .getnextFD,
                                                  // context.read<DashboardController>().getnextFD,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(), //fontSize: 12
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: Screens.width(context) *
                                                    0.15,
                                                // color: Colors.red,
                                                child: Icon(
                                                  Icons.calendar_month,
                                                  // size: Screens.,
                                                  color: theme.primaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: Screens.bodyheight(context) * 0.01,
                            ),
                            context
                                        .read<DashboardController>()
                                        .getcaseStatusSelected !=
                                    'Open'
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context
                                            .read<DashboardController>()
                                            .nextVisitTime!, // "Next Follow up",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: context
                                                  .read<DashboardController>()
                                                  .nextVisitTime!
                                                  .contains(" *")
                                              ? Colors.red
                                              : Colors.grey,
                                        ), // fontSize: 12
                                      ),
                                      InkWell(
                                        onTap: context
                                                    .read<DashboardController>()
                                                    .getcaseStatusSelected ==
                                                'Open'
                                            ? () {
                                                // setState(() {
                                                context
                                                    .read<DashboardController>()
                                                    .selectVisitTime(context);
                                                // });
                                              }
                                            : null,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Screens.width(context) *
                                                      0.015),
                                          width: Screens.width(context) * 0.5,
                                          height: Screens.bodyheight(context) *
                                              0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: Screens.width(context) *
                                                    0.3,
                                                // color: Colors.red,
                                                child: Text(
                                                  context
                                                      .watch<
                                                          DashboardController>()
                                                      .VisitTime,
                                                  //fUPCon.getnextFD,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(), //fontSize: 12
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: Screens.width(context) *
                                                    0.15,
                                                // color: Colors.red,
                                                child: Icon(
                                                  Icons.timer,
                                                  // size: Screens.,
                                                  color: theme.primaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            context
                                        .read<DashboardController>()
                                        .getcaseStatusSelected !=
                                    'Open'
                                ? Container()
                                : context
                                            .read<DashboardController>()
                                            .iscorectime ==
                                        false
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Schedule Time between 7AM to 10PM*",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  color: Colors.red,
                                                  fontSize: 13),
                                        ),
                                      )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: Screens.bodyheight(context) * 0.01,
                  ),
                  SizedBox(
                    width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.06,
                    child: ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<DashboardController>()
                              .clickLeadSaveBtn(
                                  context
                                      .read<DashboardController>()
                                      .docentry
                                      .toString(),
                                  context
                                      .read<DashboardController>()
                                      .docentry
                                      .toString(),
                                  '');
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              // fontSize: 12,
                              ),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )), //Radius.circular(6)
                        ),
                        child: const Text("Save")),
                  ),
                ],
              ),
            ),
          );
  }

  SizedBox displaySucessDialog(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: Screens.width(context),
      // height: Screens.bodyheight(context) * 0.6,
      // padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    // fontSize: 12,
                    ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )), //Radius.circular(6)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(""),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Alert",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Screens.bodyheight(context) * 0.01,
          ),
          Column(
            children: [
              Text(
                context
                        .read<DashboardController>()
                        .getforwardSuccessMsg
                        .toString()
                        .toLowerCase()
                        .contains("success")
                    ? "Success..!!"
                    : ' "Error..!!"',
                style: context
                        .watch<DashboardController>()
                        .getforwardSuccessMsg
                        .contains("Success")
                    ? theme.textTheme.headline6?.copyWith(color: Colors.green)
                    : theme.textTheme.headline6?.copyWith(color: Colors.red),
              ),
              SizedBox(
                height: Screens.bodyheight(context) * 0.02,
              ),
              Text(
                context.watch<DashboardController>().getforwardSuccessMsg,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(
                height: Screens.bodyheight(context) * 0.02,
              ),
              SizedBox(
                width: Screens.width(context) * 0.26,
                height: Screens.bodyheight(context) * 0.06,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop<bool>(true);
                      context
                          .read<DashboardController>()
                          .setviewBool('', context);
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //         insetPadding: const EdgeInsets.all(10),
                      //         contentPadding: const EdgeInsets.all(0),
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),

                      //         // title: Text("hi"),
                      //         content: const AskAgainBox());
                      //   },
                      // );
                      // Navigator.pop(context);
                      // AskAgainBox(context: context, theme: theme);
                    },
                    child: const Text(
                      "Ok",
                    )),
              ),
            ],
          ),
          SizedBox(
            height: Screens.bodyheight(context) * 0.01,
          ),
        ],
      ),
    );
  }

  SizedBox viewdetailsDialogLead(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: Screens.width(context),
      height: Screens.bodyheight(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    // fontSize: 12,
                    ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )), //Radius.circular(6)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(""),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Lead Details",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.87,
            padding: EdgeInsets.only(
              top: Screens.bodyheight(context) * 0.01,
              bottom: Screens.bodyheight(context) * 0.01,
              left: Screens.width(context) * 0.03,
              right: Screens.width(context) * 0.03,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Screens.width(context) * 0.4,
                        child: Text(
                          "${context.watch<DashboardController>().getleadDeatilsQTHData[0].CardName}",
                          style: theme.textTheme.bodyMedium?.copyWith(),
                        ),
                      ),
                      context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .LeadCreatedDate ==
                                  null ||
                              context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .LeadCreatedDate ==
                                  "null" ||
                              context
                                  .watch<DashboardController>()
                                  .getleadDeatilsQTHData[0]
                                  .LeadCreatedDate!
                                  .isEmpty
                          ? Container()
                          : Container(
                              width: Screens.width(context) * 0.4,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: const Color(0xffC6AC5F),
                              ),
                              child: Center(
                                child: Text(
                                  "Open since ${context.read<DashboardController>().config.subtractDateTime2(
                                      // "2020-05-18T00:00:00"
                                      "${context.watch<DashboardController>().getleadDeatilsQTHData[0].LeadCreatedDate}")}",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(),
                                ),
                              ),
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .Address1 ==
                                  null ||
                              context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .Address1 ==
                                  "null" ||
                              context
                                  .watch<DashboardController>()
                                  .getleadDeatilsQTHData[0]
                                  .Address1!
                                  .isEmpty
                          ? Container()
                          : SizedBox(
                              width: Screens.width(context) * 0.4,
                              child: Text(
                                "${context.watch<DashboardController>().getleadDeatilsQTHData[0].Address1}",
                                style: theme.textTheme.bodyMedium?.copyWith(),
                              ),
                            ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: Screens.width(context) * 0.43,
                        child: Text(
                          "Worth of Rs. ${context.watch<DashboardController>().config.slpitCurrency22(context.watch<DashboardController>().getleadDeatilsQTHData[0].DocTotal!.toString())} '/-' ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .Address2 ==
                                  null ||
                              context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .Address2 ==
                                  "null" ||
                              context
                                  .watch<DashboardController>()
                                  .getleadDeatilsQTHData[0]
                                  .Address2!
                                  .isEmpty
                          ? Container()
                          : SizedBox(
                              width: Screens.width(context) * 0.4,
                              child: Text(
                                "${context.watch<DashboardController>().getleadDeatilsQTHData[0].Address2}",
                                style: theme.textTheme.bodyMedium?.copyWith(),
                              ),
                            ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: Screens.width(context) * 0.4,
                        child: Text(
                          "# ${context.watch<DashboardController>().getleadDeatilsQTHData[0].LeadNum}",
                          style: theme.textTheme.bodyMedium?.copyWith(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .City ==
                                  null ||
                              context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .City ==
                                  "null" ||
                              context
                                  .watch<DashboardController>()
                                  .getleadDeatilsQTHData[0]
                                  .City!
                                  .isEmpty
                          ? Container()
                          : SizedBox(
                              width: Screens.width(context) * 0.4,
                              child: Text(
                                "${context.watch<DashboardController>().getleadDeatilsQTHData[0].City}",
                                style: theme.textTheme.bodyMedium?.copyWith(),
                              ),
                            ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: Screens.width(context) * 0.4,
                        child: Text(
                          "Created on ${context.watch<DashboardController>().config.alignDate3("${context.watch<DashboardController>().getleadDeatilsQTHData[0].LeadCreatedDate}" //.LastFUPUpdate
                              )}",
                          style: theme.textTheme.bodyMedium?.copyWith(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .CardCode ==
                                  null ||
                              context
                                      .watch<DashboardController>()
                                      .getleadDeatilsQTHData[0]
                                      .CardCode ==
                                  "null" ||
                              context
                                  .watch<DashboardController>()
                                  .getleadDeatilsQTHData[0]
                                  .CardCode!
                                  .isEmpty
                          ? Container()
                          : InkWell(
                              onTap: () {
                                context
                                    .read<DashboardController>()
                                    .makePhoneCall(context
                                        .read<DashboardController>()
                                        .getleadDeatilsQTHData[0]
                                        .CardCode!);
                              },
                              child: SizedBox(
                                width: Screens.width(context) * 0.35,
                                child: Text(
                                  "${context.watch<DashboardController>().getleadDeatilsQTHData[0].CardCode}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                ),
                              ),
                            ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: Screens.width(context) * 0.50,
                        child: Text(
                          "Last Updated on ${context.watch<DashboardController>().config.alignDate3("${context.watch<DashboardController>().getleadDeatilsQTHData[0].LastFUPUpdate}" //.
                              )}",
                          style: theme.textTheme.bodyMedium?.copyWith(),
                        ),
                      ),
                    ],
                  ),

                  // createTable(theme),

                  SizedBox(
                    height: Screens.bodyheight(context) * 0.01,
                  ),
                  Container(
                      width: Screens.width(context),
                      padding: EdgeInsets.symmetric(
                          // horizontal: Screens.width(context) * 0.03,
                          vertical: Screens.bodyheight(context) * 0.02),
                      decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26)),
                      child: Column(
                        children: [
                          Center(
                              child: context
                                          .watch<DashboardController>()
                                          .getleadDeatilsQTHData[0]
                                          .nextFollowupDate!
                                          .isNotEmpty ||
                                      context
                                              .watch<DashboardController>()
                                              .getleadDeatilsQTHData[0]
                                              .nextFollowupDate !=
                                          null ||
                                      context
                                              .watch<DashboardController>()
                                              .getleadDeatilsQTHData[0]
                                              .nextFollowupDate !=
                                          "null"
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Next Follow up # ${context.watch<DashboardController>().config.alignDate('${context.watch<DashboardController>().getleadDeatilsQTHData[0].nextFollowupDate}')}',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Next Follow up # ',
                                        // context
                                        //     .watch<DashboardController>()
                                        //     .config
                                        //     .alignDate(
                                        //         '${context.watch<DashboardController>().getleadDeatilsQTHData[0].nextFollowupDate}'),
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    )),
                          Container(
                              width: Screens.width(context),
                              margin: EdgeInsets.only(
                                // left: Screens.width(context) * 0.03,
                                top: Screens.bodyheight(context) * 0.01,
                                bottom: Screens.bodyheight(context) * 0.01,
                              ),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black26)))),
                          Center(
                              child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Last status # ${context.watch<DashboardController>().getleadDeatilsLeadData[context.watch<DashboardController>().getleadDeatilsLeadData.length - 1].Status}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          )
                              // :Container(
                              //   alignment: Alignment.center,
                              //   child: Text(
                              //     'Last status # ',
                              //     // ${context.watch<DashboardController>().getleadDeatilsLeadData[context.watch<DashboardController>().getleadDeatilsLeadData.length - 1].Status}',
                              //     textAlign: TextAlign.center,
                              //     style: theme.textTheme.bodyMedium?.copyWith(
                              //       color: theme.primaryColor,
                              //     ),
                              //   ),
                              // ),
                              )
                        ],
                      )),
                  // Container(
                  //     width: Screens.width(context),
                  //     // height: Screens.bodyheight(context) * 0.16,
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: Screens.width(context) * 0.03,
                  //         vertical: Screens.bodyheight(context) * 0.02),
                  //     decoration: BoxDecoration(
                  //         color: theme.primaryColor.withOpacity(0.05),
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(color: Colors.black26)),
                  //     child: Center(
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           'Last status # ${context.watch<DashboardController>().getleadDeatilsQLData[context.watch<DashboardController>().getleadDeatilsQLData.length - 1].Status}',
                  //           textAlign: TextAlign.center,
                  //           style: theme.textTheme.bodyMedium?.copyWith(
                  //             color: theme.primaryColor,
                  //           ),
                  //         ),
                  //       ),
                  //     )),

                  SizedBox(
                    height: Screens.bodyheight(context) * 0.015,
                  ),
                  createTable(theme, context),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: Screens.bodyheight(context) * 0.01,
                  ),
                  //
                  Wrap(
                      spacing: 0.0, // width
                      runSpacing: 0.0, // height
                      children: listTimeLine(theme, context)),
                  SizedBox(
                    height: Screens.bodyheight(context) * 0.01,
                  ),

                  //                 Timeline.tileBuilder(
                  //   builder: TimelineTileBuilder.fromStyle(
                  //     contentsAlign: ContentsAlign.alternating,
                  //     contentsBuilder: (context, index) => Padding(
                  //       padding: const EdgeInsets.all(24.0),
                  //       child: Text('Timeline Event $index'),
                  //     ),
                  //     itemCount: 10,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
                onPressed: () {
                  context.read<DashboardController>().viweDetailsClicked();
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                      // fontSize: 12,
                      ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )), //Radius.circular(6)
                ),
                child: const Text("Followup")),
          ),
        ],
      ),
    );
  }

  List<Widget> listTimeLine(ThemeData theme, BuildContext context) {
    return List.generate(
        context.read<DashboardController>().getleadDeatilsLeadData.length,
        (index) {
      if (index == 0) {
        log("1");
        return Column(
          children: [
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                width: 30,
                color: theme.primaryColor,
                indicatorXY: 0.2,
                padding: const EdgeInsets.only(
                  top: 4,
                  left: 4,
                  right: 4,
                ),
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData: context
                              .read<DashboardController>()
                              .getleadDeatilsLeadData[index]
                              .FollowMode ==
                          'Phone Call'
                      ? Icons.call
                      : context
                                  .read<DashboardController>()
                                  .getleadDeatilsLeadData[index]
                                  .FollowMode ==
                              'Sms/WhatsApp'
                          ? Icons.message
                          : context
                                      .read<DashboardController>()
                                      .getleadDeatilsLeadData[index]
                                      .FollowMode ==
                                  'Store Visit'
                              ? Icons.store
                              : Icons.chat,
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.grey,
                thickness: 3,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.grey,
                thickness: 3,
              ),
              endChild: Container(
                alignment: Alignment.centerLeft,
                width: Screens.width(context) * 0.6,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${context.read<DashboardController>().getleadDeatilsLeadData[index].Status} ",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.01,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // context.read<DashboardController>().config.alignDate(
                        "By ${context.read<DashboardController>().getleadDeatilsLeadData[index].UpdatedBy} through ${context.read<DashboardController>().getleadDeatilsLeadData[index].FollowMode == null || context.read<DashboardController>().getleadDeatilsLeadData[index].FollowMode == "null" || context.read<DashboardController>().getleadDeatilsLeadData[index].FollowMode!.isEmpty ? "" : context.read<DashboardController>().getleadDeatilsLeadData[index].FollowMode}", //),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            // color: theme.primaryColor,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.02,
                    ),
                    context
                            .watch<DashboardController>()
                            .getleadDeatilsLeadData[index]
                            .Feedback!
                            .isEmpty
                        ? const SizedBox()
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // context.read<DashboardController>().config.alignDate(
                              "# ${context.read<DashboardController>().getleadDeatilsLeadData[index].Feedback}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // color: theme.primaryColor,
                                  ),
                            ),
                          ),
                    const Divider(
                      thickness: 1,
                    ),
                    //       SizedBox(
                    //   height: Screens.bodyheight(context) * 0.01,
                    // ),
                  ],
                ),
              ),
              startChild: Container(
                  padding: EdgeInsets.only(
                      left: Screens.width(context) * 0.02,
                      right: Screens.width(context) * 0.02),
                  // alignment:Alignment.centerRight,
                  // color: Colors.blue,
                  width: Screens.width(context) * 0.25,
                  child: Column(
                    children: [
                      Text(
                        context.read<DashboardController>().config.alignDate2(
                              "${context.read<DashboardController>().getleadDeatilsLeadData[index].Followup_Date_Time}",
                            ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  )),
            ),
          ],
        );
      } else if (index ==
          context.read<DashboardController>().getleadDeatilsLeadData.length -
              1) {
        log("2");
        return Column(
          children: [
            TimelineTile(
              isLast: true,
              lineXY: 0.2,
              alignment: TimelineAlign.manual,
              indicatorStyle: IndicatorStyle(
                width: 30,
                color: theme.primaryColor,
                // indicatorXY: 0.7,
                padding: const EdgeInsets.all(4),
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData: context
                              .read<DashboardController>()
                              .getleadDeatilsLeadData[index]
                              .FollowMode ==
                          'Phone Call'
                      ? Icons.call
                      : context
                                  .read<DashboardController>()
                                  .getleadDeatilsLeadData[index]
                                  .FollowMode ==
                              'Sms/WhatsApp'
                          ? Icons.message
                          : context
                                      .read<DashboardController>()
                                      .getleadDeatilsLeadData[index]
                                      .FollowMode ==
                                  'Store Visit'
                              ? Icons.store
                              : Icons.chat,
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.grey,
                thickness: 3,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.grey,
                thickness: 3,
              ),
              endChild: Container(
                alignment: Alignment.centerLeft,
                width: Screens.width(context) * 0.6,
                padding: EdgeInsets.only(
                    left: Screens.width(context) * 0.02,
                    right: Screens.width(context) * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.01,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${context.read<DashboardController>().getleadDeatilsLeadData[index].Status} ",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.01,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // context.read<DashboardController>().config.alignDate(
                        "By ${context.read<DashboardController>().getleadDeatilsLeadData[index].UpdatedBy} through ${context.read<DashboardController>().getleadDeatilsLeadData[index].FollowMode}", //),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            // color: theme.primaryColor,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.01,
                    ),
                    context
                            .watch<DashboardController>()
                            .getleadDeatilsLeadData[index]
                            .Feedback!
                            .isEmpty
                        ? const SizedBox()
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // context.read<DashboardController>().config.alignDate(
                              "# ${context.read<DashboardController>().getleadDeatilsLeadData[index].Feedback}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // color: theme.primaryColor,
                                  ),
                            ),
                          ),
                  ],
                ),
              ),
              startChild: Container(
                  padding: EdgeInsets.only(
                      left: Screens.width(context) * 0.02,
                      right: Screens.width(context) * 0.02),
                  width: Screens.width(context) * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Screens.bodyheight(context) * 0.01,
                      ),
                      Text(
                        context.read<DashboardController>().config.alignDate2(
                              "${context.read<DashboardController>().getleadDeatilsLeadData[index].Followup_Date_Time}",
                            ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  )),
            ),
          ],
        );
      } else {
        log("3");
        return Column(
          children: [
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              indicatorStyle: IndicatorStyle(
                width: 30,
                color: theme.primaryColor,
                //   indicatorXY:  0.7,
                padding: const EdgeInsets.all(4),
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData: context
                              .read<DashboardController>()
                              .getleadDeatilsLeadData[index]
                              .FollowMode ==
                          'Phone Call'
                      ? Icons.call
                      : context
                                  .read<DashboardController>()
                                  .getleadDeatilsLeadData[index]
                                  .FollowMode ==
                              'Sms/WhatsApp'
                          ? Icons.message
                          : context
                                      .read<DashboardController>()
                                      .getleadDeatilsLeadData[index]
                                      .FollowMode ==
                                  'Store Visit'
                              ? Icons.store
                              : Icons.chat,
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.grey,
                thickness: 3,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.grey,
                thickness: 3,
              ),
              endChild: SizedBox(
                // color: Colors.red,
                width: Screens.width(context) * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${context.read<DashboardController>().getleadDeatilsLeadData[index].Status} ",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.01,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // context.read<DashboardController>().config.alignDate(
                        "By ${context.read<DashboardController>().getleadDeatilsLeadData[index].UpdatedBy} through ${context.read<DashboardController>().getleadDeatilsLeadData[index].FollowMode}", //),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            // color: theme.primaryColor,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: Screens.bodyheight(context) * 0.01,
                    ),
                    context
                            .watch<DashboardController>()
                            .getleadDeatilsLeadData[index]
                            .Feedback!
                            .isEmpty
                        ? const SizedBox()
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // context.read<DashboardController>().config.alignDate(
                              "# ${context.read<DashboardController>().getleadDeatilsLeadData[index].Feedback}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // color: theme.primaryColor,
                                  ),
                            ),
                          ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              startChild: Container(
                  //  color: Colors.red,
                  padding: EdgeInsets.only(
                      left: Screens.width(context) * 0.02,
                      right: Screens.width(context) * 0.02),
                  width: Screens.width(context) * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.read<DashboardController>().config.alignDate2(
                              "${context.read<DashboardController>().getleadDeatilsLeadData[index].Followup_Date_Time}",
                            ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  )),
            ),
          ],
        );
      }
    });
  }
  //phonecallApi

  List<Widget> listContainersCustomerTag(
      ThemeData theme, BuildContext context) {
    return List.generate(
      context.watch<DashboardController>().getleadphonedata.length,
      (index) => InkWell(
        onTap: () {
          // context.read<LeadNewController>(). isSelectedenquirytype = context.read<LeadNewController>()
          // .getenqReffList[index].Name.toString();
          context.read<DashboardController>().selectFollowUp(
              context
                  .read<DashboardController>()
                  .getleadphonedata[index]
                  .name
                  .toString(),
              context
                  .read<DashboardController>()
                  .getleadphonedata[index]
                  .code
                  .toString());
        },
        child: Container(
          width: Screens.width(context) * 0.4,
          height: Screens.bodyheight(context) * 0.05,
          //  padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  context.watch<DashboardController>().isSelectedFollowUpcode ==
                          context
                              .read<DashboardController>()
                              .getleadphonedata[index]
                              .code
                              .toString()
                      ? theme.primaryColor //theme.primaryColor.withOpacity(0.5)
                      : Colors.white,
              border: Border.all(color: theme.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  context
                      .watch<DashboardController>()
                      .getleadphonedata[index]
                      .name
                      .toString(),
                  maxLines: 8,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: context
                                .watch<DashboardController>()
                                .isSelectedFollowUpcode ==
                            context
                                .read<DashboardController>()
                                .getleadphonedata[index]
                                .code
                                .toString()
                        ? Colors.white //,Colors.white
                        : theme.primaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  //openApi
  List<Widget> listContainersOpenTag(ThemeData theme, BuildContext context) {
    return List.generate(
      context.watch<DashboardController>().getleadopendata.length,
      (index) => InkWell(
        onTap: () {
          // context.read<LeadNewController>(). isSelectedenquirytype = context.read<LeadNewController>()
          // .getenqReffList[index].Name.toString();

          context.read<DashboardController>().caseStatusSelectBtn(
              context
                  .read<DashboardController>()
                  .getleadopendata[index]
                  .name
                  .toString(),
              context
                  .read<DashboardController>()
                  .getleadopendata[index]
                  .code
                  .toString());
          context.read<DashboardController>().validatebtnChanged();
          // context.read<DashboardController>().selectFollowUp(context
          //     .read<DashboardController>()
          //     .getleadopendata[index]
          //     .name
          //     .toString(),context
          //     .read<DashboardController>()
          //     .getleadopendata[index]
          //     .code
          //     .toString());
          // log(context.read<LeadNewController>().getisSelectedCsTag.toString());
          // log(context
          //     .read<LeadNewController>()
          //     .getCusTagList[index]
          //     .Name
          //     .toString());
        },
        child: Container(
          width: Screens.width(context) * 0.26,
          height: Screens.bodyheight(context) * 0.06,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  context.watch<DashboardController>().getcaseStatusSelected ==
                          context
                              .read<DashboardController>()
                              .getleadopendata[index]
                              .name
                              .toString()
                      ? const Color(
                          0xffFCF752) //theme.primaryColor.withOpacity(0.5)
                      : theme.primaryColor,
              border: Border.all(
                color: theme.primaryColor,
              ),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
              context
                  .watch<DashboardController>()
                  .getleadopendata[index]
                  .name
                  .toString(),
              maxLines: 8,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: context
                            .watch<DashboardController>()
                            .getcaseStatusSelected ==
                        context
                            .read<DashboardController>()
                            .getleadopendata[index]
                            .name
                            .toString()
                    ? Colors.black //,Colors.white
                    : Colors.white,
              )),
        ),
      ),
    );
  }
  //forwar dialog

  SizedBox viewOutstandingdetails(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: Screens.width(context),
      // height: Screens.bodyheight(context),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: Screens.width(context),
              height: Screens.padingHeight(context) * 0.06,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                  ),
                  child: const Text("View Details"))),
          SizedBox(
            height: Screens.padingHeight(context) * 0.01,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Screens.width(context) * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                context.watch<DashboardController>().outstandingkpi.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: Screens.width(context),
                        padding: EdgeInsets.symmetric(
                            horizontal: Screens.width(context) * 0.01,
                            vertical: Screens.bodyheight(context) * 0.008),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black26)),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Screens.width(context) * 0.45,
                              // height:Screens.padingHeight(context)*0.2 ,
                              // color: Colors.amber,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height:
                                        Screens.padingHeight(context) * 0.03,
                                    child: const Text("Customer Info"),
                                  ),
                                  const Divider(
                                    color: Colors.black26,
                                  ),
                                  Text(
                                    "Name ",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    "${context.watch<DashboardController>().ontapKpi2[0].CustomerName}",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    "Phone ",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    "${context.watch<DashboardController>().ontapKpi2[0].CustomerCode}",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    "City/State ",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    "${context.watch<DashboardController>().ontapKpi2[0].Bil_City},${context.read<DashboardController>().ontapKpi2[0].Bil_State == null || context.read<DashboardController>().ontapKpi2[0].Bil_State == "null" ? "" : context.read<DashboardController>().ontapKpi2[0].Bil_State}",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                                width: Screens.width(context) * 0.001,
                                color: Colors.red,
                                thickness: 10.0),
                            SizedBox(
                              width: Screens.width(context) * 0.40,
                              // height:Screens.padingHeight(context)*0.2 ,
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height:
                                        Screens.padingHeight(context) * 0.03,
                                    child: const Text("Outstanding"),
                                  ),
                                  const Divider(
                                    color: Colors.black26,
                                  ),
                                  Text(
                                    "TotalOutStanding",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    context
                                        .read<DashboardController>()
                                        .config
                                        .slpitCurrency22(context
                                            .watch<DashboardController>()
                                            .totaloutstanding
                                            .toString()),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    "Overdue",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    context
                                        .read<DashboardController>()
                                        .config
                                        .slpitCurrency22(context
                                            .watch<DashboardController>()
                                            .overdue
                                            .toString()),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    "Upcoming",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    context
                                        .read<DashboardController>()
                                        .config
                                        .slpitCurrency22(context
                                            .watch<DashboardController>()
                                            .upcoming
                                            .toString()),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.002,
                ),
                const Divider(
                  color: Colors.black26,
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.002,
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.45,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context
                          .read<DashboardController>()
                          .outstandingkpi
                          .length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Screens.width(context) * 0.01,
                              vertical: Screens.padingHeight(context) * 0.002),
                          child: Container(
                            width: Screens.width(context),
                            padding: EdgeInsets.symmetric(
                                horizontal: Screens.width(context) * 0.02,
                                vertical: Screens.padingHeight(context) * 0.01),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black26)),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Trans Number",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    "Date",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${context.read<DashboardController>().outstandingkpi[i].TransNum}",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    context
                                        .read<DashboardController>()
                                        .config
                                        .alignDate(context
                                            .read<DashboardController>()
                                            .outstandingkpi[i]
                                            .TransDate
                                            .toString()),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Screens.padingHeight(context) * 0.002,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Trans Ref Number",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    "Age",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${context.read<DashboardController>().outstandingkpi[i].TransRef1}",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    "${context.read<DashboardController>().outstandingkpi[i].age!.toInt()}",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Screens.padingHeight(context) * 0.002,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Trans Total",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    "Balance to Pay",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context
                                        .read<DashboardController>()
                                        .config
                                        .slpitCurrency22(context
                                            .read<DashboardController>()
                                            .outstandingkpi[i]
                                            .TransAmount!
                                            .toString()),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  Text(
                                    context
                                        .read<DashboardController>()
                                        .config
                                        .slpitCurrency22(context
                                            .read<DashboardController>()
                                            .outstandingkpi[i]
                                            .BalanceToPay!
                                            .toString()),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddtoContact extends StatelessWidget {
  const AddtoContact({
    super.key,
    // required this.context,
    // required this.theme,
  });

  // final BuildContext context;
  // final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: Screens.width(context),
      height: Screens.bodyheight(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    // fontSize: 12,
                    ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )), //Radius.circular(6)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(""),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Add to Contact",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.87,
            padding: EdgeInsets.only(
              top: Screens.bodyheight(context) * 0.01,
              bottom: Screens.bodyheight(context) * 0.01,
              left: Screens.width(context) * 0.03,
              right: Screens.width(context) * 0.03,
            ),
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextform(
                    // controller: context
                    //                           .read<NewEnqController>()
                    //                           .mycontroller[9],
                    // decoration: InputDecoration(
                    // hintText: 'Potential Value',
                    labelText: 'Mobile Number',
                    border: UnderlineInputBorder(),
                    enableborder: EnableBorderType.type2,
                    focusborder: FocusBorderType.type2,
                    errorborder: ErrorBorderType.type2,
                    focusErrorborderType: FocusErrorBorderType.type2,
                  ),
                  CustomTextform(
                    // controller: context
                    //                           .read<NewEnqController>()
                    //                           .mycontroller[9],
                    // decoration: InputDecoration(
                    // hintText: 'Potential Value',
                    labelText: 'Contact Name',
                    border: UnderlineInputBorder(),
                    enableborder: EnableBorderType.type2,
                    focusborder: FocusBorderType.type2,
                    errorborder: ErrorBorderType.type2,
                    focusErrorborderType: FocusErrorBorderType.type2,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
                onPressed: () {
                  // context.read<DashboardController>().viweDetailsClicked();
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                      // fontSize: 12,
                      ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )), //Radius.circular(6)
                ),
                child: const Text("Save")),
          ),
        ],
      ),
    );
  }
}
