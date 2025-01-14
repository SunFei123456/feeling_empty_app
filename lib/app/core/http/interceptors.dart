import 'package:dio/dio.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:get/get.dart' hide Response;

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从本地存储获取token
    // final token = StorageService.to.getString('token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }
}

/// 日志拦截器
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('请求URL: ${options.baseUrl}${options.path}');
    print('请求方法: ${options.method}');
    print('请求头: ${options.headers}');
    print('请求数据: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('响应码: ${response.statusCode}');
    print('响应数据: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('请求错误: ${err.type}');
    print('错误信息: ${err.message}');
    print('错误详情: ${err.error}');
    handler.next(err);
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DeadlineExceededException(err.requestOptions);
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            err = BadRequestException(err.requestOptions);
            break;
          case 401:
            err = UnauthorizedException(err.requestOptions);
            break;
          case 403:
            err = ForbiddenException(err.requestOptions);
            break;
          case 404:
            err = NotFoundException(err.requestOptions);
            break;
          case 409:
            err = ConflictException(err.requestOptions);
            break;
          case 500:
            err = InternalServerErrorException(err.requestOptions);
            break;
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        err = NoInternetConnectionException(err.requestOptions);
        break;
      default:
        break;
    }
    return super.onError(err, handler);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Internal server error occurred';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested resource does not exist';
  }
}

class ForbiddenException extends DioException {
  ForbiddenException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access to resource is forbidden';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection';
  }
}

class TokenInterceptor extends Interceptor {
  final TokenService _tokenService = TokenService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token 过期或无效，清除本地 token 并跳转到登录页
      _tokenService.clearAuth();
      Get.offAllNamed('/login');
      return;
    }
    handler.next(err);
  }
}
