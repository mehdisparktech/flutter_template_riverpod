import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/detail/pages/detail_page.dart';
import '../features/home/pages/home_page.dart';
import '../models/detail_page_args.dart';
import '../models/movie/movie.dart';
import '../utils/not_found_page.dart';
import 'route_names.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => HomePage(
          key: state.pageKey,
        ),
        routes: [
          GoRoute(
            path: '${RoutePaths.detail}/:id',
            name: RouteNames.detail,
            builder: (context, state) {
              final movie = state.extra as Movie?;
              final id = state.pathParameters['id']; // Updated from params

              // Ensure id is not null if needed, or handle it

              return DetailPage(
                args: DetailPageArgs(
                  id: id ??
                      '', // fallback if null, though routing usually guarantees it present
                  movie: movie,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
});
