import 'package:bluesky/bluesky.dart';
import 'package:bluesky/core.dart';
import 'package:flutter/material.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/models/customtab.dart';
import 'package:lightbluesky/widgets/feeds/multiple.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';

/// Hashtag page
class SearchTermPage extends StatefulWidget {
  const SearchTermPage({super.key, required this.q});

  /// Search term
  ///
  /// Example: art
  final String q;

  @override
  State<SearchTermPage> createState() => _SearchTermPageState();
}

class _SearchTermPageState extends State<SearchTermPage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late TabController _tabController;

  /// Wrapper made to adapt function to Feed type
  Future<XRPCResponse<Feed>> _func(String sort, String? cursor) async {
    final res = await api.c.feed.searchPosts(widget.q, sort: sort);

    // Copy response with modified Feed
    return XRPCResponse(
      headers: res.headers,
      status: res.status,
      request: res.request,
      rateLimit: res.rateLimit,
      data: Feed(
        feed: List.generate(
          res.data.posts.length,
          (index) => FeedView(post: res.data.posts[index]),
        ),
        cursor: res.data.cursor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, // Top + latest
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    final tabs = [
      CustomTab(
        name: locale.sort_top,
        func: ({cursor}) => _func('top', cursor),
      ),
      CustomTab(
        name: locale.sort_latest,
        func: ({cursor}) => _func('latest', cursor),
      ),
    ];

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(widget.q),
              primary: true,
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: TabBar(
                tabs: [for (final tab in tabs) Tab(text: tab.name)],
                controller: _tabController,
                isScrollable: true,
              ),
            ),
          ];
        },
        body: MultipleFeeds(
          tabController: _tabController,
          scrollController: _scrollController,
          tabs: tabs,
        ),
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
