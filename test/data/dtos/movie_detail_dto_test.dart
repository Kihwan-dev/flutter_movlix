import 'dart:convert';

import 'package:flutter_movlix/features/movie/data/dtos/movie_detail_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'MovieResponseDto : fromJson test',
    () {
      final sampleJsonString = """
        {
  "adult": false,
  "backdrop_path": "/xGu5jTd34DjXGwS7JLmDbgvIQ1U.jpg",
  "belongs_to_collection": null,
  "budget": 0,
  "genres": [
    {
      "id": 878,
      "name": "SF"
    }
  ],
  "homepage": "",
  "id": 755898,
  "imdb_id": "tt13186306",
  "origin_country": [
    "US"
  ],
  "original_language": "en",
  "original_title": "War of the Worlds",
  "overview": "전설적인 동명 소설을 새롭게 재해석한 이번 작품은 거대한 침공의 서막을 알린다. 에바 롱고리아와 전설적인 래퍼이자 배우 아이스 큐브, 그리고 마이클 오닐과 이만 벤슨이 합류해, 기술과 감시, 사생활이라는 현대적 주제를 아우르는 짜릿한 우주급 모험을 선보인다.",
  "popularity": 1176.1496,
  "poster_path": "/yvirUYrva23IudARHn3mMGVxWqM.jpg",
  "production_companies": [
    {
      "id": 33,
      "logo_path": "/8lvHyhjr8oUKOOy2dKXoALWKdp0.png",
      "name": "Universal Pictures",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "release_date": "2025-07-29",
  "revenue": 0,
  "runtime": 145,
  "spoken_languages": [
    {
      "english_name": "English",
      "iso_639_1": "en",
      "name": "English"
    }
  ],
  "status": "Released",
  "tagline": "",
  "title": "우주전쟁",
  "video": false,
  "vote_average": 4.3,
  "vote_count": 392
}
      """;

      final map = jsonDecode(sampleJsonString);
      final movieDetailDto = MovieDetailDto.fromJson(map);
      expect(movieDetailDto.budget, 0);
      expect(movieDetailDto.genres.length, 1);
      expect(movieDetailDto.id, 755898);
      expect(movieDetailDto.releaseDate, DateTime(2025, 7, 29));
      expect(movieDetailDto.title, "우주전쟁");
      expect(movieDetailDto.voteAverage, 4.3);
    },
  );
}
