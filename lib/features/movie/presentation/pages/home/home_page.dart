import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/detail_page/detail_page.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Consumer(builder: (context, ref, child) {
              final state = ref.watch(homeViewModelProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMostPopularMovie(context: context, category: "가장 인기있는", movies: state.popularMovies),
                  SizedBox(height: 8),
                  _buildMoviesSection(category: "현재 상영중", movies: state.nowPlayingMovies),
                  SizedBox(height: 8),
                  _buildMoviesSection(category: "인기순", movies: state.popularMovies),
                  SizedBox(height: 8),
                  _buildTopRatedMoviesSection(state.topRatedMovies),
                  SizedBox(height: 8),
                  _buildMoviesSection(category: "개봉예정", movies: state.upComingMovies),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Column _buildMostPopularMovie({
    required BuildContext context,
    required String category,
    required List<Movie>? movies,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: movies == null ? Container() : _buildMovieCard(context, category, movies[0]),
        ),
      ],
    );
  }

  Column _buildTopRatedMoviesSection(List<Movie>? movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("평점 높은순"),
        SizedBox(height: 8),
        Container(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: (movies ?? []).length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 8);
            },
            itemBuilder: (context, index) {
              final size = _measureTextSize(
                "${index + 1}",
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              );
              return GestureDetector(
                child: Container(
                  width: 120 + size.width / 2,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: movies == null
                                ? Container()
                                : CachedNetworkImage(
                                    imageUrl: movies[index].posterPath,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _buildMoviesSection({
    required String category,
    required List<Movie>? movies,
  }) {
    if (movies != null) print("$category : ${movies.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category),
        SizedBox(height: 8),
        Container(
            height: 180,
            child: movies == null
                ? Container()
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildMovieCard(context, category, movies[index]),
                      );
                    },
                  )),
      ],
    );
  }

  GestureDetector _buildMovieCard(BuildContext context, String tagHeader, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              movie: movie,
              tagHeader: tagHeader,
            ),
          ),
        );
      },
      child: Hero(
        tag: "${tagHeader}_${movie.id}",
        child: CachedNetworkImage(
          imageUrl: movie.posterPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Size _measureTextSize(
    String text, {
    required TextStyle style,
    TextDirection textDirection = TextDirection.ltr,
    double maxWidth = double.infinity, // 줄바꿈 고려하려면 화면폭 등으로 지정
    int? maxLines, // 한 줄 고정이면 1
    String? ellipsis, // '…' 같이 쓰면 생략표시 고려
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      maxLines: maxLines,
      ellipsis: ellipsis,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return tp.size; // width/height 둘 다 포함
  }
}
