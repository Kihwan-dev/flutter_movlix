import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_movlix/core/constants/api_endpoints.dart';
import 'package:flutter_movlix/features/movie/data/data_sources/movie_data_source.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_detail_dto.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';
import 'package:flutter_movlix/infrastructure/network/dio_client.dart';

class MovieDataSourceImpl implements MovieDataSource {
  MovieDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;

  Future<MovieResponseDto?> fetch(String endpoint) async {
    final response = await DioClient.client.get(endpoint);
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() async {
    return fetch(ApiEndpoints.nowPlaying);
  }

  @override
  Future<MovieResponseDto?> fetchPopularMovies() async {
    return fetch(ApiEndpoints.popular);
  }

  @override
  Future<MovieResponseDto?> fetchTopRatedMovies() async {
    return fetch(ApiEndpoints.topRated);
  }

  @override
  Future<MovieResponseDto?> fetchUpcomingMovies() async {
    return fetch(ApiEndpoints.upcoming);
  }

  @override
  Future<MovieDetailDto?> fetchMovieDetail(int id) async {
    final response = await DioClient.client.get(ApiEndpoints.detail(id));
    final json = jsonDecode(response.toString());
    return MovieDetailDto.fromJson(json);
  }
}
