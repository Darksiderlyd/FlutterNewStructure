import 'package:dio/dio.dart';
import 'package:readbook/src/constants/api.dart';

class AppDio with DioMixin implements Dio {
  AppDio._() {
    options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 30000),
      sendTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    );
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          return handler.next(e);
        },
      ),
    );
  }

  static Dio getInstance() => AppDio._();
}


