import 'package:flutter_movlix/features/movie/data/data_sources/movie_data_source.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movlix/features/movie/domain/repositories/movie_repository.dart';

/// dto -> entity로 변환하는 구현체

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._movieDataSource);

  final MovieDataSource _movieDataSource;

  List<Movie>? getMovies(MovieResponseDto result) {
    return result.results
        .map(
          (e) => Movie(id: e.id, posterPath: "https://image.tmdb.org/t/p/original${e.posterPath}"),
        )
        .toList();
  }

  @override
  Future<List<Movie>?> fetchNowPlayingMovies() async {
    final result = await _movieDataSource.fetchNowPlayingMovies();
    if (result == null) return [];
    return getMovies(result);
  }

  @override
  Future<List<Movie>?> fetchPopularMovies() async {
    final result = await _movieDataSource.fetchPopularMovies();
    if (result == null) return [];
    return getMovies(result);
  }

  @override
  Future<List<Movie>?> fetchTopRatedMovies() async {
    final result = await _movieDataSource.fetchTopRatedMovies();
    if (result == null) return [];
    return getMovies(result);
  }

  @override
  Future<List<Movie>?> fetchUpcomingMovies() async {
    final result = await _movieDataSource.fetchUpcomingMovies();
    if (result == null) return [];
    return getMovies(result);
  }

  @override
  Future<MovieDetail?> fetchMovieDetail(int id) async {
    final result = await _movieDataSource.fetchMovieDetail(id);
    if (result == null) return null;
    return MovieDetail(
      budget: result.budget,
      genres: List.from(result.genres.map((e) => e.name)),
      id: id,
      productionCompanyLogos:
          List.from(result.productionCompanies.map((e) => e.logoPath == null ? null : "https://image.tmdb.org/t/p/original${e.logoPath}")),
      overview: result.overview,
      popularity: result.popularity,
      releaseDate: result.releaseDate,
      revenue: result.revenue,
      runtime: result.runtime,
      tagline: result.tagline,
      title: result.title,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
    );
  }
}
