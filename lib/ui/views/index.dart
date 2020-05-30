import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutterchat/core/common/matrix_client.dart';
import 'package:flutterchat/core/common/simple_dialog.dart';
import 'package:flutterchat/core/i10n/i10n.dart';
import 'package:flutterchat/core/services/localstorage_service.dart';
import 'package:flutterchat/core/services/matrix/matrix_cs_api.dart';
import 'package:flutterchat/ui/app_route.dart';
import 'package:flutterchat/ui/views/signup/sign_up_username.dart';

import '../../locator.dart';

import 'matrix.dart';

//
class Index extends StatelessWidget {

  static const String defaultHomeServer = 'im.indiedeveloper.club';

  // TODO 需要移到其他地方
  final matrixApi = locator<MatrixApi>();
  final localStorage = locator<LocalStorageService>();

  /// 修改homeServer
  Future<void> _setHomeServerAction(BuildContext context) async {
    final homeServer = await SimpleDialogs(context).enterText(
        titleText: L10n.of(context).enterYourHomeServer,
        hintText: defaultHomeServer,
        prefixText: 'https://');
    if (homeServer?.isEmpty ?? true) {
      return;
    }
    /// 檢測
    _checkHomeServerAction(homeServer, context);
  }

  /// 檢測homeServer版本兼容
  void _checkHomeServerAction(String homeServer, BuildContext context) async {
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
        matrixApi.checkHomeServer(homeServer));
    if (success != false) {
      var matrixClient = localStorage.user;
      if(matrixClient == null){
        matrixClient = MatrixClient("iron-im");
      }
      matrixClient.homeServer = homeServer;
      localStorage.user = matrixClient;
      // 跳轉到註冊頁面
      await Navigator.of(context).push(AppRoute(SignUpUserNameView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
              max((MediaQuery.of(context).size.width - 600) / 2, 0)),
          child: Column(
            children: <Widget>[
              /// logo
              Hero(
                tag: 'loginBanner',
                child: Image.asset('assets/fluffychat-banner.png'),
              ),
              /// 歡迎語句
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  L10n.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Spacer(),
              /// connect按鈕
              Hero(
                tag: 'loginButton',
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: RaisedButton(
                    elevation: 7,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      L10n.of(context).connect.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () => _checkHomeServerAction(
                        defaultHomeServer, context),
                  ),
                ),
              ),
              /// 默認連接的homeServer文本提示
              Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Opacity(
                  opacity: 0.75,
                  child: Text(
                    L10n.of(context).defaultConnectedHomeServer(
                        defaultHomeServer),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              /// 更改homeServer
              FlatButton(
                child: Text(
                  L10n.of(context).changeHomeServer,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => _setHomeServerAction(context),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
