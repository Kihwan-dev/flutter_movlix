import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/domain/repositories/movie_repository.dart';

class FetchMorePopularMoviesUsecase {
  FetchMorePopularMoviesUsecase(this._movieRepository);
  final MovieRepository _movieRepository;
  Future<List<Movie>?> execute(int page) async {
    return await _movieRepository.fetchMorePopularMovies(page);
  }
}
