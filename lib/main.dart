import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/constants/app.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';
import 'package:lightbluesky/pages/auth.dart';
import 'package:lightbluesky/pages/bookmarks.dart';
import 'package:lightbluesky/pages/feed.dart';
import 'package:lightbluesky/pages/feeds.dart';
import 'package:lightbluesky/pages/home.dart';
import 'package:lightbluesky/pages/notifications.dart';
import 'package:lightbluesky/pages/post.dart';
import 'package:lightbluesky/pages/profile.dart';
import 'package:lightbluesky/pages/search.dart';
import 'package:lightbluesky/pages/searchterm.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  VideoPlayerMediaKit.ensureInitialized(linux: true, windows: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _setupFuture;
  late final _router = GoRouter(
    redirect: (context, state) async {
      final ok = await _setupFuture;

      return ok ? null : '/login';
    },
    routes: [
      // Home
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          // Feeds
          GoRoute(
            path: 'feeds',
            builder: (context, state) => const FeedsPage(),
          ),
          // Hashtags
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          // Search
          GoRoute(
            path: 'search',
            builder: (context, state) {
              if (state.uri.queryParameters.containsKey('q')) {
                return SearchTermPage(q: state.uri.queryParameters['q']!);
              }

              return const SearchPage();
            },
          ),
          // Bookmarks
          GoRoute(
            path: 'bookmarks',
            builder: (context, state) => const BookmarksPage(),
          ),
          // Hashtag
          GoRoute(
            path: 'hashtag/:term',
            builder:
                (context, state) =>
                    SearchTermPage(q: '#${state.uri.queryParameters['term']!}'),
          ),
          // Profile root
          GoRoute(
            path: 'profile/:handle',
            builder:
                (context, state) =>
                    ProfilePage(handleOrDid: state.pathParameters['handle']!),
            routes: [
              // Post
              GoRoute(
                path: 'post/:rkey',
                builder:
                    (context, state) => PostPage(
                      handle: state.pathParameters['handle']!,
                      rkey: state.pathParameters['rkey']!,
                    ),
              ),
              // Feed generator
              GoRoute(
                path: 'feed/:rkey',
                builder:
                    (context, state) => FeedPage(
                      handle: state.pathParameters['handle']!,
                      rkey: state.pathParameters['rkey']!,
                    ),
              ),
            ],
          ),
        ],
      ),
      // Login
      GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
    ],
  );

  /// Setups preferences for later usage.
  ///
  /// Checks if user has already loggedin and sets session if its the case
  Future<bool> _setupApp() async {
    await storage.init();

    final ok = await api.init();

    if (ok) {
      await api.initPreferences();
    }

    FlutterNativeSplash.remove();

    return ok;
  }

  @override
  void initState() {
    super.initState();
    _setupFuture = _setupApp();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp.router(
          title: App.name,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: lightColorScheme ?? const ColorScheme.light(),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? const ColorScheme.dark(),
            useMaterial3: true,
          ),
          routerConfig: _router,
        );
      },
    );
  }
}
