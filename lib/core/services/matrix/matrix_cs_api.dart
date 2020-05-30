import 'dart:async';
import 'dart:convert';

import 'package:flutterchat/core/common/matrix_client.dart';
import 'package:flutterchat/core/common/matrix_enum.dart';

import '../../../locator.dart';
import '../localstorage_service.dart';

import 'package:http/http.dart' as http;

class MatrixApi {
//  StreamController<User> userController = StreamController<User>();

  int _timeoutFactor = 1;

  /// 矩阵同步是通过https长轮询完成的。 这需要一个通常为30秒的超时。
  static const int syncTimeoutSec = 30;

  /// 应用应等待多长时间，直到出现错误后重试同步？
  static const int syncErrorTimeoutSec = 3;

  final storageService = locator<LocalStorageService>();

  /// http客戶端
  final http.Client httpClient = http.Client();


  /// 检查受支持的Matrix协议版本和受支持的登录类型。
  /// 如果服务器与客户端不兼容，则返回false。
  /// 发生错误时引发FormatException，TimeoutException和MatrixException。
  Future<bool> checkHomeServer(serverUrl) async {
    try {

      final versionResp =
      await jsonRequest(type: HTTP.GET, action: '/client/versions');

      final versions = List<String>.from(versionResp['versions']);

      for (var i = 0; i < versions.length; i++) {
        if (versions[i] == 'r0.5.0' || versions[i] == 'r0.6.0') {
          break;
        } else if (i == versions.length - 1) {
          return false;
        }
      }
      final loginResp = await jsonRequest(type: HTTP.GET, action: '/client/r0/login');

      final List<dynamic> flows = loginResp['flows'];

      for (var i = 0; i < flows.length; i++) {
        if (flows[i].containsKey('type') &&
            flows[i]['type'] == 'm.login.password') {
          break;
        } else if (i == flows.length - 1) {
          return false;
        }
      }
      return true;
    } catch (_) {
      rethrow;
    }
  }

  /// 检查服务器的用户名是否可用且有效。
  /// 返回已注册的标准Matrix用户ID(MXID)。
  /// 您必须先調用[checkServer]来设置家庭服务器。
  Future<Map<String, dynamic>> register({
    String kind,
    String username,
    String password,
    Map<String, dynamic> auth,
    String deviceId,
    String initialDeviceDisplayName,
    bool inhibitLogin,
  }) async {
    final action = '/client/r0/register' + (kind != null ? '?kind=$kind' : '');
    var data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (password != null) data['password'] = password;
    if (auth != null) data['auth'] = auth;
    if (deviceId != null) data['device_id'] = deviceId;
    if (initialDeviceDisplayName != null) {
      data['initial_device_display_name'] = initialDeviceDisplayName;
    }
    if (inhibitLogin != null) data['inhibit_login'] = inhibitLogin;
    final response =
    await jsonRequest(type: HTTP.POST, action: action, data: data);

    // Connect if there is an access token in the response.
    if (response.containsKey('access_token') &&
        response.containsKey('device_id') &&
        response.containsKey('user_id')) {
//      await connect(
//          newToken: response['access_token'],
//          newUserID: response['user_id'],
//          newHomeServer: storageService.user.homeServer,
//          newDeviceName: initialDeviceDisplayName ?? '',
//          newDeviceID: response['device_id']);
      // TODO
      var matrixClient = storageService.user;
      if (matrixClient == null) {
        matrixClient = MatrixClient("iron-chat-client");
      }
      matrixClient.userId = response['user_id'];
      matrixClient.accessToken = response['access_token'];
      matrixClient.deviceId = response['device_id'];
      storageService.user = matrixClient;
      print(
          "[Register-Success: user_id: ${matrixClient.userId},  access_token: ${matrixClient.accessToken}");
    }
    return response;
  }

  /// 登陸
  Future<bool> login(
    String username,
    String password, {
    String initialDeviceDisplayName,
    String deviceId,
  }) async {
    var data = <String, dynamic>{
      'type': 'm.login.password',
      'user': username,
      'identifier': {
        'type': 'm.id.user',
        'user': username,
      },
      'password': password,
    };
    if (deviceId != null) {
      data['device_id'] = deviceId;
    }
    if (initialDeviceDisplayName != null) {
      data['initial_device_display_name'] = initialDeviceDisplayName;
    }

    final loginResp = await jsonRequest(
        type: HTTP.POST, action: '/client/r0/login', data: data);

    if (loginResp.containsKey('user_id') &&
        loginResp.containsKey('access_token') &&
        loginResp.containsKey('device_id')) {
      // TODO
//      await connect(
//        newToken: loginResp['access_token'],
//        newUserID: loginResp['user_id'],
//        newHomeServer: storageService.user.homeServer,
//        newDeviceName: initialDeviceDisplayName ?? '',
//        newDeviceID: loginResp['device_id'],
//      );
      // 保存用戶信息
      var matrixClient = storageService.user;
      if (matrixClient == null) {
        matrixClient = MatrixClient("iron-chat-client");
      }
      matrixClient.userId = loginResp['user_id'];
      matrixClient.accessToken = loginResp['access_token'];
      storageService.user = matrixClient;
      print(
          "[Login-Success: user_id: ${matrixClient.userId},  access_token: ${matrixClient.accessToken}");
      return true;
    }
    return false;
  }

  /// 检查服务器的用户名是否可用且有效。
  /// 您必须先調用[checkServer]来设置homeServer。
  Future<bool> usernameAvailable(String username) async {
    final response = await jsonRequest(
      type: HTTP.GET,
      action: '/client/r0/register/available?username=$username',
    );
    return response['available'];
  }

  /// 更改用户的显示名
  Future<void> setDisplayName(String userId, String displayName) async {
    await jsonRequest(
        type: HTTP.PUT,
        action: '/client/r0/profile/$userId/displayname',
        data: {'displayname': displayName});
    return;
  }

  /// 上传该用户的新头像
//  Future<void> setAvatar(String userId, MatrixFile file) async {
//    final uploadResp = await upload(file);
//    await jsonRequest(
//        type: HTTP.PUT,
//        action: '/client/r0/profile/$userId/avatar_url',
//        data: {'avatar_url': uploadResp});
//    return;
//  }

  Future<Map<String, dynamic>> jsonRequest(
      {HTTP type,
      String action,
      dynamic data = '',
      int timeout,
      String contentType = 'application/json'}) async {
    final matrixClient = storageService.user;

    if (matrixClient.isLogged() == false && matrixClient.homeServer == null) {
      throw ('No homeServer specified.');
    }
    timeout ??= (_timeoutFactor * syncTimeoutSec) + 5;
    dynamic json;
    if (data is Map) data.removeWhere((k, v) => v == null);
    (!(data is String)) ? json = jsonEncode(data) : json = data;
    if (data is List<int> || action.startsWith('/media/r0/upload')) json = data;

    var url = '${matrixClient.homeServer}/_matrix${action}';

    if (!url.startsWith('https://')) {
      url = 'https://$url';
    }

    var headers = <String, String>{};
    if (type == HTTP.PUT || type == HTTP.POST) {
      headers['Content-Type'] = contentType;
    }
    if (matrixClient.isLogged()) {
      headers['Authorization'] = 'Bearer ${matrixClient.accessToken}';
    }

    if (matrixClient.debug) {
      print(
          "[REQUEST ${type.toString().split('.').last}] Action: $action, Data: ${jsonEncode(data)}");
    }

    http.Response resp;
    var jsonResp = <String, dynamic>{};
    try {
      switch (type.toString().split('.').last) {
        case 'GET':
          resp = await httpClient.get(url, headers: headers).timeout(
                Duration(seconds: timeout),
                onTimeout: () => null,
              );
          break;
        case 'POST':
          resp =
              await httpClient.post(url, body: json, headers: headers).timeout(
                    Duration(seconds: timeout),
                    onTimeout: () => null,
                  );
          break;
        case 'PUT':
          resp =
              await httpClient.put(url, body: json, headers: headers).timeout(
                    Duration(seconds: timeout),
                    onTimeout: () => null,
                  );
          break;
        case 'DELETE':
          resp = await httpClient.delete(url, headers: headers).timeout(
                Duration(seconds: timeout),
                onTimeout: () => null,
              );
          break;
      }
      if (resp == null) {
        throw TimeoutException;
      }
      jsonResp = jsonDecode(String.fromCharCodes(resp.body.runes))
          as Map<String, dynamic>; // May throw FormatException

      if (resp.statusCode >= 400 && resp.statusCode < 500) {
        // The server has responsed with an matrix related error.
//        var exception = MatrixException(resp);
//        if (exception.error == MatrixException.M_UNKNOWN_TOKEN) {
//          // The token is no longer valid. Need to sign off....
//          // TODO: add a way to export keys prior logout?
//          onError.add(exception);
//          clear();
//        }

        throw resp;
      }

      if (matrixClient.debug) print('[RESPONSE] ${jsonResp.toString()}');
    } on ArgumentError catch (exception) {
      print(exception);
      // Ignore this error
    } on TimeoutException catch (_) {
      _timeoutFactor *= 2;
      rethrow;
    } catch (_) {
      print(_);
      rethrow;
    }

    return jsonResp;
  }
}
