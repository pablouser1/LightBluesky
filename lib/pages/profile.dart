import 'package:bluesky/bluesky.dart' as bsky;
import 'package:bluesky/core.dart';
import 'package:bluesky_text/bluesky_text.dart';
import 'package:flutter/material.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/helpers/customimage.dart';
import 'package:lightbluesky/models/customtab.dart';
import 'package:lightbluesky/partials/actor.dart';
import 'package:lightbluesky/partials/textwithfacets.dart';
import 'package:lightbluesky/widgets/exceptionhandler.dart';
import 'package:lightbluesky/widgets/feeds/multiple.dart';

/// Profile page, contains profile data and feed of user's posts
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.handleOrDid,
  });

  final String handleOrDid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late List<CustomTab> _tabs;

  late Future<XRPCResponse<bsky.ActorProfile>> _futureProfile;
  late TabController _tabController;
  final _scrollController = ScrollController();

  bool _following = false;
  AtUri? _followingAtUri;

  @override
  void initState() {
    super.initState();

    final filters = [
      bsky.FeedFilter.postsNoReplies,
      bsky.FeedFilter.postsWithReplies,
      bsky.FeedFilter.postsWithMedia,
    ];

    _tabs = filters
        .map(
          (f) => CustomTab(
            name: f.name,
            func: ({cursor}) => api.c.feed.getAuthorFeed(
              actor: widget.handleOrDid,
              cursor: cursor,
              filter: bsky.FeedFilter.values.firstWhere(
                (t) => t.index == f.index,
              ),
            ),
          ),
        )
        .toList();

    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );

    _futureProfile = api.c.actor.getProfile(actor: widget.handleOrDid);
    _futureProfile.then((actor) {
      _following = actor.data.viewer.isFollowing;
      _followingAtUri = actor.data.viewer.following;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleFollow(String did) async {
    final oldFollowing = _following;
    setState(() {
      _following = !_following;
    });

    if (oldFollowing) {
      // Unfollow
      api.c.atproto.repo.deleteRecord(
        uri: _followingAtUri!,
      );

      _followingAtUri = null;
    } else {
      // Follow
      final res = await api.c.graph.follow(
        did: did,
      );

      _followingAtUri = res.data.uri;
    }
  }

  Widget _makeProfileCard(bsky.ActorProfile actor) {
    final facetsFuture = actor.description != null
        ? BlueskyText(
            actor.description!,
          ).entities.toFacets()
        : Future.value(
            List<Map<String, dynamic>>.empty(
              growable: false,
            ),
          );
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Actor(
            actor: bsky.ActorBasic(
              did: actor.did,
              handle: actor.handle,
              displayName: actor.displayName,
              avatar: actor.avatar,
              associated: actor.associated,
              viewer: actor.viewer,
              labels: actor.labels,
            ),
            tap: false,
          ),
          if (actor.did != api.c.session?.did)
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _toggleFollow(actor.did),
                  label: Text(_following ? "Unfollow" : "Follow"),
                  icon: Icon(_following ? Icons.remove : Icons.add),
                ),
              ],
            ),
          if (actor.description != null)
            FutureBuilder(
              future: facetsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TextWithFacets(
                    text: actor.description!,
                    facets: snapshot.data!.map(bsky.Facet.fromJson).toList(),
                  );
                } else if (snapshot.hasError) {
                  return ExceptionHandler(exception: snapshot.error!);
                }

                return const LinearProgressIndicator();
              },
            ),
        ],
      ),
    );
  }

  List<Widget> _handleTabs() {
    List<Widget> widgets = [];

    for (final tab in _tabs) {
      widgets.add(
        Tab(
          text: tab.name,
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(
        tabs: _handleTabs(),
        controller: _tabController,
        isScrollable: true,
      ),
      body: FutureBuilder(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final actor = snapshot.data!.data;
            return NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    primary: true,
                    pinned: true,
                    title: Text(actor.displayName ?? actor.handle),
                    expandedHeight: actor.banner != null ? 150.0 : null,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    flexibleSpace: FlexibleSpaceBar(
                      background: actor.banner != null
                          ? CustomImage.normal(
                              url: actor.banner!,
                              fit: BoxFit.cover,
                              caching: false,
                            )
                          : null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _makeProfileCard(actor),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  )
                ];
              },
              body: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: MultipleFeeds(
                  tabController: _tabController,
                  scrollController: _scrollController,
                  tabs: _tabs,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return ExceptionHandler(
              exception: snapshot.error!,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        },
      ),
    );
  }
}
