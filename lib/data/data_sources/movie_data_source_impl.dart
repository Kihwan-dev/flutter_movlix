import 'package:flutter_movlix/data/data_sources/movie_data_source.dart';
import 'package:flutter_movlix/data/dtos/movie_detail_dto.dart';
import 'package:flutter_movlix/data/dtos/movie_response_dto.dart';

class MovieDataSourceImpl implements MovieDataSource {
  @override
  Future<MovieDetailDto?> fetchMovieDetail(int id) {
    // TODO: implement fetchMovieDetail
    throw UnimplementedError();
  }

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() {
    // TODO: implement fetchNowPlayingMovies
    throw UnimplementedError();
  }

  @override
  Future<MovieResponseDto?> fetchPopularMovies() {
    // TODO: implement fetchPopularMovies
    throw UnimplementedError();
  }

  @override
  Future<MovieResponseDto?> fetchTopRatedMovies() {
    // TODO: implement fetchTopRatedMovies
    throw UnimplementedError();
  }

  @override
  Future<MovieResponseDto?> fetchUpcomingMovies() {
    // TODO: implement fetchUpcomingMovies
    throw UnimplementedError();
  }
}
