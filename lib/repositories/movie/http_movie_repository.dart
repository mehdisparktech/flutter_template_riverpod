import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/movie/movie.dart';
import '../../models/movie_response/movie_response.dart';
import '../../services/api/movie_client.dart';
import 'movie_repository.dart';

class HttpMovieRepository implements MovieRepository {
  final MovieClient api;
  final String locale;

  HttpMovieRepository({
    required this.api,
    required this.locale,
  });

  @override
  Future<MovieResponse> getMovies({int page = 1}) => api.getMovies(
        language: locale,
        page: page,
        token: dotenv.env['TMDB_TOKEN'] ?? '',
      );

  @override
  Future<Movie> getMovie(String id) => api.getMovie(
        id,
        token: dotenv.env['TMDB_TOKEN'] ?? '',
      );
}
