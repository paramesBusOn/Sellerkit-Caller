import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @sellerkitCrm_name.
  ///
  /// In en, this message translates to:
  /// **'SELLERKIT-CALLER'**
  String get sellerkitCrm_name;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @configuration_name.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration_name;

  /// No description provided for @dashboard_name.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard_name;

  /// No description provided for @sellerkitCaller_appname.
  ///
  /// In en, this message translates to:
  /// **'Seller Kit Caller\n Dashboard'**
  String get sellerkitCaller_appname;

  /// No description provided for @login_with_sellerkit.
  ///
  /// In en, this message translates to:
  /// **'Login with Seller kit'**
  String get login_with_sellerkit;

  /// No description provided for @iaccept.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get iaccept;

  /// No description provided for @termsandCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsandCondition;

  /// No description provided for @authorizationSucessfull.
  ///
  /// In en, this message translates to:
  /// **'Authorization Successful'**
  String get authorizationSucessfull;

  /// No description provided for @authorizationFailure.
  ///
  /// In en, this message translates to:
  /// **'Authorization Failure \n try again later..'**
  String get authorizationFailure;

  /// No description provided for @loadingInialData.
  ///
  /// In en, this message translates to:
  /// **'Loading Initial Data Please wait..!!'**
  String get loadingInialData;

  /// No description provided for @locationAlert.
  ///
  /// In en, this message translates to:
  /// **'Location is must for login..!!\nGo to the App Settings Change Location Status'**
  String get locationAlert;

  /// No description provided for @locationAlert_permissoinAlertbox.
  ///
  /// In en, this message translates to:
  /// **'Location Services is mandatory to verify that device is within the Location designated by your Organisation.'**
  String get locationAlert_permissoinAlertbox;

  /// No description provided for @yourwhitelistedZone.
  ///
  /// In en, this message translates to:
  /// **'You are out of Whitelisted zone..!!!'**
  String get yourwhitelistedZone;

  /// No description provided for @checkInternetConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connectivity..!!'**
  String get checkInternetConnectivity;

  /// No description provided for @apiversion.
  ///
  /// In en, this message translates to:
  /// **'API Version'**
  String get apiversion;

  /// No description provided for @appversion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appversion;

  /// No description provided for @clickHeretoGo.
  ///
  /// In en, this message translates to:
  /// **'Click here to go '**
  String get clickHeretoGo;

  /// No description provided for @configure_name.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configure_name;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @login_name.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_name;

  /// No description provided for @yes_name.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes_name;

  /// No description provided for @no_name.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no_name;

  /// No description provided for @done_name.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done_name;

  /// No description provided for @skip_name.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip_name;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required*'**
  String get required;

  /// No description provided for @close_btn.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close_btn;

  /// No description provided for @save_btn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_btn;

  /// No description provided for @login_btn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_btn;

  /// No description provided for @logout_btn.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout_btn;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @ok_btn.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok_btn;

  /// No description provided for @cancel_btn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_btn;

  /// No description provided for @enterCustomerId.
  ///
  /// In en, this message translates to:
  /// **'Enter the Customer Id'**
  String get enterCustomerId;

  /// No description provided for @customerId_name.
  ///
  /// In en, this message translates to:
  /// **'Customer ID'**
  String get customerId_name;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
