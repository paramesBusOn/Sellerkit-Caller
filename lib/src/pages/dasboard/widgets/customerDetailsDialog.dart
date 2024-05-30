// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sellerkitcalllog/helpers/Configuration.dart';
// import 'package:sellerkitcalllog/helpers/screen.dart';
// import 'package:sellerkitcalllog/src/controller/dashboardController/dashboardController.dart';
// import 'package:sellerkitcalllog/src/pages/dasboard/widgets/pdfView.dart';

// class CustomerDetailsViewBox extends StatefulWidget {
//   const CustomerDetailsViewBox({
//     Key? key,
//     required this.mobileno,
//   }) : super(key: key);
//   // List<GetenquiryData>? customerDatalist;
//   // List<GetCustomerData>? customerdetails;

//   final String? mobileno;
//   @override
//   State<CustomerDetailsViewBox> createState() => _CustomerDetailsViewBoxState();
// }

// class _CustomerDetailsViewBoxState extends State<CustomerDetailsViewBox> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // context
//       //     .read<DashboardController>()
//       //     .
//       setState(() {
//         //  DashboardController.setArgument(context, widget.mobileno!);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // DashboardController dashbordCnt = Provider.of<DashboardController>(context);
//     final theme = Theme.of(context);

//     return Provider<DashboardController>(
//         create: (_) => DashboardController(),
//         // we use `builder` to obtain a new `BuildContext` that has access to the provider
//         builder: (context, child) {
//           return AlertDialog(
//               insetPadding: EdgeInsets.all(10),
//               contentPadding: EdgeInsets.all(0),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),

//               // title: Text("hi"),
//               content: (context.read<DashboardController>().viewDefault ==
//                           false &&
//                       context.read<DashboardController>().viewLeadDtls ==
//                           false &&
//                       context
//                               .read<DashboardController>()
//                               .viewOutStatndingDtls ==
//                           false &&
//                       context.watch<DashboardController>().viewOrderDtls ==
//                           true)
//                   ? orderDetailsDialog(context)
//                   : (context.watch<DashboardController>().viewDefault ==
//                               false &&
//                           context.watch<DashboardController>().viewLeadDtls ==
//                               true &&
//                           context
//                                   .watch<DashboardController>()
//                                   .viewOutStatndingDtls ==
//                               false &&
//                           context.watch<DashboardController>().viewOrderDtls ==
//                               false)
//                       ? updateLeadDialog(context, theme, 'docentry',
//                           context.watch<DashboardController>())
//                       : viewDefault(context, theme));
//         });
//   }

//   SizedBox viewDefault(BuildContext context, ThemeData theme) {
//     Config config = Config();
//     return SizedBox(
//       width: Screens.width(context),
//       // height: Screens.bodyheight(context),

//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//                 width: Screens.width(context),
//                 height: Screens.padingHeight(context) * 0.06,
//                 child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       )),
//                     ),
//                     child: Text("View Details"))),
//             SizedBox(
//               height: Screens.padingHeight(context) * 0.01,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: Screens.width(context) * 0.02),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
//                   // widget.customerdetails!.isEmpty
//                   //     ? Center(
//                   //         child: CircularProgressIndicator(),
//                   //       )
//                   //     : Container(
//                   //         width: Screens.width(context),
//                   //         padding: EdgeInsets.symmetric(
//                   //             horizontal: Screens.width(context) * 0.01,
//                   //             vertical: Screens.bodyheight(context) * 0.008),
//                   //         decoration: BoxDecoration(
//                   //             color: Colors.grey[200],
//                   //             borderRadius: BorderRadius.circular(8),
//                   //             border: Border.all(color: Colors.black26)),
//                   //         child: IntrinsicHeight(
//                   //           child: Row(
//                   //             // crossAxisAlignment: CrossAxisAlignment.start,
//                   //             children: [
//                   //               SizedBox(
//                   //                 width: Screens.width(context) * 0.45,
//                   //                 // height:Screens.padingHeight(context)*0.2 ,
//                   //                 // color: Colors.amber,
//                   //                 child: Column(
//                   //                   crossAxisAlignment:
//                   //                       CrossAxisAlignment.start,
//                   //                   children: [
//                   //                     SizedBox(
//                   //                       height: Screens.padingHeight(context) *
//                   //                           0.03,
//                   //                       child: Text("Customer Info"),
//                   //                     ),
//                   //                     Divider(
//                   //                       color: Colors.black26,
//                   //                     ),
//                   //                     Text(
//                   //                       "Name ",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(color: Colors.grey),
//                   //                     ),
//                   //                     Text(
//                   //                       '${widget.customerdetails![0].customerName}',
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(
//                   //                               color: theme.primaryColor),
//                   //                     ),
//                   //                     Text(
//                   //                       "Phone ",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(color: Colors.grey),
//                   //                     ),
//                   //                     Text(
//                   //                       "${widget.customerdetails![0].customerCode}",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(
//                   //                               color: theme.primaryColor),
//                   //                     ),
//                   //                     Text(
//                   //                       "City/State ",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(color: Colors.grey),
//                   //                     ),
//                   //                     Text(
//                   //                       "${widget.customerdetails![0].City},${widget.customerdetails![0].State == null || widget.customerdetails![0].State == "null" ? "" : widget.customerdetails![0].State}",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(
//                   //                               color: theme.primaryColor),
//                   //                     ),
//                   //                   ],
//                   //                 ),
//                   //               ),
//                   //               // VerticalDivider(
//                   //               //     width: Screens.width(context) * 0.001,
//                   //               //     color: Colors.red,
//                   //               //     thickness: 10.0),
//                   //               SizedBox(
//                   //                 width: Screens.width(context) * 0.40,
//                   //                 // height:Screens.padingHeight(context)*0.2 ,
//                   //                 // color: Colors.red,
//                   //                 child: Column(
//                   //                   crossAxisAlignment:
//                   //                       CrossAxisAlignment.start,
//                   //                   children: [
//                   //                     SizedBox(
//                   //                       height: Screens.padingHeight(context) *
//                   //                           0.03,
//                   //                       child: Text(""),
//                   //                     ),
//                   //                     Divider(
//                   //                       color: Colors.black26,
//                   //                     ),
//                   //                     Text(
//                   //                       "Status",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(color: Colors.grey),
//                   //                     ),
//                   //                     Text(
//                   //                       "${widget.customerdetails![0].status}",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(
//                   //                               color: theme.primaryColor),
//                   //                     ),
//                   //                     Text(
//                   //                       "Potential Value",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(color: Colors.grey),
//                   //                     ),
//                   //                     Text(
//                   //                       "${widget.customerdetails![0].PotentialValue}",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(
//                   //                               color: theme.primaryColor),
//                   //                     ),
//                   //                     Text(
//                   //                       "Email",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(color: Colors.grey),
//                   //                     ),
//                   //                     Text(
//                   //                       "${widget.customerdetails![0].email}",
//                   //                       style: theme.textTheme.bodyMedium!
//                   //                           .copyWith(
//                   //                               color: theme.primaryColor),
//                   //                     ),
//                   //                   ],
//                   //                 ),
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //       ),
//                   // SizedBox(
//                   //   height: Screens.padingHeight(context) * 0.002,
//                   // ),
//                   // Divider(
//                   //   color: Colors.black26,
//                   // ),
//                   // SizedBox(
//                   //   height: Screens.padingHeight(context) * 0.002,
//                   // ),
//                   // SizedBox(
//                   //   height: Screens.padingHeight(context) * 0.45,
//                   //   child: widget.customerDatalist!.isEmpty
//                   //       ? Container()
//                   //       : ListView.builder(
//                   //           shrinkWrap: true,
//                   //           itemCount: widget.customerDatalist!.length,
//                   //           itemBuilder: (BuildContext context, int i) {
//                   //             final customerDatalist =
//                   //                 widget.customerDatalist![i];
//                   //             return InkWell(
//                   //               onDoubleTap: () async {
//                   //                 await context
//                   //                     .read<DashboardController>()
//                   //                     .viewDetailsMethod(
//                   //                         customerDatalist.DocNum.toString(),
//                   //                         customerDatalist.DocType!);
//                   //               },
//                   //               child: Container(
//                   //                 padding: EdgeInsets.symmetric(
//                   //                     horizontal: Screens.width(context) * 0.01,
//                   //                     vertical: Screens.padingHeight(context) *
//                   //                         0.002),
//                   //                 child: Container(
//                   //                   width: Screens.width(context),
//                   //                   padding: EdgeInsets.symmetric(
//                   //                       horizontal:
//                   //                           Screens.width(context) * 0.02,
//                   //                       vertical:
//                   //                           Screens.padingHeight(context) *
//                   //                               0.01),
//                   //                   decoration: BoxDecoration(
//                   //                       color: Colors.grey[200],
//                   //                       borderRadius: BorderRadius.circular(5),
//                   //                       border:
//                   //                           Border.all(color: Colors.black26)),
//                   //                   child: Column(children: [
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                           MainAxisAlignment.spaceBetween,
//                   //                       children: [
//                   //                         Text(
//                   //                           "Doc Number",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(color: Colors.grey),
//                   //                         ),
//                   //                         Text(
//                   //                           "Doc Date",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(color: Colors.grey),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                           MainAxisAlignment.spaceBetween,
//                   //                       children: [
//                   //                         Text(
//                   //                           "${customerDatalist.DocNum}",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(
//                   //                                   color: theme.primaryColor),
//                   //                         ),
//                   //                         Text(
//                   //                           config.alignDate(customerDatalist
//                   //                               .DocDate.toString()),
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(
//                   //                                   color: theme.primaryColor),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                     SizedBox(
//                   //                       height: Screens.padingHeight(context) *
//                   //                           0.002,
//                   //                     ),
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                           MainAxisAlignment.spaceBetween,
//                   //                       children: [
//                   //                         Text(
//                   //                           "Doc Type",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(color: Colors.grey),
//                   //                         ),
//                   //                         Text(
//                   //                           "Status",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(color: Colors.grey),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                           MainAxisAlignment.spaceBetween,
//                   //                       children: [
//                   //                         Text(
//                   //                           "${customerDatalist.DocType}",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(
//                   //                                   color: theme.primaryColor),
//                   //                         ),
//                   //                         Text(
//                   //                           "${customerDatalist.Status}",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(
//                   //                                   color: theme.primaryColor),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                     SizedBox(
//                   //                       height: Screens.padingHeight(context) *
//                   //                           0.002,
//                   //                     ),
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                           MainAxisAlignment.spaceBetween,
//                   //                       children: [
//                   //                         Text(
//                   //                           "Assigned To",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(color: Colors.grey),
//                   //                         ),
//                   //                         Text(
//                   //                           "Business Value",
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(color: Colors.grey),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                     Row(
//                   //                       mainAxisAlignment:
//                   //                           MainAxisAlignment.spaceBetween,
//                   //                       children: [
//                   //                         Text(
//                   //                           customerDatalist.AssignedTo
//                   //                               .toString(),
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(
//                   //                                   color: theme.primaryColor),
//                   //                         ),
//                   //                         Text(
//                   //                           config.slpitCurrency22(
//                   //                               customerDatalist.BusinessValue
//                   //                                   .toString()),
//                   //                           style: theme.textTheme.bodyMedium!
//                   //                               .copyWith(
//                   //                                   color: theme.primaryColor),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                   ]),
//                   //                 ),
//                   //               ),
//                   //             );
//                   //           }),
//                   // )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   SizedBox orderDetailsDialog(BuildContext context) {
//     final theme = Theme.of(context);
//     return SizedBox(
//       width: Screens.width(context),
//       // height: Screens.bodyheight(context),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: Screens.width(context),
//             height: Screens.bodyheight(context) * 0.06,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 textStyle: TextStyle(
//                     // fontSize: 12,
//                     ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                 )), //Radius.circular(6)
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     child: Text(""),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     child: Text("Order Details",
//                         style: theme.textTheme.bodyMedium
//                             ?.copyWith(color: Colors.white)),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                         alignment: Alignment.centerRight,
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                         )),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: Screens.width(context),
//             height: Screens.bodyheight(context) * 0.87,
//             padding: EdgeInsets.only(
//               top: Screens.bodyheight(context) * 0.01,
//               bottom: Screens.bodyheight(context) * 0.01,
//               left: Screens.width(context) * 0.03,
//               right: Screens.width(context) * 0.01,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: Screens.width(context) * 0.4,
//                         child: Text(
//                           "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].CardName}",
//                           style: theme.textTheme.bodyMedium?.copyWith(),
//                         ),
//                       ),
//                       Container(
//                         width: Screens.width(context) * 0.4,
//                         alignment: Alignment.centerRight,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 4, vertical: 3),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(3),
//                           color: Color(0xffC6AC5F),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Open since "
//                             "${context.read<DashboardController>().config.subtractDateTime2(
//                                 // "2020-05-18T00:00:00"
//                                 "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].OrderCreatedDate}")}",
//                             textAlign: TextAlign.center,
//                             style: theme.textTheme.bodyMedium?.copyWith(),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: Screens.width(context) * 0.4,
//                         child: Text(
//                           "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].Address1}",
//                           style: theme.textTheme.bodyMedium?.copyWith(),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         width: Screens.width(context) * 0.43,
//                         child: Text(
//                           "Worth of Rs."
//                           "${context.watch<DashboardController>().config.slpitCurrency22(
//                                 context
//                                     .watch<DashboardController>()
//                                     .getOrderDeatilsQTHData[0]
//                                     .DocTotal!
//                                     .toString(),
//                               )}"
//                           '/-',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: theme.primaryColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: Screens.width(context) * 0.4,
//                         child: Text(
//                           "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].Address2}",
//                           style: theme.textTheme.bodyMedium?.copyWith(),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         width: Screens.width(context) * 0.4,
//                         child: Text(
//                           "# ${context.watch<DashboardController>().getOrderDeatilsQTHData[0].OrderNum}",
//                           style: theme.textTheme.bodyMedium?.copyWith(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: Screens.width(context) * 0.4,
//                         child: Text(
//                           "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].City}",
//                           style: theme.textTheme.bodyMedium?.copyWith(),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         width: Screens.width(context) * 0.4,
//                         child: Text(
//                           "Created on ${context.watch<DashboardController>().config.alignDate3("${context.watch<DashboardController>().getOrderDeatilsQTHData[0].OrderCreatedDate}" //.LastFUPUpdate
//                               )}",
//                           style: theme.textTheme.bodyMedium?.copyWith(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       context
//                                       .watch<DashboardController>()
//                                       .getOrderDeatilsQTHData[0]
//                                       .CardCode ==
//                                   null ||
//                               context
//                                       .watch<DashboardController>()
//                                       .getOrderDeatilsQTHData[0]
//                                       .CardCode ==
//                                   "null" ||
//                               context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .CardCode!
//                                   .isEmpty
//                           ? Container()
//                           : InkWell(
//                               onTap: () {
//                                 context
//                                     .read<DashboardController>()
//                                     .makePhoneCall(context
//                                         .read<DashboardController>()
//                                         .getOrderDeatilsQTHData[0]
//                                         .CardCode!);
//                               },
//                               child: SizedBox(
//                                 width: Screens.width(context) * 0.4,
//                                 child: Text(
//                                   "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].CardCode}",
//                                   style: theme.textTheme.bodyMedium?.copyWith(
//                                       decoration: TextDecoration.underline,
//                                       color: Colors.blue),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),

//                   // createTable(theme),

//                   SizedBox(
//                     height: Screens.bodyheight(context) * 0.01,
//                   ),

//                   SizedBox(
//                     height: Screens.bodyheight(context) * 0.015,
//                   ),
//                   createTable(theme),
//                   Divider(
//                     thickness: 1,
//                   ),
//                   SizedBox(
//                     height: Screens.bodyheight(context) * 0.01,
//                   ),
//                   //

//                   Container(
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               // color: Colors.amber,
//                               width: Screens.width(context) * 0.4,
//                               // height: Screens.padingHeight(context),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Delivery Address :",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: theme.primaryColor),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Text(
//                                     "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Address1}",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: Colors.black),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Text(
//                                     "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Address2}",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: Colors.black),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Text(
//                                     "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Area}",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: Colors.black),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Text(
//                                     "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_City}",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: Colors.black),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Text(
//                                     "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_State}",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: Colors.black),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Text(
//                                     "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].del_Pincode}",
//                                     style: theme.textTheme.bodyMedium!
//                                         .copyWith(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               //  color: Colors.red,
//                               width: Screens.width(context) * 0.5,

//                               // height: Screens.padingHeight(context),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         child: Text(
//                                           "Sub Total",
//                                           style: theme.textTheme.bodyMedium!
//                                               .copyWith(color: Colors.grey),
//                                         ),
//                                       ),
//                                       Text(
//                                         context
//                                             .read<DashboardController>()
//                                             .config
//                                             .slpitCurrency22(context
//                                                 .watch<DashboardController>()
//                                                 .getOrderDeatilsQTHData[0]
//                                                 .subtotal!
//                                                 .toString()),
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Base Amount",
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.grey),
//                                       ),
//                                       Text(
//                                         context
//                                             .read<DashboardController>()
//                                             .config
//                                             .slpitCurrency22(context
//                                                 .watch<DashboardController>()
//                                                 .getOrderDeatilsQTHData[0]
//                                                 .basetotal!
//                                                 .toString()),
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Tax Amount",
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.grey),
//                                       ),
//                                       Text(
//                                         context
//                                             .read<DashboardController>()
//                                             .config
//                                             .slpitCurrency22(context
//                                                 .watch<DashboardController>()
//                                                 .getOrderDeatilsQTHData[0]
//                                                 .taxAmount!
//                                                 .toString()),
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Round Off",
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.grey),
//                                       ),
//                                       Text(
//                                         context
//                                             .read<DashboardController>()
//                                             .config
//                                             .slpitCurrency22(context
//                                                 .watch<DashboardController>()
//                                                 .getOrderDeatilsQTHData[0]
//                                                 .RoundOff!
//                                                 .toString()),
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         Screens.padingHeight(context) * 0.01,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Total Amount",
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.grey),
//                                       ),
//                                       Text(
//                                         context
//                                             .read<DashboardController>()
//                                             .config
//                                             .slpitCurrency22(context
//                                                 .watch<DashboardController>()
//                                                 .getOrderDeatilsQTHData[0]
//                                                 .DocTotal!
//                                                 .toString()),
//                                         style: theme.textTheme.bodyMedium!
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),

//                   SizedBox(
//                     height: Screens.padingHeight(context) * 0.02,
//                   ),
//                   context
//                               .watch<DashboardController>()
//                               .getOrderDeatilsQTHData[0]
//                               .isDelivered ==
//                           1
//                       ? Container(
//                           width: Screens.width(context),
//                           padding: EdgeInsets.symmetric(
//                               // horizontal: Screens.width(context) * 0.03,
//                               vertical: Screens.bodyheight(context) * 0.02),
//                           decoration: BoxDecoration(
//                               color: theme.primaryColor.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black26)),
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: Screens.width(context) * 0.8,
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   "Delivered on ${context.watch<DashboardController>().config.alignDate('${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryDate}')} by referenced ${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryNo}",
//                                   style: theme.textTheme.bodyMedium!
//                                       .copyWith(color: Colors.black),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       : Container(),
//                   SizedBox(
//                     height: Screens.padingHeight(context) * 0.01,
//                   ),

//                   context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .isDelivered ==
//                               1 &&
//                           context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .DeliveryURL1 !=
//                               null &&
//                           context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .DeliveryURL2 !=
//                               null
//                       ? Container(
//                           width: Screens.width(context),
//                           padding: EdgeInsets.symmetric(
//                               // horizontal: Screens.width(context) * 0.03,
//                               vertical: Screens.bodyheight(context) * 0.02),
//                           decoration: BoxDecoration(
//                               // color: theme.primaryColor.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black26)),
//                           child: Column(
//                             children: [
//                               Text(
//                                   "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryURL1}"),
//                               SizedBox(
//                                 height: Screens.bodyheight(context) * 0.01,
//                               ),
//                               Text(
//                                   "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].DeliveryURL2}"),
//                             ],
//                           ),
//                         )
//                       : Container(),
//                   // Wrap(
//                   //     spacing: 0.0, // width
//                   //     runSpacing: 0.0, // height
//                   //     children: listTimeLine(theme)),
//                   SizedBox(
//                     height: Screens.bodyheight(context) * 0.01,
//                   ),
//                   context
//                               .watch<DashboardController>()
//                               .getOrderDeatilsQTHData[0]
//                               .isInvoiced ==
//                           1
//                       ? Container(
//                           width: Screens.width(context),
//                           padding: EdgeInsets.symmetric(
//                               // horizontal: Screens.width(context) * 0.03,
//                               vertical: Screens.bodyheight(context) * 0.02),
//                           decoration: BoxDecoration(
//                               color: theme.primaryColor.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black26)),
//                           child: Column(
//                             children: [
//                               Container(
//                                 alignment: Alignment.centerLeft,
//                                 width: Screens.width(context) * 0.8,
//                                 child: Text(
//                                   "Invoiced on ${context.watch<DashboardController>().config.alignDate('${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceDate}')} by referenced ${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceNo}",
//                                   style: theme.textTheme.bodyMedium!
//                                       .copyWith(color: Colors.black),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       : Container(),
//                   SizedBox(
//                     height: Screens.padingHeight(context) * 0.01,
//                   ),

//                   (context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .isInvoiced ==
//                               1) &&
//                           (context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .InvoiceURL1 !=
//                               null) &&
//                           (context
//                                   .watch<DashboardController>()
//                                   .getOrderDeatilsQTHData[0]
//                                   .InvoiceURL2 !=
//                               null)
//                       ? Container(
//                           width: Screens.width(context),
//                           padding: EdgeInsets.symmetric(
//                               // horizontal: Screens.width(context) * 0.03,
//                               vertical: Screens.bodyheight(context) * 0.02),
//                           decoration: BoxDecoration(
//                               // color: theme.primaryColor.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black26)),
//                           child: Column(
//                             children: [
//                               Text(
//                                   "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceURL1}"),
//                               SizedBox(
//                                 height: Screens.bodyheight(context) * 0.01,
//                               ),
//                               Text(
//                                   "${context.watch<DashboardController>().getOrderDeatilsQTHData[0].InvoiceURL2}"),
//                             ],
//                           ),
//                         )
//                       : Container(),

//                   InkWell(
//                     onTap: () async {
//                       await context
//                           .read<DashboardController>()
//                           .callcustomerapi();
//                       for (int i = 0;
//                           i <
//                               context
//                                   .read<DashboardController>()
//                                   .paymode
//                                   .length;
//                           i++) {
//                         if (context
//                                 .read<DashboardController>()
//                                 .paymode[i]
//                                 .CODE ==
//                             context
//                                 .read<DashboardController>()
//                                 .getOrderDeatilsQTHData[0]
//                                 .PaymentTerms) {
//                           pdfviewState.paymode = context
//                               .read<DashboardController>()
//                               .paymode[i]
//                               .description
//                               .toString();
//                         }
//                       }

//                       pdfviewState.data = context
//                           .read<DashboardController>()
//                           .getOrderDeatilsQTLData;
//                       pdfviewState.orderMasterdata2 = context
//                           .read<DashboardController>()
//                           .getOrderDeatilsQTHData;
//                       pdfviewState.customermodeldata =
//                           context.read<DashboardController>().customermodeldata;

//                       // PdfPreview(build: (format)=>pdfState().generatePdf(format, 'title'),);
//                       // pdfviewState.paymode=paymode;
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => pdfview()));
//                     },
//                     child: Container(
//                       child: Text(
//                         "Convert as Pdf",
//                         textAlign: TextAlign.end,
//                         style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             width: Screens.width(context),
//             height: Screens.bodyheight(context) * 0.06,
//             child: ElevatedButton(
//                 onPressed: () {
//                   context.read<DashboardController>().setviewBool('');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   textStyle: TextStyle(
//                       // fontSize: 12,
//                       ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   )), //Radius.circular(6)
//                 ),
//                 child: Text("Close")),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget createTable(ThemeData theme) {
//     List<TableRow> rows = [];
//     rows.add(TableRow(children: [
//       Container(
//         color: theme.primaryColor,
//         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//         child: Text(
//           "Product",
//           style: theme.textTheme.bodyMedium
//               ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
//           textAlign: TextAlign.left,
//         ),
//       ),
//       Container(
//         color: theme.primaryColor,
//         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//         child: Text(
//           "Price",
//           style: theme.textTheme.bodyMedium
//               ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
//           textAlign: TextAlign.left,
//         ),
//       ),
//       Container(
//         color: theme.primaryColor,
//         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//         child: Text(
//           "Qty",
//           style: theme.textTheme.bodyMedium
//               ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
//           textAlign: TextAlign.left,
//         ),
//       ),
//     ]));
//     for (int i = 0;
//         i < context.watch<DashboardController>().getleadDeatilsQTLData.length;
//         ++i) {
//       rows.add(TableRow(children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           child: Text(
//             context
//                 .watch<DashboardController>()
//                 .getleadDeatilsQTLData[i]
//                 .ItemName!,
//             textAlign: TextAlign.left,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.primaryColor,
//             ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           child: Text(
//             context.watch<DashboardController>().config.slpitCurrency(context
//                 .watch<DashboardController>()
//                 .getleadDeatilsQTLData[i]
//                 .Price!
//                 .toStringAsFixed(0)),
//             // '${context.watch<DashboardController>().getleadDeatilsQTLData[i].Price!.toStringAsFixed(2)}',
//             textAlign: TextAlign.left,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.primaryColor,
//             ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           child: Text(
//             context
//                 .watch<DashboardController>()
//                 .getleadDeatilsQTLData[i]
//                 .Quantity!
//                 .toStringAsFixed(0),
//             textAlign: TextAlign.center,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.primaryColor,
//             ),
//           ),
//         ),
//       ]));
//     }
//     return Table(columnWidths: const {
//       0: FlexColumnWidth(4),
//       1: FlexColumnWidth(2.2),
//       2: FlexColumnWidth(0.8),
//     }, children: rows);
//   }

//   SizedBox updateLeadDialog(BuildContext context, ThemeData theme,
//       String docentry, DashboardController dashbordCnt) {
//     return SizedBox(
//       width: Screens.width(context),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//                 width: Screens.width(context),
//                 //  height: Screens.bodyheight(context)*0.5,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.only(
//                   left: Screens.width(context) * 0.05,
//                   right: Screens.width(context) * 0.05,
//                   top: Screens.bodyheight(context) * 0.03,
//                   //  bottom: Screens.bodyheight(context)*0.03,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         child: Text(
//                           // 'How you made the follow up?',
//                           dashbordCnt.followup!,
//                           style: theme.textTheme.bodyText2?.copyWith(
//                             color: dashbordCnt.getfollowup!.contains(" *")
//                                 ? Colors.red
//                                 : theme.primaryColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       Center(
//                         child: Wrap(
//                             spacing: 5.0, // width
//                             runSpacing: 10.0, // height
//                             children: listContainersCustomerTag(
//                               theme,
//                             )),
//                       ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       SizedBox(
//                         child: Text(
//                           "What is the case status now?",
//                           style: theme.textTheme.bodyText2
//                               ?.copyWith(color: theme.primaryColor),
//                         ),
//                       ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Center(
//                             child: Wrap(
//                                 spacing: 7.0, // width
//                                 runSpacing: 10.0, // height
//                                 children: listContainersOpenTag(
//                                   theme,
//                                 )),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       Visibility(
//                         visible: context
//                                     .watch<DashboardController>()
//                                     .getcaseStatusSelected ==
//                                 'Open'
//                             ? true
//                             : false,
//                         child: Column(
//                           children: [
//                             Container(
//                               width: Screens.width(context),
//                               // height: Screens.,
//                               padding:
//                                   EdgeInsets.only(top: 1, left: 10, right: 10),
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: DropdownButton(
//                                 hint: Text(
//                                   context
//                                       .watch<DashboardController>()
//                                       .gethinttextforOpenLead!,
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                       color: context
//                                               .watch<DashboardController>()
//                                               .gethinttextforOpenLead!
//                                               .contains(" *")
//                                           ? Colors.red
//                                           : Colors.black),
//                                 ),
//                                 value: context
//                                     .read<DashboardController>()
//                                     .valueChosedStatus,
//                                 //dropdownColor:Colors.green,
//                                 icon: Icon(Icons.arrow_drop_down),
//                                 iconSize: 30,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 16),
//                                 isExpanded: true,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     context
//                                         .read<DashboardController>()
//                                         .choosedStatus(val.toString());
//                                   });
//                                 },
//                                 items: context
//                                     .read<DashboardController>()
//                                     .leadStatusOpen
//                                     .map((e) {
//                                   return DropdownMenuItem(
//                                       // ignore: unnecessary_brace_in_string_interps
//                                       value: "${e.code}",
//                                       child: Container(
//                                           // height: Screens.bodyheight(context)*0.1,
//                                           child: Text("${e.name}")));
//                                 }).toList(),
//                               ),
//                             ),
//                             SizedBox(
//                               height: Screens.bodyheight(context) * 0.01,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                     child: Text(
//                                   "Plan of Purchase Date", // "Next Follow up",
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                     color:
//                                         // context
//                                         //         .watch<DashboardController>()
//                                         //         .getorderBillDate!
//                                         //         .contains(" *")
//                                         //     ? Colors.red
//                                         //     :
//                                         Colors.grey,
//                                   ), // fontSize: 12
//                                 )),
//                                 InkWell(
//                                   onTap: context
//                                               .read<DashboardController>()
//                                               .getcaseStatusSelected ==
//                                           'Open'
//                                       ? () {
//                                           context
//                                               .read<DashboardController>()
//                                               .showpurchaseupateDate(context);
//                                         }
//                                       : null,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             Screens.width(context) * 0.015),
//                                     width: Screens.width(context) * 0.4,
//                                     height: Screens.bodyheight(context) * 0.05,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.grey),
//                                         borderRadius: BorderRadius.circular(4)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: Screens.width(context) * 0.25,
//                                           // color: Colors.red,
//                                           child: Text(
//                                             context
//                                                 .watch<DashboardController>()
//                                                 .nextpurchasedate,
//                                             // context.read<DashboardController>().getnextFD,
//                                             style: theme.textTheme.bodyText2
//                                                 ?.copyWith(), //fontSize: 12
//                                           ),
//                                         ),
//                                         Container(
//                                           alignment: Alignment.centerRight,
//                                           width: Screens.width(context) * 0.10,
//                                           // color: Colors.red,
//                                           child: Icon(
//                                             Icons.calendar_month,
//                                             // size: Screens.,
//                                             color: theme.primaryColor,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Visibility(
//                         visible: context
//                                     .read<DashboardController>()
//                                     .getcaseStatusSelected ==
//                                 'Won'
//                             ? true
//                             : false,
//                         child: Column(
//                           children: [
//                             Container(
//                               width: Screens.width(context),
//                               padding:
//                                   EdgeInsets.only(top: 1, left: 10, right: 10),
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: DropdownButton(
//                                 hint: Text(
//                                   context
//                                       .read<DashboardController>()
//                                       .gethinttextforWonLead!,
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                       color: context
//                                               .read<DashboardController>()
//                                               .gethinttextforWonLead!
//                                               .contains(" *")
//                                           ? Colors.red
//                                           : Colors.black),
//                                 ),
//                                 value: context
//                                     .read<DashboardController>()
//                                     .valueChosedStatusWon,
//                                 //dropdownColor:Colors.green,
//                                 icon: Icon(Icons.arrow_drop_down),
//                                 iconSize: 30,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 16),
//                                 isExpanded: true,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     context
//                                         .read<DashboardController>()
//                                         .choosedStatusWon(val.toString());
//                                   });
//                                 },
//                                 items: context
//                                     .read<DashboardController>()
//                                     .leadStatusWon
//                                     .map((e) {
//                                   return DropdownMenuItem(
//                                       // ignore: unnecessary_brace_in_string_interps
//                                       value: "${e.code}",
//                                       child: Text(e.name.toString()));
//                                 }).toList(),
//                               ),
//                             ),
//                             SizedBox(
//                               height: Screens.bodyheight(context) * 0.01,
//                             ),
//                             TextFormField(
//                               controller: context
//                                   .watch<DashboardController>()
//                                   .mycontroller[0],
//                               decoration: InputDecoration(
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.grey[400]!),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.grey[400]!, width: 2.0),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   hintText: context
//                                       .read<DashboardController>()
//                                       .getorderBillRefer!,
//                                   hintStyle:
//                                       theme.textTheme.bodyText2?.copyWith(
//                                     color: context
//                                             .read<DashboardController>()
//                                             .getorderBillRefer!
//                                             .contains(" *")
//                                         ? Colors.red
//                                         : Colors.black,
//                                     // fontSize: 14
//                                   ),
//                                   // TextStyle(
//                                   //     color: context
//                                   //             .read<DashboardController>()
//                                   //             .getorderBillRefer!
//                                   //             .contains(" *")
//                                   //         ? Colors.red
//                                   //         : Colors.black),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       vertical: 10, horizontal: 10)),
//                             ),
//                             SizedBox(
//                               height: Screens.bodyheight(context) * 0.01,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                     child: Text(
//                                   context
//                                       .watch<DashboardController>()
//                                       .getorderBillDate!, // "Next Follow up",
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                     color: context
//                                             .watch<DashboardController>()
//                                             .getorderBillDate!
//                                             .contains(" *")
//                                         ? Colors.red
//                                         : Colors.grey,
//                                   ), // fontSize: 12
//                                 )),
//                                 InkWell(
//                                   onTap: context
//                                               .read<DashboardController>()
//                                               .getcaseStatusSelected ==
//                                           'Won'
//                                       ? () {
//                                           context
//                                               .read<DashboardController>()
//                                               .showFollowupWonDate(context);
//                                         }
//                                       : null,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             Screens.width(context) * 0.015),
//                                     width: Screens.width(context) * 0.5,
//                                     height: Screens.bodyheight(context) * 0.05,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.grey),
//                                         borderRadius: BorderRadius.circular(4)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: Screens.width(context) * 0.3,
//                                           // color: Colors.red,
//                                           child: Text(
//                                             context
//                                                 .watch<DashboardController>()
//                                                 .getnextWonFD,
//                                             // context.read<DashboardController>().getnextFD,
//                                             style: theme.textTheme.bodyText2
//                                                 ?.copyWith(), //fontSize: 12
//                                           ),
//                                         ),
//                                         Container(
//                                           alignment: Alignment.centerRight,
//                                           width: Screens.width(context) * 0.15,
//                                           // color: Colors.red,
//                                           child: Icon(
//                                             Icons.calendar_month,
//                                             // size: Screens.,
//                                             color: theme.primaryColor,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: Screens.bodyheight(context) * 0.01,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Visibility(
//                         visible: context
//                                     .read<DashboardController>()
//                                     .getcaseStatusSelected ==
//                                 'Lost'
//                             ? true
//                             : false,
//                         child: Column(
//                           children: [
//                             Container(
//                               width: Screens.width(context),
//                               padding:
//                                   EdgeInsets.only(top: 1, left: 10, right: 10),
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: DropdownButton(
//                                 hint: Text(
//                                   context
//                                       .read<DashboardController>()
//                                       .gethinttextforLostLead!,
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                       color: context
//                                               .read<DashboardController>()
//                                               .gethinttextforLostLead!
//                                               .contains(" *")
//                                           ? Colors.red
//                                           : Colors.black),
//                                 ),
//                                 value: context
//                                     .read<DashboardController>()
//                                     .valueChosedReason,
//                                 //dropdownColor:Colors.green,
//                                 icon: Icon(Icons.arrow_drop_down),
//                                 iconSize: 30,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 16),
//                                 isExpanded: true,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     context
//                                         .read<DashboardController>()
//                                         .choosedReason(val.toString());
//                                   });
//                                 },
//                                 items: context
//                                     .read<DashboardController>()
//                                     .leadStatusLost
//                                     .map((e) {
//                                   return DropdownMenuItem(
//                                       // ignore: unnecessary_brace_in_string_interps
//                                       value: "${e.code}",
//                                       child: Text(e.name.toString()));
//                                 }).toList(),
//                               ),
//                             ),
//                             SizedBox(
//                               height: Screens.bodyheight(context) * 0.01,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: Text(
//                           context
//                               .watch<DashboardController>()
//                               .getfeedbackLead!, // "Feedback",
//                           style: theme.textTheme.bodyText2?.copyWith(
//                             color: context
//                                     .watch<DashboardController>()
//                                     .getfeedbackLead!
//                                     .contains(" *")
//                                 ? Colors.red
//                                 : Colors.grey,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       TextFormField(
//                         controller: context
//                             .watch<DashboardController>()
//                             .mycontroller[1],
//                         decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey[400]!),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Colors.grey[400]!, width: 2.0),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       context
//                                   .read<DashboardController>()
//                                   .getcaseStatusSelected !=
//                               'Open'
//                           ? Container()
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                     child: Text(
//                                   context
//                                       .watch<DashboardController>()
//                                       .getnextFollowupDate!, // "Next Follow up",
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                     color: context
//                                             .watch<DashboardController>()
//                                             .getnextFollowupDate!
//                                             .contains(" *")
//                                         ? Colors.red
//                                         : Colors.grey,
//                                   ), // fontSize: 12
//                                 )),
//                                 InkWell(
//                                   onTap: context
//                                               .read<DashboardController>()
//                                               .getcaseStatusSelected ==
//                                           'Open'
//                                       ? () {
//                                           context
//                                               .read<DashboardController>()
//                                               .showFollowupDate(context);
//                                         }
//                                       : null,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             Screens.width(context) * 0.015),
//                                     width: Screens.width(context) * 0.5,
//                                     height: Screens.bodyheight(context) * 0.05,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.grey),
//                                         borderRadius: BorderRadius.circular(4)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: Screens.width(context) * 0.3,
//                                           // color: Colors.red,
//                                           child: Text(
//                                             context
//                                                 .watch<DashboardController>()
//                                                 .getnextFD,
//                                             // context.read<DashboardController>().getnextFD,
//                                             style: theme.textTheme.bodyText2
//                                                 ?.copyWith(), //fontSize: 12
//                                           ),
//                                         ),
//                                         Container(
//                                           alignment: Alignment.centerRight,
//                                           width: Screens.width(context) * 0.15,
//                                           // color: Colors.red,
//                                           child: Icon(
//                                             Icons.calendar_month,
//                                             // size: Screens.,
//                                             color: theme.primaryColor,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                       SizedBox(
//                         height: Screens.bodyheight(context) * 0.01,
//                       ),
//                       context
//                                   .read<DashboardController>()
//                                   .getcaseStatusSelected !=
//                               'Open'
//                           ? Container()
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                     child: Text(
//                                   context
//                                       .read<DashboardController>()
//                                       .nextVisitTime!, // "Next Follow up",
//                                   style: theme.textTheme.bodyText2?.copyWith(
//                                     color: context
//                                             .read<DashboardController>()
//                                             .nextVisitTime!
//                                             .contains(" *")
//                                         ? Colors.red
//                                         : Colors.grey,
//                                   ), // fontSize: 12
//                                 )),
//                                 InkWell(
//                                   onTap: context
//                                               .read<DashboardController>()
//                                               .getcaseStatusSelected ==
//                                           'Open'
//                                       ? () {
//                                           setState(() {
//                                             context
//                                                 .read<DashboardController>()
//                                                 .selectVisitTime(context);
//                                           });
//                                         }
//                                       : null,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             Screens.width(context) * 0.015),
//                                     width: Screens.width(context) * 0.5,
//                                     height: Screens.bodyheight(context) * 0.05,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.grey),
//                                         borderRadius: BorderRadius.circular(4)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: Screens.width(context) * 0.3,
//                                           // color: Colors.red,
//                                           child: Text(
//                                             context
//                                                 .watch<DashboardController>()
//                                                 .VisitTime,
//                                             //fUPCon.getnextFD,
//                                             style: theme.textTheme.bodyText2
//                                                 ?.copyWith(), //fontSize: 12
//                                           ),
//                                         ),
//                                         Container(
//                                           alignment: Alignment.centerRight,
//                                           width: Screens.width(context) * 0.15,
//                                           // color: Colors.red,
//                                           child: Icon(
//                                             Icons.timer,
//                                             // size: Screens.,
//                                             color: theme.primaryColor,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                       context
//                                   .read<DashboardController>()
//                                   .getcaseStatusSelected !=
//                               'Open'
//                           ? Container()
//                           : context.read<DashboardController>().iscorectime ==
//                                   false
//                               ? Container()
//                               : Container(
//                                   alignment: Alignment.centerRight,
//                                   child: Text(
//                                     "Schedule Time between 7AM to 10PM*",
//                                     style: theme.textTheme.bodyMedium!.copyWith(
//                                         color: Colors.red, fontSize: 13),
//                                   ),
//                                 )
//                     ],
//                   ),
//                 )),
//             SizedBox(
//               height: Screens.bodyheight(context) * 0.01,
//             ),
//             SizedBox(
//               width: Screens.width(context),
//               height: Screens.bodyheight(context) * 0.06,
//               child: ElevatedButton(
//                   onPressed: () {
//                     context.read<DashboardController>().clickLeadSaveBtn(
//                         docentry.toString(), docentry.toString(), '');
//                   },
//                   style: ElevatedButton.styleFrom(
//                     textStyle: TextStyle(
//                         // fontSize: 12,
//                         ),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(10),
//                       bottomRight: Radius.circular(10),
//                     )), //Radius.circular(6)
//                   ),
//                   child: Text("Save")),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   //phonecallApi

//   List<Widget> listContainersCustomerTag(
//     ThemeData theme,
//   ) {
//     return List.generate(
//       context.watch<DashboardController>().getleadphonedata.length,
//       (index) => InkWell(
//         onTap: () {
//           // context.read<LeadNewController>(). isSelectedenquirytype = context.read<LeadNewController>()
//           // .getenqReffList[index].Name.toString();
//           context.read<DashboardController>().selectFollowUp(
//               context
//                   .read<DashboardController>()
//                   .getleadphonedata[index]
//                   .name
//                   .toString(),
//               context
//                   .read<DashboardController>()
//                   .getleadphonedata[index]
//                   .code
//                   .toString());
//         },
//         child: Container(
//           width: Screens.width(context) * 0.4,
//           height: Screens.bodyheight(context) * 0.05,
//           //  padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color:
//                   context.watch<DashboardController>().isSelectedFollowUpcode ==
//                           context
//                               .read<DashboardController>()
//                               .getleadphonedata[index]
//                               .code
//                               .toString()
//                       ? theme.primaryColor //theme.primaryColor.withOpacity(0.5)
//                       : Colors.white,
//               border: Border.all(color: theme.primaryColor, width: 1),
//               borderRadius: BorderRadius.circular(4)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                   context
//                       .watch<DashboardController>()
//                       .getleadphonedata[index]
//                       .name
//                       .toString(),
//                   maxLines: 8,
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     fontSize: 13,
//                     color: context
//                                 .watch<DashboardController>()
//                                 .isSelectedFollowUpcode ==
//                             context
//                                 .read<DashboardController>()
//                                 .getleadphonedata[index]
//                                 .code
//                                 .toString()
//                         ? Colors.white //,Colors.white
//                         : theme.primaryColor,
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //openApi
//   List<Widget> listContainersOpenTag(
//     ThemeData theme,
//   ) {
//     return List.generate(
//       context.watch<DashboardController>().getleadopendata.length,
//       (index) => InkWell(
//         onTap: () {
//           // context.read<LeadNewController>(). isSelectedenquirytype = context.read<LeadNewController>()
//           // .getenqReffList[index].Name.toString();

//           context.read<DashboardController>().caseStatusSelectBtn(
//               context
//                   .read<DashboardController>()
//                   .getleadopendata[index]
//                   .name
//                   .toString(),
//               context
//                   .read<DashboardController>()
//                   .getleadopendata[index]
//                   .code
//                   .toString());
//           context.read<DashboardController>().validatebtnChanged();
//           // context.read<DashboardController>().selectFollowUp(context
//           //     .read<DashboardController>()
//           //     .getleadopendata[index]
//           //     .name
//           //     .toString(),context
//           //     .read<DashboardController>()
//           //     .getleadopendata[index]
//           //     .code
//           //     .toString());
//           // log(context.read<LeadNewController>().getisSelectedCsTag.toString());
//           // log(context
//           //     .read<LeadNewController>()
//           //     .getCusTagList[index]
//           //     .Name
//           //     .toString());
//         },
//         child: Container(
//           width: Screens.width(context) * 0.26,
//           height: Screens.bodyheight(context) * 0.06,
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color:
//                   context.watch<DashboardController>().getcaseStatusSelected ==
//                           context
//                               .read<DashboardController>()
//                               .getleadopendata[index]
//                               .name
//                               .toString()
//                       ? Color(0xffFCF752) //theme.primaryColor.withOpacity(0.5)
//                       : theme.primaryColor,
//               border: Border.all(
//                 color: theme.primaryColor,
//               ),
//               borderRadius: BorderRadius.circular(4)),
//           child: Text(
//               context
//                   .watch<DashboardController>()
//                   .getleadopendata[index]
//                   .name
//                   .toString(),
//               maxLines: 8,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 fontSize: 13,
//                 color: context
//                             .watch<DashboardController>()
//                             .getcaseStatusSelected ==
//                         context
//                             .read<DashboardController>()
//                             .getleadopendata[index]
//                             .name
//                             .toString()
//                     ? Colors.black //,Colors.white
//                     : Colors.white,
//               )),

//           // ElevatedButton(
//           //                       style: ElevatedButton.styleFrom(
//           //                         primary: context
//           //                                     .watch<DashboardController>()
//           //                                     .getcaseStatusSelected ==
//           //                                 'Open'
//           //                             ? Color(0xffFCF752)
//           //                             : theme.primaryColor,
//           //                         textStyle: TextStyle(
//           //                             color: context
//           //                                         .read<DashboardController>()
//           //                                         .getcaseStatusSelected ==
//           //                                     'Open'
//           //                                 ? Colors.black
//           //                                 : Colors.white),
//           //                         shape: RoundedRectangleBorder(
//           //                             borderRadius:
//           //                                 BorderRadius.all(Radius.circular(6))),
//           //                       ),
//           //                       onPressed: () {
//           //                         // setState(() {

//           //                         //   });
//           //                       },
//           //                       child: Text(
//           //                          context
//           //                 .read<DashboardController>()
//           //                 .getleadopendata[index]
//           //                 .name
//           //                 .toString(),
//           //                         style: TextStyle(
//           //                             color: context
//           //                                         .watch<DashboardController>()
//           //                                         .getcaseStatusSelected ==
//           //                                     'Open'
//           //                                 ? Colors.black
//           //                                 : Colors.white),
//           //                       )),
//         ),
//       ),
//     );
//   }
//   //forwar dialog

// //   Container forwardDialog(BuildContext context, ThemeData theme) {
// //     return Container(
// //       width: Screens.width(context),
// //       //  height: Screens.bodyheight(context)*0.5,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       padding: EdgeInsets.only(
// //         left: Screens.width(context) * 0.05,
// //         right: Screens.width(context) * 0.05,
// //         top: Screens.bodyheight(context) * 0.03,
// //         bottom: Screens.bodyheight(context) * 0.03,
// //       ),
// //       //  height: Screens.bodyheight(context) * 0.4,
// //       child: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             //  Expanded(
// //             //        child: ListView.builder(
// //             //          itemCount: 1,
// //             //          itemBuilder: (BuildContext context, int index) {
// //             //            return
// //             //             Wrap(
// //             //           spacing: 10.0, // gap between adjacent chips
// //             //           runSpacing: 10.0, // gap between lines
// //             //           children:
// //             //               listContainersProduct(theme,
// //             //                ));
// //             //          },
// //             //        ),
// //             //  ),
// //             Container(
// //               height: Screens.bodyheight(context) * 0.05,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[200],
// //                 borderRadius:
// //                     BorderRadius.circular(Screens.width(context) * 0.01),
// //                 // boxShadow: [
// //                 //   BoxShadow(
// //                 //     color: Colors.grey.withOpacity(0.7),
// //                 //     spreadRadius: 3,
// //                 //     blurRadius: 4,
// //                 //     offset: Offset(
// //                 //         0, 3), // changes position of shadow
// //                 //   ),
// //                 // ]
// //               ),
// //               child: TextField(
// //                 // controller:context.read<NewEnqController>().mycontroller[5] ,
// //                 onTap: () {
// //                   // Get.toNamed(ConstantRoutes.screenshot);
// //                 },
// //                 autocorrect: false,
// //                 onChanged: (v) {
// //                   context.read<DashboardController>().filterListAssignData(v);
// //                   context.read<DashboardController>().setForwardDataList();

// //                   // context.read<EnquiryUserContoller>().filterListAssignData(v);
// //                 },
// //                 decoration: InputDecoration(
// //                   filled: false,
// //                   hintText: 'Search',
// //                   enabledBorder: InputBorder.none,
// //                   focusedBorder: InputBorder.none,
// //                   suffixIcon: Icon(
// //                     Icons.search,
// //                     color: theme.primaryColor,
// //                   ),
// //                   contentPadding: const EdgeInsets.symmetric(
// //                     vertical: 12,
// //                     horizontal: 5,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               height: Screens.bodyheight(context) * 0.01,
// //             ),
// //             SizedBox(
// //               height: Screens.bodyheight(context) * 0.5,
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   children: [
// //                     Wrap(
// //                         spacing: 5.0, // gap between adjacent chips
// //                         runSpacing: 5.0, // gap between lines
// //                         children: listContainersProduct(
// //                           theme,
// //                         )),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               height: Screens.bodyheight(context) * 0.01,
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Container(
// //                     child: Text(
// //                   context
// //                       .watch<DashboardController>()
// //                       .getforwardNextFollowDate!, // "Next Follow up",
// //                   style: theme.textTheme.bodyText2?.copyWith(
// //                     color: context
// //                             .watch<DashboardController>()
// //                             .getforwardNextFollowDate!
// //                             .contains(" *")
// //                         ? Colors.red
// //                         : Colors.grey,
// //                   ), // fontSize: 12
// //                 )),
// //                 InkWell(
// //                   onTap: () {
// //                     context
// //                         .read<DashboardController>()
// //                         .showForwardNextDate(context);
// //                   },
// //                   child: Container(
// //                     padding: EdgeInsets.symmetric(
// //                         horizontal: Screens.width(context) * 0.015),
// //                     width: Screens.width(context) * 0.5,
// //                     height: Screens.bodyheight(context) * 0.05,
// //                     decoration: BoxDecoration(
// //                         border: Border.all(color: Colors.grey),
// //                         borderRadius: BorderRadius.circular(4)),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         SizedBox(
// //                           width: Screens.width(context) * 0.3,
// //                           // color: Colors.red,
// //                           child: Text(
// //                             context
// //                                 .watch<DashboardController>()
// //                                 .getforwardnextWonFD,
// //                             // context.read<DashboardController>().getnextFD,
// //                             style: theme.textTheme.bodyText2
// //                                 ?.copyWith(), //fontSize: 12
// //                           ),
// //                         ),
// //                         Container(
// //                           alignment: Alignment.centerRight,
// //                           width: Screens.width(context) * 0.15,
// //                           // color: Colors.red,
// //                           child: Icon(
// //                             Icons.calendar_month,
// //                             // size: Screens.,
// //                             color: theme.primaryColor,
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //             SizedBox(
// //               height: Screens.bodyheight(context) * 0.01,
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Container(
// //                     child: Text(
// //                   context
// //                       .read<DashboardController>()
// //                       .assignVisitTime!, // "Next Follow up",
// //                   style: theme.textTheme.bodyText2?.copyWith(
// //                     color: context
// //                             .read<DashboardController>()
// //                             .assignVisitTime!
// //                             .contains(" *")
// //                         ? Colors.red
// //                         : Colors.grey,
// //                   ), // fontSize: 12
// //                 )),
// //                 InkWell(
// //                   onTap: () {
// //                     setState(() {
// //                       context
// //                           .read<DashboardController>()
// //                           .forwardVisitTime(context);
// //                     });
// //                   },
// //                   child: Container(
// //                     padding: EdgeInsets.symmetric(
// //                         horizontal: Screens.width(context) * 0.015),
// //                     width: Screens.width(context) * 0.5,
// //                     height: Screens.bodyheight(context) * 0.05,
// //                     decoration: BoxDecoration(
// //                         border: Border.all(color: Colors.grey),
// //                         borderRadius: BorderRadius.circular(4)),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         SizedBox(
// //                           width: Screens.width(context) * 0.3,
// //                           // color: Colors.red,
// //                           child: Text(
// //                             context.watch<DashboardController>().forwaVisitTime,
// //                             //fUPCon.getnextFD,
// //                             style: theme.textTheme.bodyText2
// //                                 ?.copyWith(), //fontSize: 12
// //                           ),
// //                         ),
// //                         Container(
// //                           alignment: Alignment.centerRight,
// //                           width: Screens.width(context) * 0.15,
// //                           // color: Colors.red,
// //                           child: Icon(
// //                             Icons.timer,
// //                             // size: Screens.,
// //                             color: theme.primaryColor,
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //              context
// //                                                 .read<DashboardController>()
// //                                                 .   iscorectime2==false?Container(): Container(
// //                               alignment: Alignment.centerRight,
// //                               child: Text("Schedule Time between 7AM to 10PM*",style: theme.textTheme.bodyMedium!.copyWith(
// //                                 color: Colors.red,
// //                                 fontSize: 13
// //                               ),),
// //                             ),
// //             SizedBox(
// //               height: Screens.bodyheight(context) * 0.01,
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 SizedBox(
// //                   width: Screens.width(context) * 0.26,
// //                   height: Screens.bodyheight(context) * 0.06,
// //                   child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.all(Radius.circular(6))),
// //                       ),
// //                       onPressed: () {
// //                         setState(() {
// //                           context.read<DashboardController>().forwardClicked();
// //                         });
// //                       },
// //                       child: Text("Back")),
// //                 ),
// //                 SizedBox(
// //                   width: Screens.width(context) * 0.26,
// //                   height: Screens.bodyheight(context) * 0.06,
// //                   child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.all(Radius.circular(6))),
// //                       ),
// //                       onPressed: () {
// //                         if (context
// //                                 .read<DashboardController>()
// //                                 .selectedUserList
// //                                 .isNotEmpty &&
// //                             context
// //                                 .read<DashboardController>()
// //                                 .forwaVisitTime
// //                                 .isNotEmpty &&
// //                             context
// //                                 .read<DashboardController>()
// //                                 .forwardNextFollowDate!
// //                                 .isNotEmpty) {
// //                           context.read<DashboardController>().Allfollowupupdate(
// //                               "",
// //                               widget.leadopenalldata
// //                                   .LeadDocEntry
// //                                   .toString(),
// //                               "",
// //                               "",
// //                               "",
// //                               "",
// //                               context
// //                                   .read<DashboardController>()
// //                                   .selectedUserList,
// //                             widget.  leadopenalldata
// //                                   .LastUpdateMessage
// //                                   .toString(),'');
// //                         } else {
// //                           setState(() {
// //                             if( context
// //                                 .read<DashboardController>()
// //                                 .forwaVisitTime
// //                                 .isEmpty
// //                            ){
// // context.read<DashboardController>().assignVisitTime =
// //                                 "Followup Time:*";

// //                                 }if( context
// //                                 .read<DashboardController>()
// //                                 .forwardNextFollowDate!
// //                                 .isEmpty){
// // context
// //                                 .read<DashboardController>()
// //                                 .forwardNextFollowDate = "Next Follow Up:*";
// //                                 }

// //                           });
// //                         }
// //                       },
// //                       child: Text("Forward")),
// //                 ),
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }

//   // List<Widget> listContainersProduct(ThemeData theme) {
//   //   return List.generate(
//   //     context.watch<DashboardController>().filteruserLtData.length,
//   //     (ind) => GestureDetector(
//   //       onTap: () {
//   //         context.read<DashboardController>().getSelectedUserSalesEmpId(ind);
//   //       },
//   //       child: Container(
//   //         width: Screens.width(context) * 0.4,
//   //         padding: EdgeInsets.all(5),
//   //         decoration: BoxDecoration(
//   //             color: context
//   //                         .watch<DashboardController>()
//   //                         .filteruserLtData[ind]
//   //                         .color ==
//   //                     1
//   //                 ? theme.primaryColor
//   //                 : Colors.white,
//   //             border: Border.all(color: theme.primaryColor, width: 1),
//   //             borderRadius: BorderRadius.circular(5)),
//   //         child: Text(
//   //             context
//   //                 .watch<DashboardController>()
//   //                 .filteruserLtData[ind]
//   //                 .UserName!,
//   //             textAlign: TextAlign.center,
//   //             style: theme.textTheme.bodyMedium?.copyWith(
//   //               fontWeight: FontWeight.normal,
//   //               fontSize: 12,
//   //               color: context
//   //                           .watch<DashboardController>()
//   //                           .filteruserLtData[ind]
//   //                           .color ==
//   //                       1
//   //                   ? Colors.white
//   //                   : theme.primaryColor,
//   //             )),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
