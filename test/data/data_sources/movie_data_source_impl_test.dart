import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movlix/features/movie/data/data_sources/movie_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MovieDataSourceImpl? movieDataSourceImpl;

  setUp(
    () async {
      await dotenv.load(fileName: "assets/config/.env");
      movieDataSourceImpl = MovieDataSourceImpl();
    },
  );

  test(
    "MovieDataSourceImpl : fetch test",
    () async {
      final result = await movieDataSourceImpl!.fetchNowPlayingMovies();
      if (result != null) {
        expect(result.page, 1);
        expect(result.results.length, 20);
        final movie = result.results[0];
        expect(movie.id, 755898);
        expect(movie.releaseDate, DateTime(2025, 7, 29));
        expect(movie.title, "우주전쟁");
      }
    },
  );
}
