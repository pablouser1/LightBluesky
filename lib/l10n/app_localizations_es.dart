// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get unknown_error => 'Error desconocido';

  @override
  String get sort_top => 'Popular';

  @override
  String get sort_latest => 'Reciente';

  @override
  String get drawer_about => 'Acerca de';

  @override
  String get drawer_settings => 'Ajustes';

  @override
  String get drawer_source => 'Código fuente';

  @override
  String get drawer_my_profile => 'Mi perfil';

  @override
  String get drawer_logout => 'Cerrar sesión';

  @override
  String get drawer_logout_ok => 'Sesión cerrada exitosamente';

  @override
  String get auth_title => 'Autentificación';

  @override
  String get auth_service => 'Servicio';

  @override
  String get auth_handle => 'Nombre de usuario / correo electrónico';

  @override
  String get auth_password => 'Contraseña';

  @override
  String get auth_2fa => 'Autentificación de dos pasos';

  @override
  String get auth_2fa_sent => 'Código enviado a tu correo electrónico';

  @override
  String get auth_login => 'Iniciar sesión';

  @override
  String feed_nLikes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString favoritos',
      one: '1 favorito',
      zero: 'no hay favoritos',
    );
    return '$_temp0';
  }

  @override
  String get hashtags_title => 'Etiquetas';

  @override
  String get hashtags_empty => 'Tus etiquetas se verán aquí cuando las guardes';

  @override
  String get hashtag_saved => 'Etiqueta guardada';

  @override
  String get notifications_title => 'Notificaciones';

  @override
  String get notifications_follow => 'te ha seguido';

  @override
  String get notifications_like => 'le ha gustado tu publicación';

  @override
  String get notifications_repost => 'ha reposteado tu publicación';

  @override
  String get search_title => 'Buscar';
}
