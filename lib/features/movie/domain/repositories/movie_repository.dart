import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie_detail.dart';

abstract interface class MovieRepository {
  Future<List<Movie>?> fetchNowPlayingMovies();
  Future<List<Movie>?> fetchPopularMovies();
  Future<List<Movie>?> fetchTopRatedMovies();
  Future<List<Movie>?> fetchUpcomingMovies();
  Future<List<Movie>?> fetchMorePopularMovies(int page);
  Future<MovieDetail?> fetchMovieDetail(int id);
}
