import 'package:bluesky/bluesky.dart' as bsky;
import 'package:bluesky/core.dart';
import 'package:flutter/material.dart';
import 'package:lightbluesky/common.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<XRPCResponse<bsky.Feed>> futureFeed;

  @override
  void initState() {
    super.initState();
    futureFeed = api.feed.getTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: FutureBuilder(
        future: futureFeed,
        builder: (BuildContext context,
            AsyncSnapshot<XRPCResponse<bsky.Feed>> snapshot) {
          if (snapshot.hasData) {
            final res = snapshot.data!;

            return ListView.builder(
              itemCount: res.data.feed.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(res.data.feed[index].post.author.handle),
                  subtitle: Text(res.data.feed[index].post.record.text),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
