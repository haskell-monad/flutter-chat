import 'dart:convert';

import 'package:http/http.dart' as http;

enum MatrixError {
  M_UNKNOWN,
  M_UNKNOWN_TOKEN,
  M_NOT_FOUND,
  M_FORBIDDEN,
  M_LIMIT_EXCEEDED,
  M_USER_IN_USE,
//  M_THREEPID_IN_USE,
//  M_THREEPID_DENIED,
//  M_THREEPID_NOT_FOUND,
//  M_THREEPID_AUTH_FAILED,
  M_TOO_LARGE,
  M_MISSING_PARAM,
  M_UNSUPPORTED_ROOM_VERSION,
  M_UNRECOGNIZED,
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

  /// 返回[ResponseError]。 如果没有错误，则为[ResponseError.NONE]。
  MatrixError get error => MatrixError.values.firstWhere(
          (e) => e.toString() == 'MatrixError.${(raw["errcode"] ?? "")}',
      orElse: () => MatrixError.M_UNKNOWN);


  /// 对于每个端点，服务器都提供一个或多个"flows"，
  /// 客户端可以使用这些"flows"对自身进行身份验证。
  /// 每个flows包括一系列阶段。如果此请求不需要額外身份验证，则为null。
  List<AuthenticationFlow> get authenticationFlows {
    if (!raw.containsKey('flows') || !(raw['flows'] is List)) return null;
    var flows = <AuthenticationFlow>[];
    for (Map<String, dynamic> flow in raw['flows']) {
      if (flow['stages'] is List) {
        flows.add(AuthenticationFlow(List<String>.from(flow['stages'])));
      }
    }
    return flows;
  }

  /// 返回先前请求中已完成的身份验证流的列表
  List<String> get completedAuthenticationFlows =>
      List<String>.from(raw['completed'] ?? []);

  /// 这是一个会话标识符，如果提供了该标识符，则客户端必须将其传递回"HomeServer"，
  /// 以便随后在同一个API调用中进行身份验证。
  String get session => raw['session'];

}

class AuthenticationFlow {
  final List<String> stages;
  const AuthenticationFlow(this.stages);
}