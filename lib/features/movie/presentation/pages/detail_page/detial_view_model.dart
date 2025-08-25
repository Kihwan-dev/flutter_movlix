import 'package:flutter_movlix/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailViewModel extends Notifier<MovieDetail?> {
  @override
  MovieDetail? build() {
    return null;
  }

  Future<void> fetchMovieDetail(int id) async {
    final fetchMovieDetailUsecase = ref.read(fetchMovieDetailUsecaseProvider);
    final result = await fetchMovieDetailUsecase.execute(id);
    state = result;
  }
}

final detailViewModelProvider = NotifierProvider<DetailViewModel, MovieDetail?>(
  () => DetailViewModel(),
);
