import 'package:flutter_movlix/features/movie/data/data_sources/movie_data_source.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';
import 'package:flutter_movlix/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDataSource extends Mock implements MovieDataSource {}

void main() {
  MockMovieDataSource? mockMovieDataSource;
  MovieRepositoryImpl? movieRepositoryImpl;

  setUp(
    () {
      mockMovieDataSource = MockMovieDataSource();
      movieRepositoryImpl = MovieRepositoryImpl(mockMovieDataSource!);
    },
  );

  test(
    "MovieRepositoryImpl test : fetchNowPlayingMovies",
    () async {
      when(() => mockMovieDataSource!.fetchNowPlayingMovies()).thenAnswer(
        (invocation) async => MovieResponseDto(
          page: 1,
          results: [
            Result(
              adult: true,
              backdropPath: "backdropPath",
              genreIds: [],
              id: 123,
              originalLanguage: "originalLanguage",
              originalTitle: "originalTitle",
              overview: "overview",
              popularity: 0.1,
              posterPath: "posterPath",
              releaseDate: DateTime.now(),
              title: "title",
              video: false,
              voteAverage: 0.2,
              voteCount: 111,
            ),
          ],
          totalPages: 2,
          totalResults: 3,
        ),
      );

      final result = await movieRepositoryImpl!.fetchNowPlayingMovies();
      expect(result == null, false);
      expect(result!.length, 1);
      expect(result[0].id, 123);
    },
  );
}
