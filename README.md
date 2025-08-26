# 🎬 Flutter Movlix

**TMDB API를 활용한 영화 정보 앱** - Flutter와 클린 아키텍처로 구현된 현대적인 모바일 애플리케이션

## ✨ 주요 기능

- 🎭 **다양한 영화 카테고리**: 현재 상영중, 인기순, 평점 높은순, 개봉예정
- 🔍 **영화 상세 정보**: 포스터, 제목, 줄거리, 장르, 러닝타임 등
- 📱 **반응형 UI**: Hero 애니메이션과 부드러운 페이지 전환
- ♻️ **무한 스크롤**: 인기순 영화 자동 로딩
- 🔄 **Pull-to-Refresh**: 최신 데이터 새로고침
- 🖼️ **이미지 캐싱**: 빠른 이미지 로딩과 메모리 효율성

## 🏗️ 아키텍처

**클린 아키텍처** 패턴을 적용하여 구현:

```
lib/
├── core/                          # 핵심 유틸리티
│   └── constants/
│       └── api_endpoints.dart     # API 엔드포인트 관리
├── infrastructure/                 # 인프라스트럭처 레이어
│   └── network/
│       ├── dio_client.dart        # HTTP 클라이언트 설정
│       └── network_config.dart    # 환경 변수 관리
├── features/                      # 기능별 모듈
│   └── movie/                     # 영화 기능
│       ├── data/                  # 데이터 레이어
│       │   ├── data_sources/      # 데이터 소스
│       │   ├── dtos/             # 데이터 전송 객체
│       │   └── repositories/      # 리포지토리 구현체
│       ├── domain/                # 도메인 레이어
│       │   ├── entities/          # 엔티티
│       │   ├── repositories/      # 리포지토리 인터페이스
│       │   └── usecases/          # 유스케이스
│       └── presentation/          # 프레젠테이션 레이어
│           ├── pages/             # 페이지
│           ├── widgets/            # 위젯
│           └── providers.dart      # Riverpod 프로바이더
└── main.dart                      # 앱 진입점
```

## 🛠️ 기술 스택

- **Framework**: Flutter 3.4.1+
- **상태 관리**: Riverpod 2.6.1
- **HTTP 클라이언트**: Dio 5.9.0
- **환경 변수**: flutter_dotenv 6.0.0
- **이미지 캐싱**: cached_network_image 3.4.1
- **국제화**: intl 0.20.2
- **테스팅**: mocktail 1.0.4

## 🚀 시작하기

### 1. 저장소 클론
```bash
git clone https://github.com/your-username/flutter_movlix.git
cd flutter_movlix
```

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. 환경 변수 설정
`assets/config/.env` 파일을 생성하고 TMDB API 키를 설정:

```env
TMDB_API_KEY=your_tmdb_api_key_here
TMDB_BASE_URL=https://api.themoviedb.org/3/movie/
```

**TMDB API 키 발급 방법:**
1. [TMDB 웹사이트](https://www.themoviedb.org/) 가입
2. Settings → API → API Read Access Token (v4 auth) 생성
3. 생성된 토큰을 `.env` 파일에 입력

### 4. 앱 실행
```bash
flutter run
```

## 📱 화면 구성

### 홈 화면
- **가장 인기있는 영화**: 대형 포스터로 표시
- **현재 상영중**: 가로 스크롤 리스트
- **인기순**: 무한 스크롤 지원
- **평점 높은순**: 순위와 함께 표시
- **개봉예정**: 가로 스크롤 리스트

### 상세 화면
- **영화 포스터**: Hero 애니메이션
- **기본 정보**: 제목, 개봉일, 러닝타임
- **장르**: 태그 형태로 표시
- **줄거리**: 상세한 영화 설명
- **통계**: 평점, 투표수, 인기도 등

## 🔧 개발 가이드

### 새로운 영화 카테고리 추가
1. `ApiEndpoints`에 엔드포인트 추가
2. `MovieDataSource`에 메서드 추가
3. `MovieRepository`에 메서드 추가
4. `HomeViewModel`에 상태 및 메서드 추가
5. UI에 섹션 추가

## 🏗️ 구현 세부사항

### 리포지토리 구현 - DTO를 Entity로 변환

**MovieRepositoryImpl**에서 DTO를 도메인 Entity로 변환하는 과정:

```dart
class MovieRepositoryImpl implements MovieRepository {
  // DTO를 Entity로 변환하는 공통 메서드
  List<Movie>? getMovies(MovieResponseDto result) {
    return result.results
        .map(
          (e) => Movie(
            id: e.id, 
            // 환경 변수에서 TMDB 이미지 베이스 URL을 가져와서 완성
            posterPath: "${dotenv.env["TMDB_IMG_BASE_URL"]}${e.posterPath}"
          ),
        )
        .toList();
  }
}
```

**핵심 포인트:**
- **환경 변수 활용**: `dotenv.env["TMDB_IMG_BASE_URL"]`로 이미지 베이스 URL 관리
- **동적 URL 생성**: API에서 받은 상대 경로(`/path/to/image.jpg`)를 환경 변수의 베이스 URL과 결합
- **유연한 설정**: `.env` 파일에서 이미지 서버 URL을 쉽게 변경 가능

**설계 결정사항:**
- **Movie 엔티티 단순화**: `id`와 `posterPath`만 포함하여 핵심 정보만 관리
- **별도 리포지토리 불필요**: MovieDetail은 Movie와 함께 관리하여 복잡성 감소
- **환경 변수 분리**: 이미지 URL을 하드코딩하지 않고 환경 변수로 관리

## 📊 API 구조

**TMDB Movie API** 엔드포인트:
- `now_playing`: 현재 상영중인 영화
- `popular`: 인기 영화
- `top_rated`: 평점 높은 영화
- `upcoming`: 개봉예정 영화
- `{id}`: 특정 영화 상세 정보

