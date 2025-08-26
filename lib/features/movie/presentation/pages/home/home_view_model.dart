import 'package:flutter_movlix/features/movie/domain/usecases/fetch_more_popular_movies_usecase.dart';
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
    initialize();

    return HomeState(
      nowPlayingMovies: null,
      popularMovies: null,
      topRatedMovies: null,
      upComingMovies: null,
    );
  }

  Future<void> initialize() async {
    await Future.wait([
      fetchNowPlayingMovies(),
      fetchPopularMovies(),
      fetchTopRatedMovies(),
      fetchUpcomingMovies(),
    ]);
  }

  Future<void> fetchNowPlayingMovies() async {
    final fetchNowPlayingMoviesUsecase = ref.read(fetchNowPlayingMoviesUsecaseProvider);
    final result = await fetchNowPlayingMoviesUsecase.execute();
    state = HomeState(
      nowPlayingMovies: result,
      popularMovies: state.popularMovies,
      topRatedMovies: state.topRatedMovies,
      upComingMovies: state.upComingMovies,
    );
  }

  Future<void> fetchPopularMovies() async {
    final fetchPopularMoviesUsecase = ref.read(fetchPopularMoviesUsecaseProvider);
    final result = await fetchPopularMoviesUsecase.execute();
    state = HomeState(
      nowPlayingMovies: state.nowPlayingMovies,
      popularMovies: result,
      topRatedMovies: state.topRatedMovies,
      upComingMovies: state.upComingMovies,
    );
  }

  Future<void> fetchTopRatedMovies() async {
    final fetchTopRatedMoviesUsecase = ref.read(fetchTopRatedMoviesUsecaseProvider);
    final result = await fetchTopRatedMoviesUsecase.execute();
    state = HomeState(
      nowPlayingMovies: state.nowPlayingMovies,
      popularMovies: state.popularMovies,
      topRatedMovies: result,
      upComingMovies: state.upComingMovies,
    );
  }

  Future<void> fetchUpcomingMovies() async {
    final fetchUpcomingMoviesUsecase = ref.read(fetchUpcomingMoviesUsecaseProvider);
    final result = await fetchUpcomingMoviesUsecase.execute();
    state = HomeState(
      nowPlayingMovies: state.nowPlayingMovies,
      popularMovies: state.popularMovies,
      topRatedMovies: state.topRatedMovies,
      upComingMovies: result,
    );
  }

  Future<void> fetchMoreMovies() async {
    final fetchMorePopularMoviesUsecase = ref.read(fetchMorePopularMoviesUsecaseProvider);
    final result = await fetchMorePopularMoviesUsecase.execute(state.popularMovies!.length ~/ 20 + 1);
    state = HomeState(
      nowPlayingMovies: state.nowPlayingMovies,
      popularMovies: state.popularMovies!..addAll(result ?? []),
      topRatedMovies: state.topRatedMovies,
      upComingMovies: state.upComingMovies,
    );
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
