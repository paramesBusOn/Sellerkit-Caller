import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/main.dart';
import 'package:sellerkitcalllog/src/controller/callLogController/callLogController.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class CallLogPage extends StatefulWidget {
  const CallLogPage({super.key});

  @override
  State<CallLogPage> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config config = Config();
    return ChangeNotifierProvider<CallLogController>(
        create: (context) => CallLogController(),
        builder: (context, child) {
          return Consumer<CallLogController>(
              builder: (BuildContext context, callLogCnt, Widget? child) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: theme.primaryColor,
                title: GestureDetector(
                  onTap: () {
                 
                  },
                  child: Text(
                    'Call Log',
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Utils.network == 'none'
                    ? NoInternet(network: Utils.network)
                    : (callLogCnt.callsInfo.isEmpty &&
                            callLogCnt.apiloading == true)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: callLogCnt.callsInfo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title:
                                    Text("${callLogCnt.callsInfo[index].name}",style: theme.textTheme.bodyMedium,),
                                subtitle: Text(
                                    "${callLogCnt.callsInfo[index].number}"),
                                trailing: Text(config.alignDate3(
                                    callLogCnt.callsInfo[index].time!)),
                              );
                            },
                          ),
              ),
            );
          });
        });
  }
}
