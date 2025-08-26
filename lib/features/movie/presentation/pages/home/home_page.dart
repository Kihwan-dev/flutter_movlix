import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movlix/core/utils/debouncer.dart';
import 'package:flutter_movlix/features/movie/domain/entities/movie.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/detail_page/detail_page.dart';
import 'package:flutter_movlix/features/movie/presentation/pages/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Debouncer _searchDebouncer;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchDebouncer = Debouncer(
      duration: Duration(milliseconds: 500),
      callback: () async {
        final state = ref.watch(homeViewModelProvider);
        final viewModel = ref.read(homeViewModelProvider.notifier);
        if (state.searchQuery.isNotEmpty) {
          viewModel.searchMovies(state.searchQuery);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          controller: searchController,
          leading: Icon(Icons.search),
          onChanged: (value) {
            final viewModel = ref.read(homeViewModelProvider.notifier);

            if (value.trim().isEmpty) {
              viewModel.clearSearch();
              return;
            }

            viewModel.setSearchMode(true, value);

            _searchDebouncer.run();
          },
          trailing: [
            if (ref.watch(homeViewModelProvider).isSearchMode)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  ref.read(homeViewModelProvider.notifier).clearSearch();
                  searchController.text = "";
                },
              ),
          ],
        ),
      ),
      body: state.isSearchMode
          ? state.searchResults == null
              ? Center(
                  child: Center(child: CircularProgressIndicator()),
                )
              : state.searchResults!.isEmpty
                  ? Center(
                      child: Text("검색 결과가 없습니다."),
                    )
                  : _buildSearchScreen(state.searchResults!)
          : _buildHomeScreen(context, state),
    );
  }

  GridView _buildSearchScreen(List<Movie> movies) {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildMovieCard(context, "", movies[index]);
      },
    );
  }

  RefreshIndicator _buildHomeScreen(BuildContext context, HomeState state) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMostPopularMovie(context: context, category: "가장 인기있는", movies: state.popularMovies),
              SizedBox(height: 8),
              _buildMoviesSection(category: "현재 상영중", movies: state.nowPlayingMovies),
              SizedBox(height: 8),
              NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
                      fetchMore();
                    }
                  }
                  return false;
                },
                child: _buildPopularMoviesSection(category: "인기순", movies: state.popularMovies),
              ),
              SizedBox(height: 8),
              _buildMoviesSection(category: "평점 높은순", movies: state.topRatedMovies),
              SizedBox(height: 8),
              _buildMoviesSection(category: "개봉예정", movies: state.upComingMovies),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    final viewModel = ref.read(homeViewModelProvider.notifier);
    await viewModel.initialize();
  }

  Future<void> fetchMore() async {
    final viewModel = ref.read(homeViewModelProvider.notifier);
    await viewModel.fetchMoreMovies();
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
        Container(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: movies == null ? Container() : _buildMovieCard(context, category, movies[0]),
          ),
        ),
      ],
    );
  }

  Column _buildPopularMoviesSection({
    required String category,
    required List<Movie>? movies,
  }) {
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
                    final size = _measureTextSize(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => DetailPage(
                              movie: movie,
                              tagHeader: category,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 120 + size.width / 2,
                        child: Stack(
                          children: [
                            Positioned(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Hero(
                                    tag: "${category}_${movie.id}",
                                    child: CachedNetworkImage(
                                      imageUrl: movies[index].posterPath,
                                      fit: BoxFit.fill,
                                    ),
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
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => DetailPage(
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
          fit: BoxFit.fill,
          placeholder: (context, url) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              child: const Center(
                child: Icon(Icons.image, size: 100),
              ),
            );
          },
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
