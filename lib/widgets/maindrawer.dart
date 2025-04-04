import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/constants/app.dart';
import 'package:lightbluesky/helpers/ui.dart';
import 'package:lightbluesky/helpers/urlbuilder.dart';
import 'package:lightbluesky/partials/notificationscounter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';

/// Drawer, shown only on home page
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Column(
              children: [
                const Expanded(child: Text(App.name)),
                TextButton.icon(
                  onPressed: () async {
                    final packageInfo = await PackageInfo.fromPlatform();

                    if (!context.mounted) return;

                    showAboutDialog(
                      context: context,
                      applicationName: packageInfo.appName,
                      applicationVersion: packageInfo.version,
                    );
                  },
                  icon: const Icon(Icons.info),
                  label: Text(locale.drawer_about),
                ),
              ],
            ),
          ),
          // SEARCH
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(locale.search_title),
            onTap: () {
              context.go('/search');
            },
          ),
          // NOTIFICATIONS
          const NotificationsCounter(),
          // FEEDS
          ListTile(
            leading: const Icon(Icons.feed),
            title: const Text('Feeds'),
            onTap: () {
              context.go('/feeds');
            },
          ),
          // BOOKMARKS
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Bookmarks'),
            onTap: () {
              context.go('/bookmarks');
            },
          ),
          // SETTINGS
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(locale.drawer_settings),
            onTap: () {
              Ui.dialog(context, "Under construction", "TODO: Add settings");
            },
          ),
          // SOURCE CODE
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(locale.drawer_source),
            onTap: () {
              Ui.openUrl(App.source);
            },
          ),
          ExpansionTile(
            title: Text(api.c.session!.handle),
            children: [
              // PROFILE
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(locale.drawer_my_profile),
                onTap: () {
                  context.go(UrlBuilder.profile(api.c.session!.did));
                },
              ),
              // LOGOUT
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(locale.drawer_logout),
                onTap: () {
                  api.logout();

                  Ui.snackbar(context, locale.drawer_logout_ok);

                  context.go('/login');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
