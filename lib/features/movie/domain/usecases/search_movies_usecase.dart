import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/domain/repositories/movie_repository.dart';

class SearchMoviesUsecase {
  SearchMoviesUsecase(this._movieRepository);
  final MovieRepository _movieRepository;
  Future<List<Movie>?> execute(String query) async {
    return await _movieRepository.searchMovies(query);
  }
}
