import 'package:flutter/cupertino.dart';
import 'package:flutterchat/core/common/common_enum.dart';
import 'package:flutterchat/core/common/matrix_exception.dart';
import 'package:flutterchat/core/i10n/i10n.dart';
import 'package:flutterchat/core/services/matrix/matrix_cs_api.dart';
import 'package:flutterchat/core/viewmodels/base_view_model.dart';

import '../../locator.dart';

class SignUpUserNameViewModel extends BaseViewModel {

  String usernameError;

  final matrixApi = locator<MatrixApi>();

  /// 註冊
  Future<bool> signUpUserName(BuildContext context, String username) async {
    // 较验用户输入的用户名
    if (username.isEmpty) {
      usernameError = L10n.of(context).pleaseChooseAUsername;
    } else {
      usernameError = null;
    }
    if (username.isEmpty) {
      setState(ViewState.Idle, errorMsg: usernameError);
      return false;
    }
    // 启动加载中进度条
    setState(ViewState.Busy);
    try {
      // 檢測用戶名可用性
      await matrixApi.usernameAvailable(username);
    } on MatrixException catch (exception) {
      setState(ViewState.Idle, errorMsg: exception.errorMessage);
      return false;
    } catch (exception) {
      setState(ViewState.Idle, errorMsg: exception.toString());
      return false;
    }
    // 用户名检测通过，停止加载中
    setState(ViewState.Idle);
    return true;
  }
}