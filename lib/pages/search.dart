import 'package:bluesky/bluesky.dart' as bsky;
import 'package:bluesky/core.dart';
import 'package:flutter/material.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/helpers/debouncer.dart';
import 'package:lightbluesky/helpers/ui.dart';
import 'package:lightbluesky/partials/actor.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';

/// Search page, for now only for users
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _debouncer = Debouncer(milliseconds: 500);
  bool _isLoading = false;

  List<bsky.ActorBasic> actors = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _makeSearch(String term) async {
    if (term.isEmpty) {
      if (actors.isNotEmpty) {
        setState(() {
          actors = [];
        });
      }
      return;
    }

    try {
      _debouncer.run(() async {
        setState(() {
          _isLoading = true;
        });

        final res = await api.c.actor.searchActorsTypeahead(term: term);

        setState(() {
          _isLoading = false;
          actors = res.data.actors;
        });
      });
    } on XRPCException catch (e) {
      if (!mounted) return;
      Ui.snackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(locale.search_title),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              autofocus: true,
              onChanged: (val) => _makeSearch(val),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: locale.search_title,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: actors.length,
              itemBuilder: (context, i) {
                return Actor(actor: actors[i]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
