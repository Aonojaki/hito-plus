import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/calendar_screen.dart';
import '../features/ai_chat/ai_chat_screen.dart';
import '../features/notebook/notebook_screen.dart';
import '../features/planner/planner_screen.dart';
import '../features/scrapper/scrapper_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/vision_board/vision_board_screen.dart';
import 'app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/calendar',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/calendar'),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/notebook',
            builder: (context, state) => const NotebookScreen(),
          ),
          GoRoute(
            path: '/vision-board',
            builder: (context, state) => const VisionBoardScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const PlannerScreen(),
          ),
          GoRoute(
            path: '/scrapper',
            builder: (context, state) => const ScrapperScreen(),
          ),
          GoRoute(
            path: '/ai-chat',
            builder: (context, state) => const AiChatScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
