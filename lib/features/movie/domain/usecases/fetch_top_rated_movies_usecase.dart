import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/domain/repositories/movie_repository.dart';

class FetchTopRatedMoviesUsecase {
  FetchTopRatedMoviesUsecase(this._movieRepository);
  final MovieRepository _movieRepository;
  Future<List<Movie>?> execute() async {
    return await _movieRepository.fetchTopRatedMovies();
  }
}
