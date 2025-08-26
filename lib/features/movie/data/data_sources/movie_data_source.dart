import 'package:flutter_movlix/features/movie/data/dtos/movie_detail_dto.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';

abstract interface class MovieDataSource {
  Future<MovieResponseDto?> fetchNowPlayingMovies({int page});
  Future<MovieResponseDto?> fetchPopularMovies({int page});
  Future<MovieResponseDto?> fetchTopRatedMovies({int page});
  Future<MovieResponseDto?> fetchUpcomingMovies({int page});
  Future<MovieResponseDto?> searchMovies(String query);
  Future<MovieDetailDto?> fetchMovieDetail(int id);
}
