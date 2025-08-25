import 'package:flutter_movlix/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movlix/features/movie/domain/repositories/movie_repository.dart';

class FetchMovieDetailUsecase {
  FetchMovieDetailUsecase(this._movieRepository);
  final MovieRepository _movieRepository;
  Future<MovieDetail?> execute(int id) async {
    return await _movieRepository.fetchMovieDetail(id);
  }
}
