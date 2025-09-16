import 'package:dio/dio.dart';
import '../error/api_exceptions.dart';


abstract class HttpClientInterface {
  Future<dynamic> post(String url);
  // Future<dynamic> put(String url, {Map<String, dynamic>? body});
  // Future<dynamic> fetchImage(String url);
  // Future<dynamic> uploadFile(
  //   String url,
  //   File file, {
  //   Map<String, dynamic>? fields,
  // });
}

class NetworkClient implements HttpClientInterface {
  final dio = Dio();

  NetworkClient() {
    dio.options = BaseOptions(
      receiveDataWhenStatusError: true,
      contentType: 'application/json',
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json', 'User-Agent': 'Dart/Flutter App'},
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('➡ [REQUEST] ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Body: ${options.data}');
          // Example: add token to headers dynamically
          options.headers['Authorization'] = 'Bearer yourAuthToken';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print('❌ [ERROR] ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<dynamic> post(String url) async {
    try {
      final response = await dio.post(url);
      return response.data;
    } on DioException catch (error) {
      throw ApiErrorHandler.handle(error);
    } catch (error) {
      throw ApiException('Unexpected error', originalError: error);
    }
  }

  // @override
  // Future<dynamic> put(String url, {Map<String, dynamic>? body}) async {
  //   try {
  //     final response = await dio.put(url, data: body);
  //     return response.data;
  //   } on DioException catch (error) {
  //     throw ApiErrorHandler.handle(error);
  //   } catch (error) {
  //     throw ApiException('Unexpected error', originalError: error);
  //   }
  // }

  // @override
  // Future<Uint8List> fetchImage(String url) async {
  //   try {
  //     final response = await dio.get<List<int>>(
  //       url,
  //       options: Options(responseType: ResponseType.bytes),
  //     );
  //     return Uint8List.fromList(response.data!);
  //   } on DioException catch (error) {
  //     throw ApiErrorHandler.handle(error);
  //   } catch (error) {
  //     throw ApiException('Unexpected error', originalError: error);
  //   }
  // }
  //
  // @override
  // Future uploadFile(
  //   String url,
  //   File file, {
  //   Map<String, dynamic>? fields,
  // }) async {
  //   try {
  //     String fileName = file.path.split('/').last;
  //
  //     FormData formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(file.path, filename: fileName),
  //       if (fields != null) ...fields,
  //     });
  //
  //     final response = await dio.post(
  //       url,
  //       data: formData,
  //       options: Options(contentType: 'multipart/form-data'),
  //     );
  //
  //     return response.data;
  //   } on DioException catch (error) {
  //     throw ApiErrorHandler.handle(error);
  //   } catch (error) {
  //     throw ApiException('Unexpected error', originalError: error);
  //   }
  // }
}
