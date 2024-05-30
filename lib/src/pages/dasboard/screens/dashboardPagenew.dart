// import 'dart:async';

// import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:sellerkitcalllog/helpers/screen.dart';
// import 'package:sellerkitcalllog/src/controller/DashboardController/DashboardController.dart';
// // import 'package:sellerkitcalllog/src/pages/dasboard/widgets/customerDetailsDialog.dart';
// import 'package:sellerkitcalllog/testoverlay.dart';
// import 'package:sellerkitcalllog/helpers/Utils.dart';

// import '../../../../main.dart';

// class DashboardPageNew extends StatefulWidget {
//   const DashboardPageNew({super.key, required this.title});

//   final String title;

//   @override
//   State<DashboardPageNew> createState() => DashboardPageNewState();
// }

// class DashboardPageNewState extends State<DashboardPageNew> {
//   static String mobileno = '';
//   Timer? timer;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   // Paddings paddings = Paddings();
//   var tabIndex = 0;
//   static const List<Tab> myTabs = <Tab>[
//     Tab(text: 'Feeds'),
//     Tab(text: 'KPI'),
//     Tab(text: 'Analytics'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return ChangeNotifierProvider<DashboardController>(
//         create: (context) => DashboardController(context),
//         builder: (context, child) {
//           return Consumer<DashboardController>(
//               builder: (BuildContext context, loginCnt, Widget? child) {
//             if (mobileno.isNotEmpty) {
//               loginCnt.setArgument(context, loginCnt, mobileno);
//             }

//             return Scaffold(
//               drawerEnableOpenDragGesture: false,
//               key: scaffoldKey,
//               backgroundColor: Colors.grey[200],
//               appBar: AppBar(
//                 backgroundColor: theme.primaryColor,
//                 actions: [
//                   IconButton(
//                       onPressed: () {
//                         setState(() {
//                           // dasboardCnt.popupmenu(context);
//                         });
//                       },
//                       icon: const Icon(Icons.list))
//                 ],
//                 bottom: PreferredSize(
//                   preferredSize: const Size.fromHeight(60),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Screens.bodyheight(context) * 0.02,
//                         horizontal: Screens.bodyheight(context) * 0.02),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: Screens.bodyheight(context) * 0.06,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(
//                                   Screens.width(context) * 0.01),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 2,
//                                   blurRadius: 2,
//                                   offset: const Offset(
//                                       0, 3), // changes position of shadow
//                                 ),
//                               ]),
//                           child: TextField(
//                             // controller: dasboardCnt.mycontroller[0],
//                             onTap: () {
//                               // Get.toNamed(ConstantRoutes.screenshot);
//                             },
//                             autocorrect: false,
//                             onChanged: (v) {
//                               // dasboardCnt.SearchFilter(v);
//                             },
//                             decoration: InputDecoration(
//                               filled: false,
//                               hintText: 'Search',
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               suffixIcon: Icon(
//                                 Icons.search,
//                                 color: theme.primaryColor,
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 15,
//                                 horizontal: 10,
//                               ),
//                             ),
//                           ),
//                         )
//                         // TabBar(
//                         //   controller: controller,
//                         //   tabs: myTabs,
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 title: Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         // color: Colors.amber,
//                         width: Screens.width(context) * 0.5,
//                         // height: Screens.bodyheight(context) * 0.1,
//                         child: Text(
//                           'Hi, test',
//                           textAlign: TextAlign.center,
//                           maxLines: 10,
//                           style: theme.textTheme.titleMedium
//                               ?.copyWith(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               body: SizedBox(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: Center(
//                     child: Utils.network == 'none'
//                         ? NoInternet(network: Utils.network)
//                         : Column(
//                             children: [
//                               Text(
//                                 '${Utils.token}',
//                                 style: const TextStyle(color: Colors.black),
//                               ),
//                               ElevatedButton(
//                                   onPressed: () {}, child: Text("Test"))
//                             ],
//                           )),
//                 //  ListView.builder(
//                 //     itemCount: dasboardCnt.callsInfo.length,
//                 //     itemBuilder: (context, index) {
//                 //       final calllog=dasboardCnt.callsInfo[index];
//                 //       return ListTile(
//                 //         leading: const Icon(Icons.call),
//                 //         title: Text('${calllog.name}'),
//                 //         subtitle: Text('${calllog.number}'),
//                 //         trailing:
//                 //             Text("${calllog.duration}"),
//                 //       );
//                 //     })
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () async {
//                   await Future.delayed(const Duration(seconds: 2));
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => testpage()),
//                   );
//                 },
//               ),
//             );
//           });
//         });
//   }
// }
