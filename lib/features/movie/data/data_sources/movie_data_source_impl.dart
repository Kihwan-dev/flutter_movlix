import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_movlix/core/constants/api_endpoints.dart';
import 'package:flutter_movlix/features/movie/data/data_sources/movie_data_source.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_detail_dto.dart';
import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';
import 'package:flutter_movlix/infrastructure/network/dio_client.dart';

/// api data -> dto 변환 구현체

class MovieDataSourceImpl implements MovieDataSource {
  Future<MovieResponseDto?> fetch(String endpoint, {int? page}) async {
    final queryParameters = <String, dynamic>{
      'language': 'ko-KR',
      'page': page ?? 1,
    };

    final response = await DioClient.client.get(endpoint, queryParameters: queryParameters);
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies({int? page}) async {
    return fetch(ApiEndpoints.nowPlaying, page: page);
  }

  @override
  Future<MovieResponseDto?> fetchPopularMovies({int? page}) async {
    return fetch(ApiEndpoints.popular, page: page);
  }

  @override
  Future<MovieResponseDto?> fetchTopRatedMovies({int? page}) async {
    return fetch(ApiEndpoints.topRated, page: page);
  }

  @override
  Future<MovieResponseDto?> fetchUpcomingMovies({int? page}) async {
    return fetch(ApiEndpoints.upcoming, page: page);
  }

  @override
  Future<MovieDetailDto?> fetchMovieDetail(int id) async {
    final response = await DioClient.client.get(ApiEndpoints.detail(id));
    final json = jsonDecode(response.toString());
    return MovieDetailDto.fromJson(json);
  }
}
