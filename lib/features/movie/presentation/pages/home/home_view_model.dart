import 'package:flutter_movlix/features/movie/presentation/pages/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';

class HomeState {
  HomeState({
    this.nowPlayingMovies,
    this.popularMovies,
    this.topRatedMovies,
    this.upComingMovies,
    this.searchQuery = '',
    this.searchResults,
    this.isSearchMode = false,
    this.isSearching = false,
  });

  final List<Movie>? nowPlayingMovies;
  final List<Movie>? popularMovies;
  final List<Movie>? topRatedMovies;
  final List<Movie>? upComingMovies;
  final String searchQuery;
  final List<Movie>? searchResults;
  final bool isSearchMode;
  final bool isSearching;

  HomeState copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upComingMovies,
    String? searchQuery,
    List<Movie>? searchResults,
    bool? isSearchMode,
    bool? isSearching,
  }) {
    return HomeState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upComingMovies: upComingMovies ?? this.upComingMovies,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      isSearching: isSearching ?? this.isSearching,
    );
  }
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
      searchQuery: '',
      searchResults: null,
      isSearchMode: false,
      isSearching: false,
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
      isSearching: false,
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
      isSearching: false,
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
      isSearching: false,
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
      isSearching: false,
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
      isSearching: false,
      nowPlayingMovies: state.nowPlayingMovies,
      popularMovies: state.popularMovies!..addAll(result ?? []),
      topRatedMovies: state.topRatedMovies,
      upComingMovies: state.upComingMovies,
    );
  }

  // 검색 실행 (디바운서 후 실행)
  Future<void> searchMovies(String query) async {
    // 이미 검색 모드이므로 isSearching만 변경
    state = state.copyWith(isSearching: true);

    try {
      final searchMoviesUsecase = ref.read(searchMoviesUsecaseProvider);
      final results = await searchMoviesUsecase.execute(query);
      state = state.copyWith(
        searchResults: results,
        isSearching: false,
      );
    } catch (e) {
      state = state.copyWith(
        searchResults: [],
        isSearching: false,
      );
    }
  }

  // 검색 모드 해제
  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      searchResults: null,
      isSearchMode: false,
      isSearching: false,
    );
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
