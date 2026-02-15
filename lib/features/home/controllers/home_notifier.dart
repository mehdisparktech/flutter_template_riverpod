import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/repositories_providers.dart';
import 'home_state.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  FutureOr<HomeState> build() {
    return _fetchMovies(page: 1);
  }

  Future<HomeState> _fetchMovies({required int page}) async {
    final repository = ref.read(movieRepositoryProvider);
    final response = await repository.getMovies(page: page);
    return HomeState(
      movies: response.movies,
      page: page,
      totalPages: response.totalPages,
    );
  }

  Future<void> setPage(int page) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMovies(page: page));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMovies(page: 1));
  }
}
