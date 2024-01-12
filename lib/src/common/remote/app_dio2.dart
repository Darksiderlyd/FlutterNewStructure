import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:readbook/src/common/tools/logger.dart';
// 不依赖Retrofit
class Request {
  // 配置 Dio 实例
  static BaseOptions _options = BaseOptions(
    ///Api地址
    baseUrl: 'https://www.beacons.vip',
    contentType: 'application/json',

    ///打开超时时间
    connectTimeout: const Duration(milliseconds: 50000),

    ///接收超时时间
    receiveTimeout: const Duration(milliseconds: 30000),

    ///发送超时时间
    sendTimeout: const Duration(milliseconds: 30000),
  );

  // 创建 Dio 实例
  static Dio _dio = Dio(_options);

  // _request 是核心函数，所有的请求都会走这里
  static Future<T> _request<T>(String path,
      {String? method, Map? params, data}) async {
    // restful 请求处理
    if (params != null) {
      params.forEach((key, value) {
        if (path.indexOf(key) != -1) {
          path = path.replaceAll(':$key', value.toString());
        }
      });
    }
    logger.e('发送的数据为：${data}');
    try {
      Response response = await _dio.request(
        path,
        data: data,
        options: Options(
          method: method,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.data);
        try {
          // return data;
          /// 如果状态吗不等于0，说明错误，则进行提示
          if (data['code'] == "1") {
            logger.e('服务器错误，状态码为：${data['code']}, 错误信息为： ${data['msg']}');
            return Future.error(data['msg']);
          } else if (data['code'] == '404') {
            /// 如果状态丢失了，将用户token数据清空，让引导页可以直接登录
            logger.e('当前数据状态丢失，请重新登录');

            /// 这里写你的重新登录逻辑

            return Future.error(data['msg']);
          } else {
            ///其他状态说明正常
            logger.e('响应的数据为：', error: data);
            return data;
          }
        } catch (e) {
          logger.e('解析响应数据异常1', error: e);
          return Future.error('解析响应数据异常2');
        }
      } else {
        logger.e('HTTP错误，状态码为：${response.statusCode}');
        _handleHttpError(response.statusCode!);
        return Future.error('HTTP错误');
      }
    } on DioException catch (e, s) {
      logger.e('请求异常', error: _dioError(e));
      showToast(_dioError(e));
      return Future.error(_dioError(e));
    } catch (e, s) {
      logger.e('未知异常', error: e);
      return Future.error('未知异常');
    }
  }

  // 处理 Dio 异常
  static String _dioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "网络连接超时，请检查网络设置";
        break;
      case DioExceptionType.receiveTimeout:
        return "服务器异常，请稍后重试！";
        break;
      case DioExceptionType.sendTimeout:
        return "网络连接超时，请检查网络设置";
        break;
      case DioExceptionType.badResponse:
        return "服务器异常，请稍后重试！";
        break;
      case DioExceptionType.cancel:
        return "请求已被取消，请重新请求";
        break;
      case DioExceptionType.unknown:
        return "网络异常，请稍后重试！";
        break;
      default:
        return "Dio异常";
    }
  }

  // 处理 Http 错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    showToast(message);
  }

  static Future<T> get<T>(String path, {Map? params}) {
    return _request(path, method: 'get', params: params);
  }

  static Future<T> post<T>(String path, {Map? params, data}) {
    return _request(path, method: 'post', params: params, data: data);
  }

}