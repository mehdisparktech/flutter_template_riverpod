import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../constants/endpoints.dart';
import '../../models/movie/movie.dart';
import '../../models/movie_response/movie_response.dart';

part 'movie_client.g.dart';

@RestApi(baseUrl: AppEndpoints.movieDbBase)
abstract class MovieClient {
  factory MovieClient(Dio dio, {String baseUrl}) = _MovieClient;

  @GET('movie/popular')
  Future<MovieResponse> getMovies({
    @Query('language') required String language,
    @Query('page') required int page,
    @Header('Authorization') required String token,
  });

  @GET('movie/{id}')
  Future<Movie> getMovie(
    @Path('id') String id, {
    @Header('Authorization') required String token,
  });
}
