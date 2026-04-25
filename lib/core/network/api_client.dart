import 'package:dio/dio.dart';
import '../constants/environment.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({List<Interceptor>? interceptors})
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppEnvironment.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 60),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }

    if (AppEnvironment.isDev) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => print(obj.toString()),
        ),
      );
    }
  }

  Dio get client => _dio;
}
