import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';
import 'package:lightbluesky/helpers/customimage.dart';
import 'package:lightbluesky/helpers/urlbuilder.dart';

/// Notificatons page
/// - TODO: Group notifications
/// - TODO: Handle read
/// - TODO: Tap notification
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final controller = ScrollController();
  final List<bsky.Notification> items = List.empty(growable: true);

  String? cursor;

  @override
  void initState() {
    super.initState();
    _loadMore();
    controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    final res = await api.c.notification.listNotifications(cursor: cursor);

    cursor = res.data.cursor;

    setState(() {
      items.addAll(res.data.notifications);
    });
  }

  /// Scroll hook, loads data if scroll close to bottom
  void _onScroll() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.notifications_title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];

          IconData icon;
          String text;
          String? path;

          if (item.reason.isFollow) {
            icon = Icons.person_add;
            text = locale.notifications_follow;
            path = UrlBuilder.profile(item.author.handle);
          } else if (item.reason.isLike) {
            icon = Icons.favorite;
            text = locale.notifications_like;
          } else if (item.reason.isRepost) {
            icon = Icons.autorenew;
            text = locale.notifications_repost;
          } else {
            icon = Icons.question_mark;
            text = item.reason.name;
          }

          return Column(
            children: [
              ListTile(
                onTap:
                    path != null
                        ? () {
                          context.push(path!);
                        }
                        : null,
                leading: CircleAvatar(
                  backgroundImage:
                      item.author.avatar != null
                          ? CustomImage.provider(
                            url: item.author.avatar!,
                            caching: true,
                          )
                          : null,
                ),
                title: Text(item.author.displayName ?? item.author.handle),
                subtitle: Text(text),
                trailing: Icon(icon),
              ),
            ],
          );
        },
      ),
    );
  }
}
