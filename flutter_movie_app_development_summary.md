# Flutter Movie App 개발 과정 전체 요약

## 📚 지금까지 물어본 내용 정리

### **1. 클린 아키텍처 폴더 구조**
- 영화 정보 앱을 위한 클린 아키텍처 구조 설계
- 패키지: riverpod, dio, dotenv 사용
- 인터셉터, constants, errors, shared 폴더 제거
- infrastructure 레이어에 dio_client.dart, network_config.dart 배치

### **2. 인프라스트럭처 레이어 구성**
- dio_client.dart: Dio 클라이언트 설정 (static 싱글톤)
- network_config.dart: .env에서 API_KEY, BASE_URL 로드
- base_repository 제거 (의존성 문제로)
- dotenv.load()는 main.dart에서 실행

### **3. API 엔드포인트 관리**
- api_endpoints.dart: 상대 경로만 관리
- dio_client.dart: baseUrl 설정
- 쿼리 파라미터: language=ko-KR (고정), page (선택적, 기본값 1)

### **4. 데이터 소스 구현**
- MovieDataSourceImpl: 공통 fetch 메서드로 중복 제거
- MovieResponseDto: null 값 처리, OriginalLanguage을 enum에서 String으로 변경
- Movie 엔티티: id, posterPath만 포함 (간단하게)

### **5. 리포지토리 구현**
- MovieRepositoryImpl: MovieDataSource 사용
- getMovies 메서드: DTO를 Entity로 변환
- MovieDetail: 별도 리포지토리 불필요

### **6. 테스트 코드 작성**
- MovieResponseDto, Movie, MovieDetail 엔티티 테스트
- MovieDataSourceImpl 테스트 (mocking 없이)
- 테스트에서 dotenv 로드 문제 해결 (setUpAll 사용)

### **7. Riverpod 프로바이더 구성**
- providers.dart: 중복 제거 (movieRepo 변수로)
- HomeViewModel: Notifier 사용, HomeState 관리
- 상태 불변성: copyWith 메서드 사용

### **8. HomeViewModel 상태 관리**
- HomeState: 여러 영화 리스트 관리
- build() 메서드: 초기 상태 설정, Future.microtask로 비동기 초기화
- 프로젝트 멈춤 문제 해결: build()에서 직접 fetch 호출 제거

### **9. DetailPage 구현**
- Movie 객체를 파라미터로 받음
- Movie.posterPath: 상단 포스터 이미지 표시
- MovieDetail: 뷰모델을 통해 로드하여 상세 정보 표시

### **10. MovieDetailViewModel 설계**
- AutoDisposeFamilyNotifier<MovieDetail?, Movie> 사용
- Movie.id로 MovieDetail 로드
- arg 사용으로 파라미터 중복 제거

### **11. 프로바이더 선택**
- AutoDisposeFamilyNotifierProvider vs FutureProvider.family
- 복잡한 상태 관리 vs 간단한 데이터 로드
- 요구사항에 따른 선택

### **12. HomePage UI 최적화**
- 위젯 분리: `_buildMostPopularMovie`, `_buildMoviesSection` 등 함수로 분리
- 가독성 향상: 코드 구조화로 유지보수성 개선
- 성능 최적화: `CachedNetworkImage` 사용으로 이미지 로딩 최적화

### **13. Hero 애니메이션 구현**
- 태그 중복 문제: 같은 영화 데이터를 여러 섹션에서 사용
- 해결 방법: `"${tagHeader}_${movie.id}"` 형태로 고유 태그 생성
- 사용자 경험: 페이지 전환 시 부드러운 이미지 확대 효과

### **14. 이미지 성능 최적화**
- 문제 상황: `Skipped frames!` 로그로 메인 스레드 과부하 확인
- 원인 분석: `Image.network` 사용으로 동시에 너무 많은 이미지 로드
- 해결책: `CachedNetworkImage` 패키지 도입으로 캐싱 및 성능 개선

### **15. HomeState null 예외처리**
- 문제 상황: HomeState 변수들을 null로 초기화하여 UI 예외 발생
- 해결 방법: 각 UI 함수 내부에서 null 체크 수행
- 안전성 확보: null일 때 빈 Container 표시로 앱 크래시 방지

### **16. 네비게이션 및 상태 유지**
- 뒤로가기 문제: DetailPage에서 뒤로가기 시 HomePage 재로드 문제
- 상태 유지: Riverpod 상태 관리로 데이터 재사용
- 페이지 스택: Navigator를 통한 페이지 전환 관리

### **17. 코드 리팩토링 및 품질 개선**
- 중복 제거: `MovieDataSourceImpl.fetch` 메서드 통합
- Provider 정리: `providers.dart`에서 공통 로직 분리
- 함수 분리: UI 위젯들을 가독성 좋은 함수로 분리
- 상태 불변성: `copyWith` 메서드로 상태 업데이트

### **18. 테스트 환경 설정 및 문제 해결**
- dotenv 로딩: 테스트 환경에서 환경변수 로드 문제
- 의존성 설정: 테스트용 provider 및 mock 설정
- 실제 API 호출: mocking 없이 실제 TMDB API 사용

### **19. 아키텍처 결정 및 원칙**
- YAGNI 원칙: 현재 필요하지 않은 기능은 제거
- 의존성 방향: Domain → Data → Infrastructure 순서 준수
- 레이어 분리: 각 레이어의 명확한 책임과 경계 설정

### **20. 최종 구현 완성**
- 완전한 앱 구조: 클린 아키텍처 기반의 영화 정보 앱
- 사용자 경험: 부드러운 애니메이션과 빠른 이미지 로딩
- 코드 품질: 테스트 가능하고 유지보수하기 쉬운 구조
- 확장성: 새로운 기능 추가 시 용이한 구조

## 🎯 핵심 개념들

### **아키텍처 원칙:**
- 의존성 역전 원칙 준수
- 레이어별 책임 분리
- YAGNI 원칙 (불필요한 복잡성 제거)

### **상태 관리:**
- Riverpod의 Notifier 패턴
- 상태 불변성 유지
- 비동기 초기화 처리

### **데이터 흐름:**
- Movie (기본 정보) → UI 표시
- Movie.id → MovieDetail 로드
- 각각의 역할 명확 분리

### **성능 최적화 원칙:**
- 이미지 캐싱: 네트워크 요청 최소화
- 메인 스레드 보호: 무거운 작업을 백그라운드로 분리
- 상태 재사용: 불필요한 데이터 재로딩 방지

### **UI/UX 원칙:**
- Hero 애니메이션: 자연스러운 페이지 전환
- 로딩 상태: 사용자에게 적절한 피드백 제공
- 에러 처리: null 값에 대한 안전한 UI 표시

### **코드 구조 원칙:**
- 함수 분리: 단일 책임 원칙 적용
- 재사용성: 공통 로직의 중복 제거
- 가독성: 명확한 네이밍과 구조화

## 🚀 최종 결과

**클린 아키텍처를 적용한 영화 정보 앱의 완성된 구조와 구현 방법을 확립했습니다!**

- **아키텍처**: 도메인 중심의 계층화된 구조
- **상태 관리**: Riverpod을 통한 효율적인 상태 관리
- **성능**: 이미지 캐싱과 최적화된 UI 렌더링
- **사용자 경험**: 부드러운 애니메이션과 직관적인 인터페이스
- **코드 품질**: 테스트 가능하고 유지보수하기 쉬운 구조
- **확장성**: 새로운 기능 추가 시 용이한 구조

이 과정을 통해 Flutter의 클린 아키텍처 패턴을 실제 프로젝트에 적용하고, 다양한 문제점들을 해결하면서 실무 경험을 쌓을 수 있었습니다!

