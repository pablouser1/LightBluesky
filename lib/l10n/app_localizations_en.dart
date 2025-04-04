// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get unknown_error => 'Unknown error';

  @override
  String get sort_top => 'Top';

  @override
  String get sort_latest => 'Latest';

  @override
  String get drawer_about => 'About';

  @override
  String get drawer_settings => 'Settings';

  @override
  String get drawer_source => 'Source';

  @override
  String get drawer_my_profile => 'My profile';

  @override
  String get drawer_logout => 'Logout';

  @override
  String get drawer_logout_ok => 'Logged out succesfully';

  @override
  String get auth_title => 'Authentication';

  @override
  String get auth_service => 'Service';

  @override
  String get auth_handle => 'Handle or email';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_2fa => '2FA code';

  @override
  String get auth_2fa_sent => 'Your 2FA code has been sent to your email';

  @override
  String get auth_login => 'Login';

  @override
  String feed_nLikes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString likes',
      one: '1 like',
      zero: 'no likes',
    );
    return '$_temp0';
  }

  @override
  String get hashtags_title => 'Hashtags';

  @override
  String get hashtags_empty => 'Your saved hashtags will be shown here';

  @override
  String get hashtag_saved => 'Hashtag saved';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get notifications_follow => 'followed you';

  @override
  String get notifications_like => 'liked your post';

  @override
  String get notifications_repost => 'reposted your post';

  @override
  String get search_title => 'Search';
}
