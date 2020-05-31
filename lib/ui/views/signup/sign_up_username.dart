import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/core/common/common_enum.dart';
import 'package:flutterchat/core/i10n/i10n.dart';
import 'package:flutterchat/core/services/localstorage_service.dart';
import 'package:flutterchat/core/viewmodels/sign_up_username_view_model.dart';
import 'package:flutterchat/ui/app_route.dart';

import 'package:flutterchat/ui/views/base_view.dart';
import 'package:flutterchat/ui/views/signup/sign_up_password.dart';
import 'package:image_picker/image_picker.dart';

import '../../../locator.dart';
import '../login/login.dart';
import '../matrix.dart';


class SignUpUserNameView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpUserNameViewState();
}

/// 註冊-用戶名頁
class _SignUpUserNameViewState extends State<SignUpUserNameView> {

  final TextEditingController _usernameController = TextEditingController();
  /// 图片选择器
  final picker = ImagePicker();
  /// 用戶頭像
  File avatar;

  /// 設置頭像
  void setAvatarAction() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 50,
    );
    if (pickedFile != null) setState(() => avatar = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    final storageService = locator<LocalStorageService>();

    return BaseView<SignUpUserNameViewModel>(
        builder: (context, model, child) => Scaffold(
          /// 顯示homeServer地址
          appBar: AppBar(
            elevation: 0,
            leading: model.state == ViewState.Busy ? Container() : null,
            title: Text(
              storageService.user.homeServer.replaceFirst('https://', ''),
            ),
          ),
          body: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      max((MediaQuery.of(context).size.width - 600) / 2, 0)),
              children: <Widget>[
                /// logo
                Hero(
                  tag: 'loginBanner',
                  child: Image.asset('assets/fluffychat-banner.png'),
                ),
                /// 頭像
                ListTile(
                  /// leading将图像或图标添加到列表的开头。CircleAvatar圓形頭像
                  leading: CircleAvatar(
                    backgroundImage: avatar == null ? null : FileImage(avatar),
                    backgroundColor: avatar == null
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Color(0xff121212)
                            : Colors.white
                        : Theme.of(context).secondaryHeaderColor,
                    child: avatar == null
                        /// 頭像為空的話顯示相機iron
                        ? Icon(Icons.camera_alt,
                            color: Theme.of(context).primaryColor)
                        : null,
                  ),
                  /// 设置拖尾将在列表的末尾放置一个图像
                  trailing: avatar == null
                      ? null
                      : Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                  title: Text(avatar == null
                      ? L10n.of(context).setProfilePicture
                      : L10n.of(context).discardPicture),
                  /// 設置頭像(如果已經有頭像則丟棄)
                  onTap: avatar == null
                      ? setAvatarAction
                      : () => setState(() => avatar = null),
                ),
                /// 用戶名
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Color(0xff121212)
                        : Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: TextField(
                    autocorrect: false,
                    controller: _usernameController,
                    /// 内容提交(按回车)的回调
                    onSubmitted: (s) => model.signUpUserName(context, _usernameController.text),
                    /// 文本框
                    decoration: InputDecoration(
                        hintText: L10n.of(context).username,
                        errorText: model.usernameError,
                        labelText: L10n.of(context).chooseAUsername),
                  ),
                ),
                SizedBox(height: 20),
                ///
                Hero(
                  tag: 'registerButton',
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: RaisedButton(
                      elevation: 7,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: model.state == ViewState.Busy
                          /// 圆形进度指示
                          ? CircularProgressIndicator()
                          : Text(
                              L10n.of(context).signUp.toUpperCase(),
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                      onPressed: () async {
                        var userName = _usernameController.text.toLowerCase().replaceAll(' ', '-');
                        var status = await model.signUpUserName(context,userName);
                        if (status) {
                          // 跳转到输入密码页面
                          await Navigator.of(context).push(
                            AppRoute(
                              SignUpPasswordView(userName,
                                  avatar: avatar, displayName: _usernameController.text),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                /// 已經有帳戶
                Center(
                  child: FlatButton(
                    child: Text(
                      L10n.of(context).alreadyHaveAnAccount,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    /// 進入登陸頁
                    onPressed: () => Navigator.of(context).push(
                      AppRoute(Login()),
                    ),
                  ),
                ),
              ]),
        )
    );


  }
}

//class SignUpUserName extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => _SignUpUserNameState();
//}
//
//class _SignUpUserNameState extends State<SignUpUserName> {
//  /// 是否显示加载中
//  bool loading = false;
//  /// 用戶頭像
//  File avatar;
//  /// 用戶名输入處理器
//  final TextEditingController _usernameController = TextEditingController();
//  /// 用戶名錯誤信息
//  String usernameError;
//  /// 图片选择器
//  final picker = ImagePicker();
//
//  /// 設置頭像
//  void setAvatarAction() async {
//    final pickedFile = await picker.getImage(
//      source: ImageSource.gallery,
//      maxHeight: 512,
//      maxWidth: 512,
//      imageQuality: 50,
//    );
//    if (pickedFile != null) setState(() => avatar = File(pickedFile.path));
//  }
//
//  /// 註冊
//  void signUpAction(BuildContext context) async {
//    var matrix = Matrix.of(context);
//    // 较验用户输入的用户名
//    if (_usernameController.text.isEmpty) {
//      setState(() => usernameError = L10n.of(context).pleaseChooseAUsername);
//    } else {
//      setState(() => usernameError = null);
//    }
//    if (_usernameController.text.isEmpty) {
//      return;
//    }
//    // 启动加载中进度条
//    setState(() => loading = true);
//
//    final preferredUsername =
//    _usernameController.text.toLowerCase().replaceAll(' ', '-');
//
//    try {
//      // 檢測用戶名可用性
//      await matrix.client.usernameAvailable(preferredUsername);
//    } on MatrixException catch (exception) {
//      setState(() => usernameError = exception.errorMessage);
//      return setState(() => loading = false);
//    } catch (exception) {
//      setState(() => usernameError = exception.toString());
//      return setState(() => loading = false);
//    }
//    // 用户名检测通过，停止加载中
//    setState(() => loading = false);
//    // 跳转到输入密码页面
//    await Navigator.of(context).push(
//      AppRoute(
//        SignUpPassword(preferredUsername,
//            avatar: avatar, displayName: _usernameController.text),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      /// 顯示homeServer地址
//      appBar: AppBar(
//        elevation: 0,
//        leading: loading ? Container() : null,
//        title: Text(
//          Matrix.of(context).client.homeServer.replaceFirst('https://', ''),
//        ),
//      ),
//      body: ListView(
//          padding: EdgeInsets.symmetric(
//              horizontal:
//                  max((MediaQuery.of(context).size.width - 600) / 2, 0)),
//          children: <Widget>[
//            /// logo
//            Hero(
//              tag: 'loginBanner',
//              child: Image.asset('assets/fluffychat-banner.png'),
//            ),
//            /// 頭像
//            ListTile(
//              /// leading将图像或图标添加到列表的开头。CircleAvatar圓形頭像
//              leading: CircleAvatar(
//                backgroundImage: avatar == null ? null : FileImage(avatar),
//                backgroundColor: avatar == null
//                    ? Theme.of(context).brightness == Brightness.dark
//                        ? Color(0xff121212)
//                        : Colors.white
//                    : Theme.of(context).secondaryHeaderColor,
//                child: avatar == null
//                    /// 頭像為空的話顯示相機iron
//                    ? Icon(Icons.camera_alt,
//                        color: Theme.of(context).primaryColor)
//                    : null,
//              ),
//              /// 设置拖尾将在列表的末尾放置一个图像
//              trailing: avatar == null
//                  ? null
//                  : Icon(
//                      Icons.close,
//                      color: Colors.red,
//                    ),
//              title: Text(avatar == null
//                  ? L10n.of(context).setProfilePicture
//                  : L10n.of(context).discardPicture),
//              /// 設置頭像(如果已經有頭像則丟棄)
//              onTap: avatar == null
//                  ? setAvatarAction
//                  : () => setState(() => avatar = null),
//            ),
//            /// 用戶名
//            ListTile(
//              leading: CircleAvatar(
//                backgroundColor: Theme.of(context).brightness == Brightness.dark
//                    ? Color(0xff121212)
//                    : Colors.white,
//                child: Icon(
//                  Icons.account_circle,
//                  color: Theme.of(context).primaryColor,
//                ),
//              ),
//              title: TextField(
//                autocorrect: false,
//                controller: _usernameController,
//                /// 内容提交(按回车)的回调
//                onSubmitted: (s) => signUpAction(context),
//                /// 文本框
//                decoration: InputDecoration(
//                    hintText: L10n.of(context).username,
//                    errorText: usernameError,
//                    labelText: L10n.of(context).chooseAUsername),
//              ),
//            ),
//            SizedBox(height: 20),
//            ///
//            Hero(
//              tag: 'registerButton',
//              child: Container(
//                height: 50,
//                padding: EdgeInsets.symmetric(horizontal: 12),
//                child: RaisedButton(
//                  elevation: 7,
//                  color: Theme.of(context).primaryColor,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(6),
//                  ),
//                  child: loading
//                      /// 圆形进度指示
//                      ? CircularProgressIndicator()
//                      : Text(
//                          L10n.of(context).signUp.toUpperCase(),
//                          style: TextStyle(color: Colors.white, fontSize: 16),
//                        ),
//                  onPressed: () => loading ? null : signUpAction(context),
//                ),
//              ),
//            ),
//            /// 已經有帳戶
//            Center(
//              child: FlatButton(
//                child: Text(
//                  L10n.of(context).alreadyHaveAnAccount,
//                  style: TextStyle(
//                    decoration: TextDecoration.underline,
//                    color: Colors.blue,
//                    fontSize: 16,
//                  ),
//                ),
//                /// 進入登陸頁
//                onPressed: () => Navigator.of(context).push(
//                  AppRoute(Login()),
//                ),
//              ),
//            ),
//          ]),
//    );
//  }
//}
