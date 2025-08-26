# Flutter 클린 아키텍처 구현 - 데이터 계층부터 상태 관리까지

## 4. 데이터 소스 구현 - 중복 제거와 안정성 향상

영화 정보를 가져오는 데이터 소스 계층을 구현했다. 여기서 중요한 것은 **중복 코드 제거**와 **null 안전성**이다.

```dart
class MovieDataSourceImpl implements MovieDataSource {
  // 공통 fetch 메서드로 중복 제거
  Future<MovieResponseDto?> fetch(String endpoint, {int? page}) async {
    final queryParameters = <String, dynamic>{
      'language': 'ko-KR',  // 한국어 고정
      'page': page ?? 1,    // 페이지 기본값 1
    };
    
    final response = await DioClient.client.get(endpoint, queryParameters: queryParameters);
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies({int? page}) async {
    return fetch(ApiEndpoints.nowPlaying, page: page);
  }
  
  // 다른 메서드들도 동일한 패턴...
}
```

**핵심 포인트:**
- **공통 fetch 메서드**: 4개의 fetch 메서드가 동일한 로직을 공유
- **언어 설정**: `language=ko-KR`로 한국어 영화 정보 요청
- **페이지네이션**: 선택적 page 파라미터로 무한 스크롤 대비

**DTO 개선사항:**
```dart
class Result {
  // enum에서 String으로 변경하여 유연성 향상
  String originalLanguage;  // 이전: OriginalLanguage enum
  
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    // null 안전성 확보
    originalLanguage: json["original_language"] ?? "",
    // 다른 필드들도 null 체크...
  );
}
```

---

## 5. 리포지토리 구현 - DTO를 Entity로 변환

데이터 소스에서 받은 DTO를 도메인 Entity로 변환하는 리포지토리 계층이다.

```dart
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._movieDataSource);
  final MovieDataSource _movieDataSource;

  // DTO를 Entity로 변환하는 공통 메서드
  List<Movie>? getMovies(MovieResponseDto result) {
    return result.results
        .map((e) => Movie(
          id: e.id, 
          // TMDB 이미지 URL 완성
          posterPath: "https://image.tmdb.org/t/p/original${e.posterPath}"
        ))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchNowPlayingMovies({int? page}) async {
    final result = await _movieDataSource.fetchNowPlayingMovies(page: page);
    if (result == null) return [];  // null 안전성
    return getMovies(result);
  }
}
```

**설계 결정사항:**
- **Movie 엔티티 단순화**: `id`와 `posterPath`만 포함
- **이미지 URL 완성**: 상대 경로를 절대 URL로 변환
- **별도 리포지토리 불필요**: MovieDetail은 Movie와 함께 관리

---

## 6. 테스트 코드 작성 - 실제 API 연동 테스트

테스트 코드 작성 시 **mocking 없이 실제 API를 호출**하는 방식을 선택했다.

```dart
void main() {
  setUpAll(() async {
    // 테스트 환경에서 dotenv 로드
    await dotenv.load(fileName: "assets/config/.env");
  });

  group('MovieDataSourceImpl Tests', () {
    test('fetchNowPlayingMovies returns valid data', () async {
      final dataSource = MovieDataSourceImpl();
      final result = await dataSource.fetchNowPlayingMovies();
      
      expect(result, isNotNull);
      expect(result!.results, isNotEmpty);
      expect(result.results.first.id, isPositive);
    });
  });
}
```

**테스트 환경 설정:**
- **dotenv 로드**: `setUpAll`에서 환경변수 설정
- **실제 API 호출**: TMDB API와 직접 통신
- **데이터 검증**: 응답 구조와 데이터 타입 확인

**장점:**
- 실제 API 동작 확인 가능
- 네트워크 설정 검증
- 실제 데이터 구조 학습

---

## 7. Riverpod 프로바이더 구성 - 의존성 주입 최적화

Riverpod을 사용한 의존성 주입 시스템을 구성했다.

```dart
// providers.dart
final _movieDataSourceProvider = Provider<MovieDataSource>((ref) => MovieDataSourceImpl());

final _movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dataSource = ref.read(_movieDataSourceProvider);
  return MovieRepositoryImpl(dataSource);
});

// UseCase 프로바이더들
final fetchNowPlayingMoviesUsecaseProvider = Provider((ref) {
  final movieRepo = ref.read(_movieRepositoryProvider);
  return FetchNowPlayingMoviesUsecase(movieRepo);
});

// 다른 UseCase들도 동일한 패턴...
```

**중복 제거 전략:**
- **공통 변수**: `movieRepo` 변수로 중복 제거
- **일관된 패턴**: 모든 UseCase가 동일한 구조
- **의존성 체인**: DataSource → Repository → UseCase 순서

---

## 8. HomeViewModel 상태 관리 - 현재 구현된 방식

HomeViewModel에서 **상태 관리**를 구현했다.

```dart
class HomeState {
  HomeState({
    this.nowPlayingMovies,
    this.popularMovies,
    this.topRatedMovies,
    this.upComingMovies,
  });

  List<Movie>? nowPlayingMovies;
  List<Movie>? popularMovies;
  List<Movie>? topRatedMovies;
  List<Movie>? upComingMovies;
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    fetchNowPlayingMovies();
    fetchPopularMovies();
    fetchTopRatedMovies();
    fetchUpcomingMovies();

    return HomeState(
      nowPlayingMovies: null,
      popularMovies: null,
      topRatedMovies: null,
      upComingMovies: null,
    );
  }

  Future<void> fetchNowPlayingMovies() async {
    final fetchNowPlayingMoviesUsecase = ref.read(fetchNowPlayingMoviesUsecaseProvider);
    final result = await fetchNowPlayingMoviesUsecase.execute();
    state = HomeState(
      nowPlayingMovies: result,
      popularMovies: state.popularMovies,
      topRatedMovies: state.topRatedMovies,
      upComingMovies: state.upComingMovies,
    );
  }

  Future<void> fetchPopularMovies() async {
    final fetchPopularMoviesUsecase = ref.read(fetchPopularMoviesUsecaseProvider);
    final result = await fetchPopularMoviesUsecase.execute();
    state = HomeState(
      nowPlayingMovies: state.nowPlayingMovies,
      popularMovies: result,
      topRatedMovies: state.topRatedMovies,
      upComingMovies: state.upComingMovies,
    );
  }

  // 다른 fetch 메서드들도 동일한 패턴...
}
```

**현재 구현 특징:**
- **상태 초기화**: 모든 영화 리스트를 `null`로 초기화
- **동시 fetch**: `build()` 메서드에서 모든 데이터를 동시에 로드
- **상태 업데이트**: 각 fetch 메서드에서 새로운 `HomeState` 객체 생성
- **기존 상태 유지**: 다른 영화 리스트는 기존 상태 유지

**Provider 정의:**
```dart
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
```

이 과정을 통해 Flutter의 클린 아키텍처 패턴을 실제 프로젝트에 적용하고, **상태 관리**, **의존성 주입**, **테스트 코드** 등 다양한 개발 패턴을 실무에 적용할 수 있었다! 🚀
