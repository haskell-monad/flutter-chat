import 'dart:convert';

import 'package:http/http.dart' as http;

enum MatrixError {
  M_UNKNOWN,
  M_UNKNOWN_TOKEN
}




class MatrixException implements Exception {

  http.Response response;
  final Map<String, dynamic> raw;

  MatrixException(this.response) : raw = json.decode(response.body);

  /// 如果服务器需要额外身份验证，则返回true。
  bool get requireAdditionalAuthentication => response.statusCode == 401;

  String get errorMessage =>
      raw['error'] ??
          (requireAdditionalAuthentication
              ? 'Require additional authentication'
              : 'Unknown error');


}