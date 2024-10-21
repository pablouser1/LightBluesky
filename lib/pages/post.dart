import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.id});

  final String id;

  @override
  State<PostPage> createState() => _PostPageState();
}

/// TODO: Implement individual post page
class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Post'),
      ),
    );
  }
}