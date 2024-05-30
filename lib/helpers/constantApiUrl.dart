import 'package:sellerkitcalllog/helpers/Utils.dart';

class ConstantApiUrl {
  static String mainUrl = Utils.queryApi;
  //
  static String loginapi = 'PortalAuthenticate/MOBILELOGIN';
  static String loginVerificationApi = "Sellerkit_Flexi/v2/Logout";
  // static String getUrlapi =
  //     'http://164.52.217.188:81/api/PortalAuthenticate/RegisterUser?TenantId=';
  static String? getUrlapi(String customerId) {
    String meth =
        'http://164.52.217.188:81/api/PortalAuthenticate/RegisterUser?TenantId=$customerId';

    return meth;
  }

  static String? checkEnqDetailsApi(
    sapUserId,
    phoneNO,
  ) {
    String meth = 'SkClientPortal/Chkenquiry?phone=$phoneNO&Slpcode=$sapUserId';

    return meth;
  }

  static String? getUserListApi(
    String sapUserId,
  ) {
    String meth = 'Sellerkit_Flexi/v2/GetAllUsers?userId=$sapUserId';

    return meth;
  }

  static String? getOrderQTHApi(String docentry) {
    String meth = 'Sellerkit_Flexi/v2/Order?OrderId=$docentry';
    return meth;
  }

  static String? getLeadQTHDetailsApi(String docentry) {
    String meth = 'Sellerkit_Flexi/v2/Leads?leadId=$docentry';
    return meth;
  }

  static String? getLeadfarwordApi(String followupEntry) {
    String meth =
        'SkClientPortal/Updateleadfollowlinecollection?leaddocentry=$followupEntry';
    return meth;
  }

  static String? getCustomerApi = 'Sellerkit_Flexi/v2/Customers';
  static String? getCustomtagApi = 'SkClientPortal/GetallMaster?MasterTypeId=4';
  static String? getItemCategoryApi = 'SkClientPortal/GetCatogeryList';
  static String? getEnqreffre = 'SkClientPortal/GetallMaster?MasterTypeId=3';
  static String? getEnqtype = 'SkClientPortal/GetallMaster?MasterTypeId=2';
  static String? getstate = 'Sellerkit_Flexi/v2/Statelist';
  static String? levelOfApi = 'SkClientPortal/GetallMaster?MasterTypeId=20';
  static String? getOrderTypeApi =
      'SkClientPortal/GetallMaster?MasterTypeId=21';
  static String? enqPost = 'Sellerkit_Flexi/v2/Enquiry';
  static String? getCustomerDtlsByStore =
      'SkClientPortal/GetstoresbyId?Id=${Utils.storeid}';
  static String? getPaymodeApi = 'SkClientPortal/GetallMaster?MasterTypeId=18';
  static String? getLeadMadefollowupReson =
      'SkClientPortal/GetallMaster?MasterTypeId=15';
  static String? getLeadOpenApi = 'SkClientPortal/GetallMaster?MasterTypeId=8';
  static String? getLeadStatusApi =
      'SkClientPortal/GetallMaster?MasterTypeId=14';
  static String? allSaveLeadApi = 'Sellerkit_Flexi/v2/FollowupUpdate';
  static String? outStandingApi = 'Sellerkit_Flexi/v2/GetAllOutstandings';
  static String? getAllOrdersApi='Sellerkit_Flexi/v2/GetAllOrders';
  static String? getAllCustomerApi='Sellerkit_Flexi/v2/AllCustomers?';
  static String? addCustomerApi='Sellerkit_Flexi/v2/PostCustomer';
  static String? onboardScreenApi = 'http://164.52.217.188:81/api/PortalAuthenticate/GetInitialContent';
}
