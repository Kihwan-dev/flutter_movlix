import 'package:flutter_movlix/features/movie/domain/usecases/fetch_now_playing_movies_usecase.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';

class HomeState {
  HomeState({
    this.nowPlayingMovies,
    this.popularMovies,
    this.topRatedMovies,
    this.upComingMovies,
  });

  List<Movie>? nowPlayingMovies;
  List<Movie>? popularMovies;
  List<Movie>? topRatedMovies;
  List<Movie>? upComingMovies;
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    return HomeState(
      nowPlayingMovies: null,
      popularMovies: null,
      topRatedMovies: null,
      upComingMovies: null,
    );
  }

  Future<void> fetchNowPlayingMovies() async {
    final fetchNowPlayingMoviesUsecase = ref.read(fetchNowPlayingMoviesUsecaseProvider);
    final result = await fetchNowPlayingMoviesUsecase.execute();
    state = HomeState(nowPlayingMovies: result);
  }

  Future<void> fetchPopularMovies() async {
    final fetchPopularMoviesUsecase = ref.read(fetchPopularMoviesUsecaseProvider);
    final result = await fetchPopularMoviesUsecase.execute();
    state = HomeState(nowPlayingMovies: result);
  }

  Future<void> fetchTopRatedMovies() async {
    final fetchTopRatedMoviesUsecase = ref.read(fetchTopRatedMoviesUsecaseProvider);
    final result = await fetchTopRatedMoviesUsecase.execute();
    state = HomeState(nowPlayingMovies: result);
  }

  Future<void> fetchUpcomingMovies() async {
    final fetchUpcomingMoviesUsecase = ref.read(fetchUpcomingMoviesUsecaseProvider);
    final result = await fetchUpcomingMoviesUsecase.execute();
    state = HomeState(nowPlayingMovies: result);
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
