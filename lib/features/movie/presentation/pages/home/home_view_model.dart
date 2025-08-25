import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  List<Movie>? nowPlayingMovies;
  List<Movie>? popularMovies;
  List<Movie>? topRatedMovies;
  List<Movie>? upComingMovies;
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    return HomeState();
  }
}
