import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkConfig {
  //
  static String get tbmdApiKey => dotenv.env["TMDB_API_KEY"] ?? "";
  static String get tmdbBaseUrl => dotenv.env["TMDB_BASE_URL"] ?? "https://api.themoviedb.org/3/movie/";
  static String get tmdbImgBaseUrl => dotenv.env["TMDB_IMG_BASE_URL"] ?? "https://image.tmdb.org/t/p/w200";
}
