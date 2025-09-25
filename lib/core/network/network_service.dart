import 'package:dio/dio.dart';
import '../constants/constants.dart';

class NetworkService {
  late final Dio _dio;

  NetworkService() {
    _dio = Dio();
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = ApiConstants.apiKey;
          handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
