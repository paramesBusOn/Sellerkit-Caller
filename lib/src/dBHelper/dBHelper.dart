import 'dart:developer';
import 'package:sellerkitcalllog/src/api/customerTagApi/customerTagApi.dart';
import 'package:sellerkitcalllog/src/api/enqTypeApi/enqTypeApi.dart';
import 'package:sellerkitcalllog/src/api/getRefferalApi/getRefferalApi.dart';
import 'package:sellerkitcalllog/src/api/getUserListApi/getUserListApi.dart';
import 'package:sellerkitcalllog/src/dBModel/AuthorizationDB.dart';
import 'package:sellerkitcalllog/src/dBModel/EnqTypeModel.dart';
import 'package:sellerkitcalllog/src/dBModel/ScreenShotModel.dart';
import 'package:sellerkitcalllog/src/dBModel/enquiry_filterdbmodel.dart';
import 'package:sellerkitcalllog/src/dBModel/outstandingDBmodel.dart';
import 'package:sellerkitcalllog/src/dBModel/outstandinglinechild.dart';
import 'package:sellerkitcalllog/src/dBModel/stateDBModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../api/leadUpdateFollowiupApi/getLeadStatusApi.dart';
import '../dBModel/NotificationModel.dart';
import '../dBModel/getAllCustomerDbModel.dart';

class DBHelper {
  static Database? _db;

  static Future<Database?> getInstance() async {
   String path = await getDatabasesPath();
    if (_db == null) {
      _db = await openDatabase(join(path, "SellerKitCaller.db"),
          version: 1, onCreate: createTable);
    }
    return _db;
  }

  static void createTable(Database database, int version) async {
    await database.execute('''
           create table $tableEnqType(
             ETId integer primary key autoincrement,
             ${EnqTypeDBModel.code} varchar ,
             ${EnqTypeDBModel.name} varchar 
             )
        ''');
    await database.execute('''
           create table $tableEnquiryfilter(
             ETId integer primary key autoincrement,
             ${EnquiryfilterDBcolumns.enqID} int,
             ${EnquiryfilterDBcolumns.enquiredOn} varchar ,
             ${EnquiryfilterDBcolumns.cardCode} varchar ,
             ${EnquiryfilterDBcolumns.cardName} varchar ,
             ${EnquiryfilterDBcolumns.enqDate} varchar ,
             ${EnquiryfilterDBcolumns.followup} varchar ,
             ${EnquiryfilterDBcolumns.status} varchar ,
             ${EnquiryfilterDBcolumns.mgrUserCode} varchar ,
             ${EnquiryfilterDBcolumns.mgrUserName} varchar ,
             ${EnquiryfilterDBcolumns.assignedToUser} varchar ,
             ${EnquiryfilterDBcolumns.assignedToUserName} varchar ,
             ${EnquiryfilterDBcolumns.enqType} varchar ,
             ${EnquiryfilterDBcolumns.lookingfor} varchar ,
             ${EnquiryfilterDBcolumns.potentialValue} decimal ,
             ${EnquiryfilterDBcolumns.addressLine1} varchar ,
             ${EnquiryfilterDBcolumns.addressLine2} varchar ,
             ${EnquiryfilterDBcolumns.pincode} varchar ,
             ${EnquiryfilterDBcolumns.city} varchar ,
             ${EnquiryfilterDBcolumns.state} varchar ,
             ${EnquiryfilterDBcolumns.country} varchar ,
             ${EnquiryfilterDBcolumns.managerStatusTab} varchar ,
             ${EnquiryfilterDBcolumns.slpStatusTab} varchar ,
             ${EnquiryfilterDBcolumns.email} varchar ,
             ${EnquiryfilterDBcolumns.referal} varchar ,
             ${EnquiryfilterDBcolumns.contactName} varchar ,
             ${EnquiryfilterDBcolumns.altermobileNo} varchar ,
             ${EnquiryfilterDBcolumns.customerGroup} varchar ,
             ${EnquiryfilterDBcolumns.customermobile} varchar ,
             ${EnquiryfilterDBcolumns.comapanyname} varchar ,
             ${EnquiryfilterDBcolumns.storecode} varchar ,
             ${EnquiryfilterDBcolumns.area} varchar ,
             ${EnquiryfilterDBcolumns.district} varchar ,
             ${EnquiryfilterDBcolumns.itemCode} varchar ,
             ${EnquiryfilterDBcolumns.itemname} varchar ,
             ${EnquiryfilterDBcolumns.enquirydscription} varchar ,
             ${EnquiryfilterDBcolumns.quantity} decimal ,
             ${EnquiryfilterDBcolumns.isVisitRequired} varchar ,
             ${EnquiryfilterDBcolumns.visitTime} varchar ,
             ${EnquiryfilterDBcolumns.remindOn} varchar ,
             ${EnquiryfilterDBcolumns.isClosed} varchar ,
             ${EnquiryfilterDBcolumns.leadConverted} varchar ,
             ${EnquiryfilterDBcolumns.createdBy} int ,
             ${EnquiryfilterDBcolumns.createdDateTime} varchar ,
             ${EnquiryfilterDBcolumns.updatedBy} int ,
             ${EnquiryfilterDBcolumns.updatedDateTime} varchar ,
             ${EnquiryfilterDBcolumns.interestLevel} varchar ,
             ${EnquiryfilterDBcolumns.orderType} varchar
             
             )
        ''');

    await database.execute('''
           create table $tableCusTagType(
             ETId integer primary key autoincrement,
             ${CusTagTypeDBModel.code} varchar ,
             ${CusTagTypeDBModel.name} varchar 
             )
        ''');
    await database.execute('''
           create table $tableLevelof(
             ETId integer primary key autoincrement,
             ${CusLevelDBModel.code} varchar ,
             ${CusLevelDBModel.name} varchar 
             )
        ''');
    await database.execute('''
           create table $tableOrderType(
             ETId integer primary key autoincrement,
             ${OrderTypeDBModel.code} varchar ,
             ${OrderTypeDBModel.name} varchar 
             )
        ''');

    await database.execute('''
           create table $tableEnqReffers(
             ERId integer primary key autoincrement,
             ${EnqReffersDBModel.code} varchar ,
             ${EnqReffersDBModel.name} varchar 
             )
        ''');
    await database.execute('''
           create table $tableUserList(
             UId integer primary key autoincrement,
             ${UserListDBModel.slpcode} varchar,
              ${UserListDBModel.managerSlp} varchar,
             ${UserListDBModel.userName} varchar ,
             ${UserListDBModel.userCode} varchar ,
             ${UserListDBModel.salesEmpID} integer ,
             ${UserListDBModel.color} integer ,
             ${UserListDBModel.storeid} integer 

             )
        ''');
    await database.execute('''
           create table $tableLeadStatusReason(
             LRId integer primary key autoincrement,
             ${LeadStatusReason.code} varchar ,
             ${LeadStatusReason.name} varchar ,
             ${LeadStatusReason.statusType} integer 
             )
        ''');
    await database.execute('''
           create table $tableOrderStatusReason(
             LRId integer primary key autoincrement,
             ${OrderStatusReason.code} varchar ,
             ${OrderStatusReason.name} varchar ,
             ${OrderStatusReason.statusType} varchar 
             )
        ''');

    await database.execute('''
           create table $tableOfferZone(
             OSZId integer primary key autoincrement,
             ${OfferZoneColumns.offerName} varchar ,
             ${OfferZoneColumns.offerZoneId} integer ,
             ${OfferZoneColumns.itemCode} varchar ,
             ${OfferZoneColumns.offerDetails} varchar ,
             ${OfferZoneColumns.mediaurl1} varchar ,
             ${OfferZoneColumns.mediaurl2} varchar ,
             ${OfferZoneColumns.incentive} varchar ,
             ${OfferZoneColumns.validTill} varchar 
            )
        ''');
    await database.execute('''
           create table $tableOfferZonechild1(
             
             ${offerzoneColumnchild1.id} varchar,
             ${offerzoneColumnchild1.itemid} varchar,
             ${offerzoneColumnchild1.offer} varchar,
             ${offerzoneColumnchild1.offerid} varchar,
             ${offerzoneColumnchild1.relaventTags} varchar
             
            )
        ''');

    await database.execute('''
           create table $tableOfferZonechild2(
             
             ${offerzoneColumnchild2.id2} varchar ,
             ${offerzoneColumnchild2.offerId2} varchar ,
             ${offerzoneColumnchild2.storeId} varchar 
            
             
            )
        ''');

        await database.execute(
        '''
           create table $tableCustomerMaster(
             OPLId integer primary key autoincrement,
             ${CustomerMasterDB.id} int ,
             ${CustomerMasterDB.cardcode} varchar ,
             ${CustomerMasterDB.cardname} varchar ,
             ${CustomerMasterDB.mobile} varchar ,
             ${CustomerMasterDB.alterMobileno} varchar ,
             ${CustomerMasterDB.email} varchar ,
             ${CustomerMasterDB.gst} varchar ,
             ${CustomerMasterDB.address1} varchar ,
             ${CustomerMasterDB.address2} varchar ,
             ${CustomerMasterDB.city} varchar ,
             ${CustomerMasterDB.area} varchar ,
             ${CustomerMasterDB.state} varchar ,
             ${CustomerMasterDB.zipcode} varchar ,
             ${CustomerMasterDB.tag} varchar ,
             ${CustomerMasterDB.cantactName} varchar 
             )
        ''');

    await database.execute('''
           create table $tableNotification(
             NId integer primary key autoincrement,
             ${Notification.docEntry} int ,
             ${Notification.title} varchar ,
             ${Notification.imgurl} varchar ,
             ${Notification.description} varchar ,
             ${Notification.receiveTime} varchar ,
             ${Notification.seenTime} varchar ,
             ${Notification.naviScn} varchar ,
             ${Notification.jobid} int 
             )
        ''');

    await database.execute('''
           create table $tableStateMaster(
             OPLId integer primary key autoincrement,
             ${StateMasterDB.statecode} varchar ,
             ${StateMasterDB.statename} varchar ,
             ${StateMasterDB.cuntrycode} varchar ,
             ${StateMasterDB.countryname} varchar 
             )
        ''');

    await database.execute('''
           create table $tableScreenShot(
             SId integer primary key autoincrement,
             ${ScreenShotTab.Filepath} varchar ,
             ${ScreenShotTab.DateTime} varchar 
             )
        ''');
    await database.execute('''
           create table $loginverificationDB(
             SId integer primary key autoincrement,
             ${LoginVerificationDB.id} int ,
             ${LoginVerificationDB.code} varchar ,
             ${LoginVerificationDB.restrictionType} int ,
             ${LoginVerificationDB.restrictionData} varchar ,
            ${LoginVerificationDB.remarks} varchar 

             )
        ''');

        await database.execute(
        '''
           create table $tableoutstanding(
             SId integer primary key autoincrement,
             ${outsatandingDBcolumns.customerCode} varchar,
             ${outsatandingDBcolumns.customerName} varchar,
             ${outsatandingDBcolumns.customerMobile} varchar,
             ${outsatandingDBcolumns.alternateMobileNo} varchar,
             ${outsatandingDBcolumns.contactName} varchar,
             ${outsatandingDBcolumns.customerEmail} varchar,
             ${outsatandingDBcolumns.companyName} varchar,
             ${outsatandingDBcolumns.customerGroup} varchar,
             ${outsatandingDBcolumns.gstNo} varchar,
             ${outsatandingDBcolumns.storeCode} varchar,
             ${outsatandingDBcolumns.assignedTo} varchar,
             ${outsatandingDBcolumns.transAmount} decimal,
             ${outsatandingDBcolumns.penaltyAfterDue} decimal,
             ${outsatandingDBcolumns.collectionInc} decimal,
             ${outsatandingDBcolumns.amountPaid} decimal,
             ${outsatandingDBcolumns.balanceToPay} decimal
             )
        ''');

    await database.execute(
        '''
           create table $tableoutstandingline(
             SId integer primary key autoincrement,
             ${outsatandinglineDBcolumns.docentry} int,
             ${outsatandinglineDBcolumns.customerCode} varchar,
             ${outsatandinglineDBcolumns.customerName} varchar,
             ${outsatandinglineDBcolumns.customerMobile} varchar,
             ${outsatandinglineDBcolumns.alternateMobileNo} varchar,
             ${outsatandinglineDBcolumns.contactName} varchar,
             ${outsatandinglineDBcolumns.customerEmail} varchar,
             ${outsatandinglineDBcolumns.companyName} varchar,
             ${outsatandinglineDBcolumns.customerGroup} varchar,
             ${outsatandinglineDBcolumns.gstNo} varchar,
             ${outsatandinglineDBcolumns.customerPORef} varchar,
             ${outsatandinglineDBcolumns.bil_Address1} varchar,
             ${outsatandinglineDBcolumns.bil_Address2} varchar,
             ${outsatandinglineDBcolumns.bil_Address3} varchar,
             ${outsatandinglineDBcolumns.bil_Area} varchar,
             ${outsatandinglineDBcolumns.bil_City} varchar,
             ${outsatandinglineDBcolumns.bil_District} varchar,
             ${outsatandinglineDBcolumns.bil_State} varchar,
             ${outsatandinglineDBcolumns.bil_Country} varchar,
             ${outsatandinglineDBcolumns.bil_Pincode} varchar,
             ${outsatandinglineDBcolumns.storeCode} varchar,
             ${outsatandinglineDBcolumns.assignedTo} varchar,
             ${outsatandinglineDBcolumns.transNum} varchar,
             ${outsatandinglineDBcolumns.transDate} varchar,
             ${outsatandinglineDBcolumns.transDueDate} varchar,
             ${outsatandinglineDBcolumns.transType} varchar,
             ${outsatandinglineDBcolumns.transRef1} varchar,
             ${outsatandinglineDBcolumns.loanRef} varchar,
             ${outsatandinglineDBcolumns.collectionType} varchar,
             ${outsatandinglineDBcolumns.transAmount} decimal,
             ${outsatandinglineDBcolumns.penaltyAfterDue} decimal,
             ${outsatandinglineDBcolumns.collectionInc} decimal,
             ${outsatandinglineDBcolumns.amountPaid} decimal,
             ${outsatandinglineDBcolumns.balanceToPay} decimal,
             ${outsatandinglineDBcolumns.status} varchar,
             ${outsatandinglineDBcolumns.createdBy} int,
             ${outsatandinglineDBcolumns.createdOn} varchar,
             ${outsatandinglineDBcolumns.updatedBy} int,
             ${outsatandinglineDBcolumns.updatedOn} varchar,
             ${outsatandinglineDBcolumns.traceid} varchar
            
            
             )
        ''');
  }

  Future insertEnqType(List<EnquiryTypeData> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableEnqType, es);
      log("Enq Batchhhh Item...");
    });
    await batch.commit();
  }

  Future insertCusTagType(List<CustomerTagTypeData2> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableCusTagType, es);
      log("Enq Batchhhh Item...");
    });
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
    List<CustomerTagTypeData2> valu = value[1];
    var data = valu.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableCusTagType, es);
    });
    await batch.commit();
  }

  Future<List<EnquiryTypeData>> getEnqData(Database db) async {
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

  Future<List<EnquiryTypeData>> getCusTagData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM CusTagType;
''');

    return List.generate(result.length, (i) {
      return EnquiryTypeData(
        Code: result[i]['Code'].toString(),
        Name: result[i]['Name'].toString(),
      );
    });
  }


  Future<void> truncareEnqType(Database db) async {
    await db.rawQuery('delete from $tableEnqType');
  }

  Future<void> truncareCusTagType(Database db) async {
    await db.rawQuery('delete from $tableCusTagType');
  }

  Future<void> truncareEnqReffers(Database db) async {
    await db.rawQuery('delete from $tableEnqReffers');
  }

  Future insertEnqReffers(List<EnqRefferesData> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();

    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableEnqReffers, es);
      log("Enq Batchhhh Item...");
    });
    await batch.commit();
  }

  indertIsoReferral(List<dynamic> value) async {
    List<EnqRefferesData> values = value[1];
    var data = values.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableEnqReffers, es);
    });
    await batch.commit();
  }

  Future<List<EnqRefferesData>> getEnqRefferes(Database db) async {
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

  Future insertUserList(List<UserListData> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableUserList, es);
      print("Data...");
    });
    await batch.commit();
  }

  indertIsoUserList(List<dynamic> value) async {
    List<UserListData> values = value[1];
    var data = values.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableUserList, es);
    });
    await batch.commit();
  }

  Future<List<UserListData>> getUserList(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM $tableUserList;
''');

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

  Future insertLeadStatusList(
      List<GetLeadStatusData> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableLeadStatusReason, es);
      print("LeadStatusList...");
    });
    await batch.commit();
  }

  indertIsoLeadStatusList(List<dynamic> value) async {
    List<GetLeadStatusData> values = value[1];
    var data = values.map((e) => e.toMap()).toList();

    var batch = value[2].batch();
    data.forEach((es) async {
      batch.insert(tableLeadStatusReason, es);
    });
    await batch.commit();
  }

  Future<List<GetLeadStatusData>> getLeadStatusOpen(Database db) async {
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

  Future<List<GetLeadStatusData>> getLeadStatusWon(Database db) async {
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

  Future<List<GetLeadStatusData>> getLeadStatusLost(Database db) async {
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

  Future insertNotification(List<NotificationModel> values, Database db) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(tableNotification, es);
    });
    await batch.commit();
  }

  Future<List<NotificationModel>> getNotification(Database db) async {
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

  Future<int?> getUnSeenNotificationCount(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT count(NId) from $tableNotification where SeenTime = '0';
    ''');

    int? count = Sqflite.firstIntValue(result);

    return count;
  }

  updateNotify(int id, String time, Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      UPDATE $tableNotification
    SET SeenTime = "$time" WHERE NId = $id;
    ''');
  }

  deleteNotify(int id, Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      delete from $tableNotification WHERE DocEntry = $id;
    ''');
  }

  deleteNotifyAll(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
      delete from $tableNotification;
    ''');
  }

  Future<void> truncateOfferZone(Database db) async {
    await db.rawQuery('delete from $tableOfferZone');
  }

  static Future<void> truncateOfferZonechild1(Database db) async {
    await db.rawQuery('delete from $tableOfferZonechild1');
  }

  static Future<void> truncateOfferZonechild2(Database db) async {
    await db.rawQuery('delete from $tableOfferZonechild2');
  }

  Future<void> truncateUserList(Database db) async {
    await db.rawQuery('delete from $tableUserList');
  }

  Future<void> truncateLeadstatus(Database db) async {
    await db.rawQuery('delete from $tableLeadStatusReason');
  }

  Future<void> truncateNotification(Database db) async {
    await db.rawQuery('delete from $tableNotification');
  }
}
