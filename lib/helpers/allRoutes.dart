import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:sellerkitcalllog/src/pages/DownloadDatasPage.dart/DownloadDataPage.dart';
import 'package:sellerkitcalllog/src/pages/addCustomer/screens/addCustomerPage.dart';
import 'package:sellerkitcalllog/src/pages/callLog/screens/callLogPage.dart';
import 'package:sellerkitcalllog/src/pages/dasboard/screens/dashboardPage.dart';
import 'package:sellerkitcalllog/src/pages/enquiries/screens/newEnquiry.dart';
import 'package:sellerkitcalllog/src/pages/login/screen/loginscreen.dart';
import 'package:sellerkitcalllog/src/pages/loginwithSellerkit/screens/loginwithSellerkitPage.dart';
import 'package:sellerkitcalllog/src/pages/onBoarding/onBoardingScreen.dart';
import 'package:sellerkitcalllog/src/pages/splash/screen/splashPage.dart';
import 'package:sellerkitcalllog/src/widgets/RestrictedPage.dart';
import 'constantRoutes.dart';

class Routes {
  static List<GetPage> allRoutes = [
    GetPage<dynamic>(
        name: ConstantRoutes.dashboard,
        page: () => const DashboardPage(
              title: '',
            ),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.loginwithSellerkit,
        page: () => const LoginwithSellerKit(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.splash,
        page: () => const SplashPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.onBoard,
        page: () => const OnBoardingScreen(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.restrictionValue,
        page: () => const RestrictionPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.download,
        page: () => const DownloadPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.login,
        page: () => const LoginPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    // GetPage<dynamic>(
    //     name: ConstantRoutes.callnotification,
    //     page: () => testpage(),
    //     transition: Transition.fade,
    //     transitionDuration: const Duration(seconds: 1)),
    GetPage<dynamic>(
        name: ConstantRoutes.newEnqpage,
        page: () =>  const NewEnquiry(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
           GetPage<dynamic>(
        name: ConstantRoutes.newCustomer,
        page: () =>   NewCustomerReg(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
            GetPage<dynamic>(
        name: ConstantRoutes.callLog,
        page: () =>   const CallLogPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
  ];
}
