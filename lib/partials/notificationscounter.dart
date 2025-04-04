import 'package:bluesky/bluesky.dart';
import 'package:bluesky/core.dart';
import 'package:flutter/material.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lightbluesky/common.dart';

/// Notification ListTile with badge containing nº of unread messages
class NotificationsCounter extends StatefulWidget {
  const NotificationsCounter({super.key});

  @override
  State<NotificationsCounter> createState() => _NotificationsCounterState();
}

class _NotificationsCounterState extends State<NotificationsCounter> {
  late Future<XRPCResponse<Count>> _futureUnread;

  @override
  void initState() {
    super.initState();

    _futureUnread = api.c.notification.getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    const icon = Icon(Icons.notifications);
    final locale = AppLocalizations.of(context)!;

    return ListTile(
      leading: FutureBuilder(
        future: _futureUnread,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final count = snapshot.data!.data.count;
            if (count > 0) {
              return Badge.count(count: count, child: icon);
            }
          }

          return icon;
        },
      ),
      title: Text(locale.notifications_title),
      onTap: () {
        context.go('/notifications');
      },
    );
  }
}
