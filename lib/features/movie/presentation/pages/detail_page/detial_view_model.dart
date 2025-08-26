import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailViewModel extends AutoDisposeFamilyNotifier<MovieDetail?, Movie> {
  @override
  MovieDetail? build(Movie arg) {
    fetchMovieDetail();
    return null;
  }

  Future<void> fetchMovieDetail() async {
    final fetchMovieDetailUsecase = ref.read(fetchMovieDetailUsecaseProvider);
    final result = await fetchMovieDetailUsecase.execute(arg.id);
    state = result;
  }
}

final detailViewModelProvider = NotifierProvider.autoDispose.family<DetailViewModel, MovieDetail?, Movie>(
  () => DetailViewModel(),
);
