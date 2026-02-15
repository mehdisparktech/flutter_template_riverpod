import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/movie/movie.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default([]) List<Movie> movies,
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(false) bool isLoadingMore,
  }) = _HomeState;
}
