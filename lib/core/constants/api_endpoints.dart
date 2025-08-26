class ApiEndpoints {
  static const nowPlaying = "movie/now_playing";
  static const popular = "movie/popular";
  static const topRated = "movie/top_rated";
  static const upcoming = "movie/upcoming";
  static const search = "search/movie";

  static String detail(int id) => "$id";
}
