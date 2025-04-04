import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('es')
  ];

  /// An unknown error happened
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;

  /// Sorting method for posts that picks the most popular first
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get sort_top;

  /// Sorting method for posts that picks the most recent fist
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get sort_latest;

  /// Open details about the application itself
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get drawer_about;

  /// Open settings for app
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawer_settings;

  /// Open source code
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get drawer_source;

  /// Open currently loggedin user's profile
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get drawer_my_profile;

  /// Quit current session
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawer_logout;

  /// Opens a snackbar when the user logged out
  ///
  /// In en, this message translates to:
  /// **'Logged out succesfully'**
  String get drawer_logout_ok;

  /// Title for page auth.dart
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get auth_title;

  /// Service to pick from when logging in
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get auth_service;

  /// Login using your handle or your linked email
  ///
  /// In en, this message translates to:
  /// **'Handle or email'**
  String get auth_handle;

  /// Password required for login
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// 2FA code required if user has it enabled on bsky's settings
  ///
  /// In en, this message translates to:
  /// **'2FA code'**
  String get auth_2fa;

  /// 2FA is enabled by the user and the code has just been sent
  ///
  /// In en, this message translates to:
  /// **'Your 2FA code has been sent to your email'**
  String get auth_2fa_sent;

  /// Start login procedure
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login;

  /// Amount of likes a feed has received
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no likes} =1{1 like} other{{count} likes}}'**
  String feed_nLikes(num count);

  /// Title for page hashtags.dart
  ///
  /// In en, this message translates to:
  /// **'Hashtags'**
  String get hashtags_title;

  /// Text shown when user has no hashtags saved
  ///
  /// In en, this message translates to:
  /// **'Your saved hashtags will be shown here'**
  String get hashtags_empty;

  /// Text shown when user adds a new hashtag
  ///
  /// In en, this message translates to:
  /// **'Hashtag saved'**
  String get hashtag_saved;

  /// Title for page notifications.dart
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// Notififies a new follower, the username is not included
  ///
  /// In en, this message translates to:
  /// **'followed you'**
  String get notifications_follow;

  /// Notififies a new like, the username is not included
  ///
  /// In en, this message translates to:
  /// **'liked your post'**
  String get notifications_like;

  /// Notififies a new repost, the username is not included
  ///
  /// In en, this message translates to:
  /// **'reposted your post'**
  String get notifications_repost;

  /// Title for page search.dart
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_title;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
