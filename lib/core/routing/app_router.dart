import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/bible/book_list_screen.dart';
import '../../features/bible/chapter_grid_screen.dart';
import '../../features/bible/verse_list_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/notes/notes_library_screen.dart';
import '../../features/quiz/quiz_results_screen.dart';
import '../../features/quiz/quiz_scope_screen.dart';
import '../../features/quiz/quiz_session_screen.dart';
import '../../features/quiz/quiz_type_screen.dart';
import '../../features/settings/account_sync_screen.dart';
import '../../features/settings/notification_preview_screen.dart';
import '../../features/settings/ai_providers_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/talks/talk_detail_screen.dart';
import '../../features/talks/talk_list_screen.dart';
import '../../shared/widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/bible',
            builder: (c, s) => const BookListScreen(),
            routes: [
              GoRoute(
                path: 'book/:bookId',
                builder: (c, s) => ChapterGridScreen(
                  bookId: int.parse(s.pathParameters['bookId']!),
                ),
                routes: [
                  GoRoute(
                    path: 'chapter/:chapter',
                    builder: (c, s) => VerseListScreen(
                      bookId: int.parse(s.pathParameters['bookId']!),
                      chapter: int.parse(s.pathParameters['chapter']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/notes', builder: (c, s) => const NotesLibraryScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/quiz',
            builder: (c, s) => const QuizScopeScreen(),
            routes: [
              GoRoute(path: 'type', builder: (c, s) => const QuizTypeScreen()),
              GoRoute(path: 'session', builder: (c, s) => const QuizSessionScreen()),
              GoRoute(path: 'results', builder: (c, s) => const QuizResultsScreen()),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/talks',
            builder: (c, s) => const TalkListScreen(),
            routes: [
              GoRoute(
                path: ':talkId',
                builder: (c, s) =>
                    TalkDetailScreen(talkId: s.pathParameters['talkId']!),
              ),
            ],
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'ai-providers',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (c, s) => const AiProvidersScreen(),
        ),
        GoRoute(
          path: 'account',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (c, s) => const AccountSyncScreen(),
        ),
        GoRoute(
          path: 'previews',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (c, s) => const NotificationPreviewScreen(),
        ),
      ],
    ),
  ],
);
