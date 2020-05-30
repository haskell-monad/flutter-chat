import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/core/common/common_enum.dart';
import 'package:flutterchat/core/common/matrix_enum.dart';
import 'package:flutterchat/core/common/matrix_exception.dart';
import 'package:flutterchat/core/i10n/i10n.dart';
import 'package:flutterchat/core/viewmodels/sign_up_password_view_model.dart';
import 'package:flutterchat/ui/app_route.dart';
import 'package:flutterchat/ui/views/base_view.dart';
import 'package:flutterchat/ui/views/chat/chat_list.dart';

/// 註冊-密碼頁
class SignUpPassword extends StatefulWidget {
  /// 頭像
  final File avatar;

  /// 用戶名
  final String userName;

  /// 顯示名
  final String displayName;

  SignUpPassword(this.userName, {this.avatar, this.displayName});

  @override
  _SignUpPasswordState createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  /// 是否顯示密碼
  bool showPassword = true;

  /// 密碼選擇器
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpPasswordViewModel>(
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: model.state == ViewState.Busy ? Container() : null,
                title: Text(
                  L10n.of(context).chooseAStrongPassword,
                ),
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        max((MediaQuery.of(context).size.width - 600) / 2, 0)),
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.lock,
                          color: Theme.of(context).primaryColor),
                    ),
                    title: TextField(
                      controller: _passwordController,
                      //是否隐藏正在编辑的文本，如用于输入密码的场景等，文本内容会用“•”替换
                      obscureText: !showPassword,
                      //是否自动对焦
                      autofocus: true,
                      //是否自动更正
                      autocorrect: false,
                      //内容提交(按回车)的回调
                      onSubmitted: (t) async {
                        var n = await model.signUpAndLoginAction(context, widget.displayName, widget.userName, _passwordController.text, widget.avatar);
                        if (n) {
                          // 進入到聊天列表頁面
                          await Navigator.of(context).pushAndRemoveUntil(
                                AppRoute.defaultRoute(context, ChatListView()), (r) => false);
                        }
                      },
                      decoration: InputDecoration(
                          // placeholder
                          hintText: '****',
                          errorText: model.errorMsg,
                          suffixIcon: IconButton(
                            icon: Icon(showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                          ),
                          labelText: L10n.of(context).password),
                    ),
                  ),
                  SizedBox(height: 20),
                  Hero(
                    tag: 'loginButton',
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: RaisedButton(
                        // 阴影的范围，值越大阴影范围越大
                        elevation: 7,
                        color: Theme.of(context).primaryColor,
                        // 设置按钮的形状
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: model.state == ViewState.Busy
                            // 顯示加載中
                            ? CircularProgressIndicator()
                            // 立即創建用戶
                            : Text(
                                L10n.of(context).createAccountNow.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                        onPressed: () async {
                          if (model.state == ViewState.Busy) {
                            return null;
                          }
                          var n = await model.signUpAndLoginAction(context, widget.displayName, widget.userName, _passwordController.text, widget.avatar);
                          if(n){
                            // 進入到聊天列表頁面
                            await Navigator.of(context).pushAndRemoveUntil(
                              AppRoute.defaultRoute(context, ChatListView()), (r) => false);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
