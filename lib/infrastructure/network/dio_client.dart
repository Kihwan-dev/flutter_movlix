import 'package:dio/dio.dart';
import 'package:flutter_movlix/infrastructure/network/network_config.dart';

class DioClient {
  static Dio get client => _client;

  static Dio _client = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3/movie/",
      validateStatus: (status) => true,
    ),
  )..interceptors.add(interceptor);

  static AuthInterceptor interceptor = AuthInterceptor();
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      // 헤더 설정
      "Authorization": "Bearer ${NetworkConfig.tbmdApiKey}",
      "accept": "application/json",
    });

    // 반드시 부모클래스의 onRequest를 호출해줘야함!!!!
    super.onRequest(options, handler);
  }
}
