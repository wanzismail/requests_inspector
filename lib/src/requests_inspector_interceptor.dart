import 'package:dio/dio.dart';

import '../requests_inspector.dart';

class RequestsInspectorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    InspectorController().addNewRequest(
      RequestDetails(
        requestMethod: RequestMethod.values
            .firstWhere((e) => e.name == response.requestOptions.method),
        url: _extractUrl(response.requestOptions),
        statusCode: response.statusCode ?? 0,
        headers: response.requestOptions.headers,
        queryParameters: response.requestOptions.queryParameters,
        requestBody: response.requestOptions.data,
        responseBody: response.data,
        sentTime: DateTime.now(),
      ),
    );
    super.onResponse(response, handler);
  }

  String _extractUrl(RequestOptions requestOptions) =>
      requestOptions.uri.toString().split('?')[0];

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    InspectorController().addNewRequest(
      RequestDetails(
        requestMethod: RequestMethod.values
            .firstWhere((e) => e.name == err.requestOptions.method),
        url: _extractUrl(err.requestOptions),
        headers: err.requestOptions.headers,
        queryParameters: err.requestOptions.queryParameters,
        requestBody: err.requestOptions.data,
        responseBody: err.message,
        sentTime: DateTime.now(),
      ),
    );
    super.onError(err, handler);
  }
}
