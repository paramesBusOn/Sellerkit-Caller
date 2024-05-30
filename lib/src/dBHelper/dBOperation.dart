import 'dart:developer';

import 'package:sellerkitcalllog/src/Models/postQueryModel/EnquiriesModel/EnquiriesModel.dart';
import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
import 'package:sellerkitcalllog/src/api/enqTypeApi/enqTypeApi.dart';
import 'package:sellerkitcalllog/src/api/getRefferalApi/getRefferalApi.dart';
import 'package:sellerkitcalllog/src/api/getUserListApi/getUserListApi.dart';
import 'package:sellerkitcalllog/src/api/leadUpdateFollowiupApi/getLeadStatusApi.dart';
import 'package:sellerkitcalllog/src/api/levelOfApi/levelOfApi.dart';
import 'package:sellerkitcalllog/src/api/stateApi/stateApi.dart';
import 'package:sellerkitcalllog/src/dBModel/AuthorizationDB.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/dBModel/ScreenShotModel.dart';
import 'package:sellerkitcalllog/src/dBModel/enquiry_filterdbmodel.dart';
import 'package:sellerkitcalllog/src/dBModel/stateDBModel.dart';
import 'package:sqflite/sqflite.dart';
import '../api/getAllCustomerApi/getAllCustomerApi.dart';
import '../api/ordertypeApi/ordertypeApi.dart';
import '../api/outStandingApi/getOutStandingApi.dart';
import '../controller/dashboardController/dashboardController.dart';
import '../dBModel/NotificationModel.dart';
import '../Models/postQueryModel/OrdersCheckListModel/GetOrderStatuModel.dart';
import '../dBModel/getAllCustomerDbModel.dart';
import '../dBModel/outstandingDBmodel.dart';
import '../dBModel/outstandinglinechild.dart';
import 'dart:core';

class DBOperation {
  static Future insertEnqdata(List<EnquiriesData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("start DBBBB");
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();

    data.forEach((es) async {
      batch.insert(tableEnquiryfilter, es);
    });

    await batch.commit();
    stopwatch.stop();
    log('API DB ${stopwatch.elapsedMilliseconds} milliseconds');
  }

  static Future insertEnqType(List<EnquiryTypeData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertEnqType ");
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableEnqType, es);
      log("Enq Batchhhh Item...");
    });
    stopwatch.stop();
    log('API insertEnqType ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  static Future insertCusTagType(
      List<CustomerTagTypeData2> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertCusTagType ");

    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableCusTagType, es);
    });
    stopwatch.stop();
    log('API insertCusTagType ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  static Future insertlevelofType(List<LevelofData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertlevelofType ");

    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableLevelof, es);
    });
    stopwatch.stop();
    log('API insertlevelofType ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  static Future insertOrderTypeta(
      List<OrderTypeData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertOrderTypeta ");
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableOrderType, es);
    });
    stopwatch.stop();
    log('API insertOrderTypeta ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  insertIsoEnqtpe(List<dynamic> value) async {
    List<EnquiryTypeData> valu = value[1];
    var data = valu.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableEnqType, es);
    });
    await batch.commit();
  }

  insertIsoCusTagtpe(List<dynamic> value) async {
    List<EnquiryTypeData> valu = value[1];
    var data = valu.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableCusTagType, es);
    });
    await batch.commit();
  }

  static Future<List<EnquiryTypeData>> getEnqData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM EnqType;
''');

    return List.generate(result.length, (i) {
      return EnquiryTypeData(
        Code: result[i]['Code'].toString(),
        Name: result[i]['Name'].toString(),
      );
    });
  }

  static Future<List<LevelofData>> getlevelofData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM Levelof;
''');

    return List.generate(result.length, (i) {
      return LevelofData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
      );
    });
  }

  static Future<List<OrderTypeData>> getordertypeData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM OrderType;
''');

    return List.generate(result.length, (i) {
      return OrderTypeData(
        Code: result[i]['Code'].toString(),
        Name: result[i]['Name'].toString(),
      );
    });
  }

  static Future<List<CustomerTagTypeData2>> getCusTagData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM CusTagType;
''');

    return List.generate(result.length, (i) {
      return CustomerTagTypeData2(
        Code: result[i]['Code'].toString(),
        Name: result[i]['Name'].toString(),
      );
    });
  }

  static Future<List<Map<String, Object?>>> getLoginVerifiDBData(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $loginverificationDB
''');

    log("restriction::$result");

    return result;
  }

  static Future<void> truncareEnqfilter(Database db) async {
    await db.rawQuery('delete from $tableEnquiryfilter');
  }

  static Future<void> truncateLoginVerficationDB(Database db) async {
    await db.rawQuery('delete from $loginverificationDB');
  }

  static Future insertLoginVerifiDetails(
      List<VerificationData> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    log("tableopenlead len: ${values.length}");
    log("tableopenlead len: ${data.length}");

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(loginverificationDB, es);
      log("loginverificationDB Batchhhh Item...");
    });
    await batch.commit();
  }

  static Future<void> truncareEnqType(Database db) async {
    await db.rawQuery('delete from $tableEnqType');
  }

  static Future<void> truncarelevelofType(Database db) async {
    await db.rawQuery('delete from $tableLevelof');
  }

  static Future<void> truncareorderType(Database db) async {
    await db.rawQuery('delete from $tableOrderType');
  }

  static Future<void> truncareCusTagType(Database db) async {
    await db.rawQuery('delete from $tableCusTagType');
  }

  static Future<void> truncareEnqReffers(Database db) async {
    await db.rawQuery('delete from $tableEnqReffers');
  }

  static Future insertEnqReffers(
      List<EnqRefferesData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertEnqReffers ");
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableEnqReffers, es);
      log("Enq Batchhhh Item...");
    });
    stopwatch.stop();
    log('API insertEnqReffers ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  static indertIsoReferral(List<dynamic> value) async {
    List<EnqRefferesData> values = value[1];
    var data = values.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableEnqReffers, es);
    });
    await batch.commit();
  }

  static Future<List<EnqRefferesData>> getEnqRefferes(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT * FROM $tableEnqReffers;
    ''');

    return List.generate(result.length, (i) {
      return EnqRefferesData(
        Code: result[i]['Code'].toString(),
        Name: result[i]['Name'].toString(),
      );
    });
  }

  static Future insertUserList(List<UserListData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertUserList ");
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableUserList, es);
      print("Data...");
    });
    stopwatch.stop();
    log('API insertUserList ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  static indertIsoUserList(List<dynamic> value) async {
    List<UserListData> values = value[1];
    var data = values.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableUserList, es);
    });
    await batch.commit();
  }

  static Future<List<UserListData>> getUserList(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM $tableUserList;
''');
    log("result$result");
    return List.generate(result.length, (i) {
      return UserListData(
        userCode: result[i]['UserCode'].toString(),
        storeid: int.parse(result[i]['StoreID'].toString()),
        mngSlpcode: result[i]['managerSlp'].toString(),
        slpcode: result[i]['slpCode'].toString(),
        UserName: result[i]['UserName'].toString(),
        color: int.parse(result[i]['Color'].toString()),
        SalesEmpID: int.parse(result[i]['SalesEmpID'].toString()),
      );
    });
  }

  static Future insertLeadStatusList(
      List<GetLeadStatusData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:insertLeadStatusList ");
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableLeadStatusReason, es);
      print("LeadStatusList...");
    });
    stopwatch.stop();
    log('API insertLeadStatusList ${stopwatch.elapsedMilliseconds} milliseconds');

    await batch.commit();
  }

  static indertIsoLeadStatusList(List<dynamic> value) async {
    List<GetLeadStatusData> values = value[1];
    var data = values.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableLeadStatusReason, es);
    });
    await batch.commit();
  }

  static Future<List<GetLeadStatusData>> getLeadStatusOpen(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $tableLeadStatusReason where StatusType = '1';
      ''');

    return List.generate(result.length, (i) {
      return GetLeadStatusData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
        statusType: int.parse(result[i]['StatusType'].toString()),
      );
    });
  }

  static Future<List<GetLeadStatusData>> getLeadStatusWon(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $tableLeadStatusReason where StatusType = '2';
      ''');

    return List.generate(result.length, (i) {
      return GetLeadStatusData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
        statusType: int.parse(result[i]['StatusType'].toString()),
      );
    });
  }

  static Future<List<GetLeadStatusData>> getLeadStatusLost(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $tableLeadStatusReason where StatusType = '3';
      ''');

    return List.generate(result.length, (i) {
      return GetLeadStatusData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
        statusType: int.parse(result[i]['StatusType'].toString()),
      );
    });
  }

  static Future<List<Map<String, Object?>>> getofferDataproduct(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $tableOfferZonechild1

''');

    return result;
  }

  static Future<List<Map<String, Object?>>> getofferDatastore(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $tableOfferZonechild2
''');

    return result;
  }

  static Future<List<Map<String, Object?>>> getofferFavData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $tableOfferZone

''');

    return result;
  }

  static Future insertNotification(
      List<NotificationModel> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableNotification, es);
    });
    await batch.commit();
  }

  static Future<List<NotificationModel>> getNotification(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM $tableNotification;
''');
    log(result.toList().toString());
    return List.generate(result.length, (i) {
      return NotificationModel(
        jobid: int.parse(result[i]['Jobid'].toString()),
        id: int.parse(result[i]['NId'].toString()),
        docEntry: int.parse(result[i]['DocEntry'].toString()),
        titile: result[i]['Title'].toString(),
        description: result[i]['Description'].toString(),
        receiveTime: result[i]['ReceiveTime'].toString(),
        seenTime: result[i]['SeenTime'].toString(),
        imgUrl: result[i]['ImgUrl'].toString(),
        naviScn: result[i]['NavigateScreen'].toString(),
      );
    });
  }

  static Future<int?> getUnSeenNotificationCount(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT count(NId) from $tableNotification where SeenTime = '0';
    ''');

    int? count = Sqflite.firstIntValue(result);

    return count;
  }

  // static updateNotify(int id, String time, Database db) async {
  //   final List<Map<String, Object?>> result = await db.rawQuery('''
  //     UPDATE $tableNotification
  //   SET SeenTime = "$time" WHERE NId = $id;
  //   ''');
  // }

  // static deleteNotify(int id, Database db) async {
  //   final List<Map<String, Object?>> result = await db.rawQuery('''
  //     delete from $tableNotification WHERE DocEntry = $id;
  //   ''');
  // }

  // static deleteNotifyAll(Database db) async {
  //   final List<Map<String, Object?>> result = await db.rawQuery('''
  //     delete from $tableNotification;
  //   ''');
  // }

  static Future<void> truncateOfferZone(Database db) async {
    await db.rawQuery('delete from $tableOfferZone');
  }

  static Future<void> truncateOfferZonechild1(Database db) async {
    await db.rawQuery('delete from $tableOfferZonechild1');
  }

  static Future<void> truncateOfferZonechild2(Database db) async {
    await db.rawQuery('delete from $tableOfferZonechild2');
  }

  static Future<void> truncateUserList(Database db) async {
    await db.rawQuery('delete from $tableUserList');
  }

  static Future<void> truncateLeadstatus(Database db) async {
    await db.rawQuery('delete from $tableLeadStatusReason');
  }

  static Future<void> truncateCustomerList(Database db) async {
    await db.rawQuery('delete from $tableCustomerMaster');
  }

  Future<void> truncateNotification(Database db) async {
    await db.rawQuery('delete from $tableNotification');
  }

  Future<List<Map<String, Object?>>> runQuery(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT * from OpenLeadT;
    ''');
    log(result.toList().toString());
    int? count = Sqflite.firstIntValue(result);

    return result;
  }

  static Future<List<StateHeaderData>> getstateData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT * FROM $tableStateMaster;
    ''');

    return List.generate(result.length, (i) {
      // log("Saved AllocATE length: ${result[i]['gst']}");

      return StateHeaderData(
        statecode: result[i]['statecode'].toString(),
        stateName: result[i]['statename'] == null
            ? ""
            : result[i]['statename'].toString(),
        countrycode: result[i]['cuntrycode'] == null
            ? ""
            : result[i]['cuntrycode'].toString(),
        countryname: result[i]['countryname'] == null
            ? ""
            : result[i]['countryname'].toString(),
      );
    });
  }

  static Future<List<CustomerTagTypeData2>> getCusTagDataDetails(
      Database db, String custagName) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM CusTagType where Name='$custagName' ;
''');

    log("Selected custag: ${result.toList()}");

    return List.generate(result.length, (i) {
      return CustomerTagTypeData2(
        Code: result[i]['Code'].toString(),
        Name: result[i]['Name'].toString(),
      );
    });
  }

  static Future<List<GetOrderStatusData>> getOrderStatusOpen(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $tableOrderStatusReason where StatusType = 'Open';
      ''');

    return List.generate(result.length, (i) {
      return GetOrderStatusData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
        statusType: result[i]['StatusType'].toString(),
      );
    });
  }

  static Future<List<GetOrderStatusData>> getOrderStatusLost(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $tableOrderStatusReason where StatusType = 'Lost';
      ''');

    return List.generate(result.length, (i) {
      return GetOrderStatusData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
        statusType: result[i]['StatusType'].toString(),
      );
    });
  }

  static Future<List<GetOrderStatusData>> getOrderStatusWon(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $tableOrderStatusReason where StatusType = 'Won';
      ''');

    return List.generate(result.length, (i) {
      return GetOrderStatusData(
        code: result[i]['Code'].toString(),
        name: result[i]['Name'].toString(),
        statusType: result[i]['StatusType'].toString(),
      );
    });
  }

  static Future inserstateMaster(
      List<StateHeaderData> values, Database db) async {
    final stopwatch = Stopwatch()..start();
    log("Start:inserstateMaster ");
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableStateMaster, es);
      print("LeadStatusList...");
    });
    stopwatch.stop();
    log('API inserstateMaster ${stopwatch.elapsedMilliseconds} milliseconds');
    await batch.commit();
  }

  static Future<void> trunstateMaster(Database db) async {
    await db.rawQuery('delete from $tableStateMaster');
  }

  static Future<List<Map<String, Object?>>> getValidateCheckIn(
    Database db,
  ) async {
    final List<Map<String, Object?>> result = await db.rawQuery(
        ''' SELECT * FROM  SiteCheckIn where substr(DateTime,1,10) = DATE("now") and SiteType = "CheckIn" ''');

    return result;
  }

  static Future changeCheckIntoCheckOut(Database db, int checkId) async {
    List<Map<String, Object?>> result = await db.rawQuery(
        ''' UPDATE SiteCheckIn  SET SiteType = "CheckOut" Where CheckInId= $checkId ''');

    return result;
  }

  static Future insertScreenShot(
      List<ScreenShotModel> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    log("insertScreenShot len: ${data.length}");
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableScreenShot, es);
      log("insertScreenShot Batchhhh Item...");
    });
    await batch.commit();
  }

  // outstanding

  static Future<List<outstandingDBModel>> getoutstandingMaster(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery("""
 SELECT * From $tableoutstanding 
""");
    log("result::::${result.length}");
    return List.generate(result.length, (i) {
      return outstandingDBModel(
        alternateMobileNo: result[i]['AlternateMobileNo'].toString(),
        amountPaid: double.parse(result[i]['AmountPaid'].toString()),
        assignedTo: result[i]['AssignedTo'].toString(),
        balanceToPay: double.parse(result[i]['BalanceToPay'].toString()),
        collectionInc: double.parse(result[i]['CollectionInc'].toString()),
        companyName: result[i]['CompanyName'].toString(),
        contactName: result[i]['ContactName'].toString(),
        customerCode: result[i]['CustomerCode'].toString(),
        customerEmail: result[i]['CustomerEmail'].toString(),
        customerGroup: result[i]['CustomerGroup'].toString(),
        customerMobile: result[i]['CustomerMobile'].toString(),
        customerName: result[i]['CustomerName'].toString(),
        gstNo: result[i]['GstNo'].toString(),
        penaltyAfterDue: double.parse(result[i]['PenaltyAfterDue'].toString()),
        storeCode: result[i]['StoreCode'].toString(),
        transAmount: double.parse(result[i]['TransAmount'].toString()),
      );
    });
  }

  static Future<List<Map<String, Object?>>> getmapvaluestocollection(
      Database db, String cuscode) async {
    List<Map<String, Object?>> result2 = await db.rawQuery("""
 select CustomerCode,CustomerName,AlternateMobileNo,ContactName,CustomerEmail,GstNo,
Bil_Address1,Bil_Address2,Bil_Area,Bil_City,Bil_Country,Bil_Pincode,Bil_State,StoreCode,AssignedTo


 from Outstandingline where CustomerCode='$cuscode'
""");
    log("resuklutt::$result2");
    return result2;
    // if(result2.isNotEmpty){
    //   return outstandKPI(
    //     totaloutstanding:double.parse(result2[0]['totaloutstanding'].toString()) ,
    //     overdue: double.parse(result2[0]['overdue'].toString()) ,
    //     upcoming: double.parse(result2[0]['upcoming'].toString())
    //     );
    // }else{
    //   return outstandKPI(
    //     totaloutstanding: 0,
    //     overdue: 0,
    //     upcoming: 0
    //     );
    // }
  }

  static Future<List<Map<String, Object?>>> getoutstandingKPI(
      Database db) async {
    List<Map<String, Object?>> result2 = await db.rawQuery("""
 SELECT sum (BalanceToPay) totaloutstanding,
case when DATE('now')>TransDueDate then sum(BalanceToPay) else 0 END overdue ,
case when DATE('now')<=TransDueDate then sum(BalanceToPay) else 0 END upcoming 
from Outstandingline
""");
    log("resuklutt::$result2");
    return result2;
    // if(result2.isNotEmpty){
    //   return outstandKPI(
    //     totaloutstanding:double.parse(result2[0]['totaloutstanding'].toString()) ,
    //     overdue: double.parse(result2[0]['overdue'].toString()) ,
    //     upcoming: double.parse(result2[0]['upcoming'].toString())
    //     );
    // }else{
    //   return outstandKPI(
    //     totaloutstanding: 0,
    //     overdue: 0,
    //     upcoming: 0
    //     );
    // }
  }

  static Future<List<Map<String, Object?>>> getOutLFtr(
      String column, Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT DISTINCT $column
 FROM $tableoutstanding
WHERE $column IS NOT '';
''');

    //  log("Saved AllocATE: " + result.toList().toString());
    // log("Saved AllocATE length: " + result.length.toString());
    return result;
  }

  static Future<List<outstandinglineDBModel>> getoutstandingchild(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery("""
 SELECT * From $tableoutstandingline 
""");
    log("result::::${result.length}");
    return List.generate(result.length, (i) {
      return outstandinglineDBModel(
          bil_Address1: result[i]['Bil_Address1'].toString(),
          bil_Address2: result[i]['Bil_Address2'].toString(),
          bil_Address3: result[i]['Bil_Address3'].toString(),
          bil_Area: result[i]['Bil_Area'].toString(),
          bil_City: result[i]['Bil_City'].toString(),
          bil_Country: result[i]['Bil_Country'].toString(),
          bil_District: result[i]['Bil_District'].toString(),
          bil_Pincode: result[i]['Bil_Pincode'].toString(),
          bil_State: result[i]['Bil_State'].toString(),
          collectionType: result[i]['CollectionType'].toString(),
          createdBy: result[i]['CreatedBy'] == null
              ? 0
              : int.parse(result[i]['CreatedBy'].toString()),
          createdOn: result[i]['CreatedOn'].toString(),
          customerPORef: result[i]['CustomerPORef'].toString(),
          docentry: result[i]['Docentry'] == null
              ? 0
              : int.parse(result[i]['Docentry'].toString()),
          transDate: result[i]['TransDate'].toString(),
          transDueDate: result[i]['TransDueDate'].toString(),
          transNum: result[i]['TransNum'].toString(),
          transRef1: result[i]['TransRef1'].toString(),
          transType: result[i]['TransType'].toString(),
          updatedBy: result[i]['UpdatedBy'] == null
              ? 0
              : int.parse(result[i]['UpdatedBy'].toString()),
          updatedOn: result[i]['UpdatedOn'].toString(),
          loanRef: result[i]['LoanRef'].toString(),
          status: result[i]['Status'].toString(),
          traceid: result[i]['Traceid'].toString(),
          alternateMobileNo: result[i]['AlternateMobileNo'].toString(),
          amountPaid: double.parse(result[i]['AmountPaid'].toString()),
          assignedTo: result[i]['AssignedTo'].toString(),
          balanceToPay: double.parse(result[i]['BalanceToPay'].toString()),
          collectionInc: double.parse(result[i]['CollectionInc'].toString()),
          companyName: result[i]['CompanyName'].toString(),
          contactName: result[i]['ContactName'].toString(),
          customerCode: result[i]['StoreCode'].toString(),
          customerEmail: result[i]['CustomerEmail'].toString(),
          customerGroup: result[i]['CustomerCode'].toString(),
          customerMobile: result[i]['CustomerMobile'].toString(),
          customerName: result[i]['CustomerName'].toString(),
          gstNo: result[i]['GstNo'].toString(),
          penaltyAfterDue:
              double.parse(result[i]['PenaltyAfterDue'].toString()),
          storeCode: result[i]['StoreCode'].toString(),
          transAmount: double.parse(result[i]['TransAmount'].toString()));
    });
  }

  static Future<List<outstandKPI>> getoutstandingchildInvoice(
      Database db, String? cusCode) async {
    final List<Map<String, Object?>> result = await db.rawQuery(
        """SELECT TransNum,Docentry,TransDate,TransRef1,julianday('now') - julianday(TransDueDate) age,BalanceToPay,TransAmount from Outstandingline where CustomerCode='$cusCode'
 
""");

//Docentry
// SELECT * From $tableoutstandingline where CustomerCode=$cusCode
    log("result::::$cusCode::${result.length}");
    return List.generate(result.length, (i) {
      return outstandKPI(
          TransNum: result[i]['TransNum'] == null
              ? ''
              : result[i]['TransNum'].toString(),
          TransDate: result[i]['TransDate'] == null
              ? ''
              : result[i]['TransDate'].toString(),
          TransRef1: result[i]['TransRef1'] == null
              ? ''
              : result[i]['TransRef1'].toString(),
          age: result[i]['age'] == null
              ? 0.0
              : double.parse(result[i]['age'].toString()),
          BalanceToPay: result[i]['BalanceToPay'] == null
              ? 0.0
              : double.parse(result[i]['BalanceToPay'].toString()),
          TransAmount: result[i]['TransAmount'] == null
              ? 0.0
              : double.parse(result[i]['TransAmount'].toString()),
          docentry: result[i]['Docentry'] == null
              ? 0
              : int.parse(result[i]['Docentry'].toString()));
    });
  }

  static Future<List<Map<String, Object?>>> getoutontapKPI(
      Database db, String? cusCode) async {
    List<Map<String, Object?>> result = await db.rawQuery("""
SELECT sum (BalanceToPay) totaloutstanding,case when DATE('now')>TransDueDate then sum(BalanceToPay) else 0 END overdue ,
case when DATE('now')<=TransDueDate then sum(BalanceToPay) else 0 END upcoming ,Bil_City,Bil_State,CustomerName,CustomerCode from Outstandingline WHERE CustomerCode="$cusCode"
 
""");

//Docentry
// SELECT * From $tableoutstandingline where CustomerCode=$cusCode
    log("result::::$cusCode::${result.length}");
    return result;
    // List.generate(result.length, (i) {
    //   return ontapKpi(
    //     totaloutstanding: result[i]['totaloutstanding'].toString(),
    //     overdue: result[i]['overdue'].toString(),
    //     TransRef1: result[i]['TransRef1'].toString(),
    //     upcoming: double.parse(result[i]['upcoming'].toString()),
    //     Bil_City: result[i]['Bil_City'].toString(),
    //     Bil_State: result[i]['Bil_State'].toString(),
    //             CustomerName: result[i]['CustomerName'].toString(),
    //             CustomerCode:result[i]['CustomerCode'].toString()

    //     );
    // }
    // );
  }

  //new for outstanding
  static Future insertOutstandingMaster(
      List<outstandingData> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    log("outstandingDBModel len: ${values.length}");
    log("outstandingDBModel len: ${data.length}");

    var batch = db.batch();
    var existingRecords = await db.query(tableoutstanding);
    var customerCodesToDelete = <String>{};
    for (var record in existingRecords) {
      String customerCode2 = record['CustomerCode'].toString();

      if (!data.any(
          (element) => element['CustomerCode'].toString() == customerCode2)) {
        customerCodesToDelete.add(customerCode2);
        log("customerCodesToDelete len: ${customerCodesToDelete.length}");
      }
    }
    for (var es in data) {
      String customercode = es['CustomerCode'].toString();

      var existingRecord = await db.query(
        tableoutstanding,
        where: 'CustomerCode = ? ',
        whereArgs: [
          customercode,
        ],
      );
      // log("existingRecord::"+existingRecord.length.toString());

      if (existingRecord.isNotEmpty) {
        batch.update(
          tableoutstanding,
          es,
          where: 'CustomerCode = ? ',
          whereArgs: [
            customercode,
          ],
        );
      } else {
        batch.insert(tableoutstanding, es);
      }
    }

    for (var code in customerCodesToDelete) {
      await db.delete(
        tableoutstanding,
        where: 'CustomerCode = ?',
        whereArgs: [code],
      );
    }
    // data.forEach((es) async {

    //   batch.insert(tableoutstanding, es);
    //   log("tableoutstanding Batchhhh Item...");
    // });
    await batch.commit();
  }

  static Future insertOutstandingchild(
      List<outstandingLine> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    log("outstandingDBModel len: ${values.length}");
    log("outstandingDBModel len: ${data.length}");

    var batch = db.batch();
    for (var es in data) {
      String customercode = es['CustomerCode'].toString();
      String TransNum = es['TransNum'].toString();
      var existingRecord = await db.query(
        tableoutstandingline,
        where: 'CustomerCode = ? AND TransNum = ?',
        whereArgs: [customercode, TransNum],
      );
      if (existingRecord.isNotEmpty) {
        batch.update(
          tableoutstandingline,
          es,
          where: 'CustomerCode = ? AND TransNum = ?',
          whereArgs: [customercode, TransNum],
        );
      } else {
        batch.insert(tableoutstandingline, es);
      }
    }
    // data.forEach((es) async {

    //   batch.insert(tableoutstanding, es);
    //   log("tableoutstanding Batchhhh Item...");
    // });
    await batch.commit();
  }

  static Future<List<CustomerData>> getCustomerData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT * FROM $tableCustomerMaster;
    ''');

    // log("Saved AllocATE: " + result.toList().toString());

    return List.generate(result.length, (i) {
      log("Saved AllocATE length: ${result[i]['gst']}");

      return CustomerData(
          id: result[i]['id'] == null
              ? 0
              : int.parse(result[i]['id'].toString()),
          cardcode: result[i]['cardcode'] == null
              ? ""
              : result[i]['cardcode'].toString(),
          cardname: result[i]['cardname'] == null
              ? ""
              : result[i]['cardname'].toString(),
          cantactName: result[i]['contactName'] == null
              ? ""
              : result[i]['cantactName'].toString(),
          mobile:
              result[i]['mobile'] == null ? "" : result[i]['mobile'].toString(),
          alterMobileno: result[i]['alterMobileno'] == null
              ? ""
              : result[i]['alterMobileno'].toString(),
          email:
              result[i]['email'] == null ? "" : result[i]['email'].toString(),
          gst: result[i]['gst'] == null ? "" : result[i]['gst'].toString(),
          address1: result[i]['address1'] == null
              ? ""
              : result[i]['address1'].toString(),
          address2: result[i]['address2'] == null
              ? ""
              : result[i]['address2'].toString(),
          zipcode: result[i]['zipcode'] == null
              ? ""
              : result[i]['zipcode'].toString(),
          city: result[i]['city'] == null ? "" : result[i]['city'].toString(),
          state:
              result[i]['state'] == null ? "" : result[i]['state'].toString(),
          area: result[i]['area'] == null ? "" : result[i]['area'].toString(),
          tag: result[i]['tag'] == null ? "" : result[i]['tag'].toString());
    });
  }

  static Future<List<Map<String, Object?>>> getCallCustomer(
      Database db, String mobile) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT * FROM $tableCustomerMaster where cardcode=$mobile ;
    ''');

    log("Get Call Customer: ${result.toList()}");

    return result;
  }

  static Future insertAllCustomer(
      List<CustomerData> values, Database db) async {
    log("Start:insertEnqType ");
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableCustomerMaster, es);
    });

    await batch.commit();
  }
}
