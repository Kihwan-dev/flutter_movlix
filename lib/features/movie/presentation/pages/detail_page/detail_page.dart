import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/detail_page/detial_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;
  final String tagHeader;

  const DetailPage({
    required this.movie,
    required this.tagHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Hero(
                  tag: "${tagHeader}_${movie.id}",
                  child: CachedNetworkImage(
                    imageUrl: movie.posterPath,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Consumer(builder: (context, ref, child) {
                  final state = ref.watch(detailViewModelProvider(movie));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state == null ? "" : state.title,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(state == null ? "" : DateFormat("yyyy-MM-dd").format(state.releaseDate)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(state == null ? "" : state.tagline),
                      Text(state == null ? "" : "${state.runtime}분"),
                      Divider(height: 20, thickness: 2),
                      Container(
                        height: 40,
                        child: state == null
                            ? Container()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.genres.length,
                                separatorBuilder: (context, index) => SizedBox(width: 4),
                                itemBuilder: (context, index) {
                                  final genre = state.genres[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[500]!), borderRadius: BorderRadius.circular(50)),
                                    child: Text(
                                      genre,
                                      style: TextStyle(color: Colors.blueAccent),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Divider(height: 20, thickness: 2),
                      Text(state == null ? "" : state.overview),
                      Divider(height: 20, thickness: 2),
                      Text("흥행정보"),
                      SizedBox(height: 16),
                      Container(
                        height: 70,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: state == null
                              ? Container()
                              : Row(
                                  children: [
                                    _buildMovieStats(title: "평점", value: "${state.voteAverage}"),
                                    SizedBox(width: 8),
                                    _buildMovieStats(title: "평점투표수", value: "${state.voteCount}"),
                                    SizedBox(width: 8),
                                    _buildMovieStats(title: "인기점수", value: "${state.popularity}"),
                                    SizedBox(width: 8),
                                    _buildMovieStats(title: "예산", value: "\$${state.budget}"),
                                    SizedBox(width: 8),
                                    _buildMovieStats(title: "수익", value: "\$${state.revenue}"),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 100,
                        child: state == null
                            ? Container()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.productionCompanyLogos.length,
                                separatorBuilder: (context, index) => SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final logoPath = state.productionCompanyLogos[index];
                                  return logoPath == null
                                      ? Container()
                                      : Container(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          child: CachedNetworkImage(
                                            imageUrl: logoPath,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        );
                                },
                              ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildMovieStats({
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[600]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value),
          Text(title),
        ],
      ),
    );
  }
}
