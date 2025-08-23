import 'package:flutter_movlix/features/movie/data/dtos/movie_detail_dto.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';

abstract interface class MovieDataSource {
  Future<MovieResponseDto?> fetchNowPlayingMovies();
  Future<MovieResponseDto?> fetchPopularMovies();
  Future<MovieResponseDto?> fetchTopRatedMovies();
  Future<MovieResponseDto?> fetchUpcomingMovies();
  Future<MovieDetailDto?> fetchMovieDetail(int id);
}
