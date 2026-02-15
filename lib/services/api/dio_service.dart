import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/endpoints.dart';

class DioService {
  DioService(this.ref) {
    dio = Dio();
    dio.options.baseUrl = AppEndpoints.movieDbBase;
    dio.options.sendTimeout = const Duration(milliseconds: 30000);
    dio.options.connectTimeout = const Duration(milliseconds: 30000);
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  final Ref ref;
  late final Dio dio;
}
