import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:go_router/go_router.dart';
import 'package:lightbluesky/helpers/customimage.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';
import 'package:lightbluesky/helpers/urlbuilder.dart';

/// Common widget for
/// displaying actor's display name and/or handle and profile picture
class Actor extends StatelessWidget {
  const Actor({
    super.key,
    required this.actor,
    this.createdAt,
    this.tap = true,
  });

  /// Actor data
  final bsky.ActorBasic actor;

  /// Date for post relating to actor
  final DateTime? createdAt;

  /// Allow tapping to open actor's profile
  final bool tap;

  Widget _handleLink({required Widget child, required BuildContext context}) {
    return InkWell(
      onTap: tap ? () => context.push(UrlBuilder.profile(actor.handle)) : null,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return ListTile(
      leading: _handleLink(
        context: context,
        child: CircleAvatar(
          backgroundImage:
              actor.avatar != null
                  ? CustomImage.provider(url: actor.avatar!, caching: true)
                  : null,
        ),
      ),
      title: _handleLink(
        context: context,
        child: Text(actor.displayName ?? '@${actor.handle}'),
      ),
      subtitle: actor.displayName != null ? Text('@${actor.handle}') : null,
      trailing:
          createdAt != null
              ? Text(GetTimeAgo.parse(createdAt!, locale: locale.localeName))
              : null,
    );
  }
}
