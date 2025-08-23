import 'dart:convert';

import 'package:flutter_movlix/features/movie/data/dtos/movie_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'MovieResponseDto : fromJson test',
    () {
      final sampleJsonString = """
        {
          "dates": {
            "maximum": "2025-08-27", 
            "minimum": "2025-07-16"
          },
          "page": 1,
          "results": [
            {
              "adult": false,
              "backdrop_path": "/xGu5jTd34DjXGwS7JLmDbgvIQ1U.jpg",
              "genre_ids": [878, 53],
              "id": 755898,
              "original_language": "en",
              "original_title": "War of the Worlds",
              "overview":
                  "전설적인 동명 소설을 새롭게 재해석한 이번 작품은 거대한 침공의 서막을 알린다. 에바 롱고리아와 전설적인 래퍼이자 배우 아이스 큐브, 그리고 마이클 오닐과 이만 벤슨이 합류해, 기술과 감시, 사생활이라는 현대적 주제를 아우르는 짜릿한 우주급 모험을 선보인다.",
              "popularity": 1176.1496,
              "poster_path": "/yvirUYrva23IudARHn3mMGVxWqM.jpg",
              "release_date": "2025-07-29",
              "title": "우주전쟁",
              "video": false,
              "vote_average": 4.3,
              "vote_count": 392
            }
          ],
          "total_pages": 205,
          "total_results": 4094
        }
      """;

      final map = jsonDecode(sampleJsonString);
      final movieResponseDto = MovieResponseDto.fromJson(map);
      expect(movieResponseDto.page, 1);
      expect(movieResponseDto.results.length, 1);
      final movie = movieResponseDto.results[0];
      expect(movie.id, 755898);
      expect(movie.releaseDate, DateTime(2025, 7, 29));
      expect(movie.title, "우주전쟁");
      expect(movie.voteAverage, 4.3);
    },
  );
}
