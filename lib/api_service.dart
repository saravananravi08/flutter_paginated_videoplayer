import 'dart:developer';

import 'package:dio/dio.dart';
import 'dart:async';

typedef JSON = Map<String, dynamic>;
String defaultApiError = 'Something went wrong !';
String networkError = 'No Connection !';

String _getError(e) {
  log(e.toString());
  if (e is DioException) {
    if (e.response == null) {
      return networkError;
    }
    if (e.message?.startsWith('SocketException') ?? false) {
      return networkError;
    }
    if (e.response?.data is Map && e.response!.data['detail'] != null) {
      return e.response!.data['detail'];
    }
  }
  return defaultApiError;
}

class ApiServices {
  Dio dio = Dio();
  ApiServices() {
    dio.options.baseUrl = 'http://144.126.228.35:8000';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Authorization'] =
            """Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjYyM2YzNmM4MTZlZTNkZWQ2YzU0NTkyZTM4ZGFlZjcyZjE1YTBmMTMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmxhaW1lZC02MzE4MSIsImF1ZCI6ImZsYWltZWQtNjMxODEiLCJhdXRoX3RpbWUiOjE2OTA5ODIyMzIsInVzZXJfaWQiOiJxb3V0OGZ5NTdnVEp1bHBnSW03dlV2bHpVeUUyIiwic3ViIjoicW91dDhmeTU3Z1RKdWxwZ0ltN3ZVdmx6VXlFMiIsImlhdCI6MTY5MTI0ODY1NSwiZXhwIjoxNjkxMjUyMjU1LCJlbWFpbCI6ImtoYWJpYkBmYWtlY21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImtoYWJpYkBmYWtlY21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.Ta4T4g3UYIVKx9X7ZGxqOmJwjMkyYWDOBo8v7D3UIvlbXDYBzzizI_egQtIYCnzpThfEtsBQ0gz_uy4zlBdZGy4J_tntPGZtz6DpZok1L65nYXFQsXlMblATgKrNeBfKIkOdESTdH_BoqiHy0nDg43BvP2IwtTgLV040uXms23wJ_Dgm0J_i__umG92PIf47evRt-hEB5d_z5P5Pl4H18r6wSpejZiVlfMyhMXYO0JIPJ8VPw2VI64-adyLICwvP2efUz2ZoCVSo1r_9ZLLloXQ2FVLY6y_bZy1IdcnP4zRO74l5bTtf6CDzBadBh4xP3j0jMwpzt1jwDle4by_WXg""";
        handler.next(options);
      },
    ));
  }
  Future<Response> getMethod(String path, {JSON? parameters}) async {
    try {
      final response = await dio.get(path, queryParameters: parameters);
      return response;
    } catch (e) {
      throw _getError(e);
    }
  }
}
