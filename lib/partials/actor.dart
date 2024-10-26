import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/material.dart';
import 'package:lightbluesky/helpers/ui.dart';
import 'package:lightbluesky/pages/profile.dart';

/// Common widget for
/// displaying actor's display name and/or handle and profile picture
class Actor extends StatelessWidget {
  const Actor({super.key, required this.actor, this.tap = true});

  /// Actor data
  final bsky.ActorBasic actor;

  /// Allow tapping to open actor's profile
  final bool tap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap
          ? () => Ui.nav(
                context,
                ProfilePage(did: actor.did),
              )
          : null,
      leading: CircleAvatar(
        // TODO: Use CustomImage
        backgroundImage:
            actor.avatar != null ? Image.network(actor.avatar!).image : null,
      ),
      title: Text(
        actor.displayName != null ? actor.displayName! : '@${actor.handle}',
      ),
      subtitle: actor.displayName != null ? Text('@${actor.handle}') : null,
    );
  }
}