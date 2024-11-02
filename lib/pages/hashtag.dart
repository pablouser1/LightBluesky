import 'package:bluesky/bluesky.dart';
import 'package:bluesky/core.dart';
import 'package:flutter/material.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/models/customtab.dart';
import 'package:lightbluesky/widgets/multiplefeeds.dart';

class HashtagPage extends StatefulWidget {
  const HashtagPage({super.key, required this.name});

  final String name;

  @override
  State<HashtagPage> createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late TabController _tabController;
  bool _loading = true;

  /// Feed generators data
  final List<CustomTab> _tabs = List.empty(
    growable: true,
  );

  /// Wrapper made to adapt function to Feed type
  Future<XRPCResponse<Feed>> _func(String type, String? cursor) async {
    final res = await api.c.feed.searchPosts(
      '#${widget.name}',
    );

    return XRPCResponse(
      headers: res.headers,
      status: res.status,
      request: res.request,
      rateLimit: res.rateLimit,
      data: Feed(
        feed: List.generate(
          res.data.posts.length,
          (index) => FeedView(
            post: res.data.posts[index],
          ),
        ),
        cursor: res.data.cursor,
      ),
    );
  }

  /// Init widget
  Future<void> _init() async {
    setState(() {
      _loading = true;
    });

    // Get feed generators pinned by user
    _tabController = TabController(
      length: 2, // Top + latest
      vsync: this,
    );

    _tabs.add(
      CustomTab(
        name: 'Top',
        func: ({cursor}) => _func('top', cursor),
      ),
    );

    _tabs.add(
      CustomTab(
        name: 'Latest',
        func: ({cursor}) => _func('latest', cursor),
      ),
    );

    setState(() {
      _loading = false;
    });
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
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text('#${widget.name}'),
              primary: true,
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              bottom: !_loading
                  ? TabBar(
                      tabs: _handleTabs(),
                      controller: _tabController,
                      isScrollable: true,
                    )
                  : null,
            ),
          ];
        },
        body: !_loading
            ? MultipleFeeds(
                tabController: _tabController,
                scrollController: _scrollController,
                tabs: _tabs,
              )
            : const Center(
                child: CircularProgressIndicator(),
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