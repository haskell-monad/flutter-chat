// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static m3(homeServer) => "默认情况下，您将连接到 ${homeServer}";

  static _notInlinedMessages(_) => <String, Function>{
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage("欢迎来到矩阵网络中最可爱的即时通讯工具."),
        "Enter your homeServer":
            MessageLookupByLibrary.simpleMessage("輸入你的HomeServer"),
        "Change the homeServer":
            MessageLookupByLibrary.simpleMessage("修改homeServer"),
        "Connect": MessageLookupByLibrary.simpleMessage("连接"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("设定个人资料图片"),
        "Discard picture": MessageLookupByLibrary.simpleMessage("丢弃图片"),
        "Username": MessageLookupByLibrary.simpleMessage("用戶名"),
        "Choose a username": MessageLookupByLibrary.simpleMessage("挑选一个用户名"),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("请挑选一个用户名"),
        "Sign up": MessageLookupByLibrary.simpleMessage("注册"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("已经有帐号了？"),
        "Password": MessageLookupByLibrary.simpleMessage("密码"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("挑选一个强密码"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("请輸入你的密码"),
        "Create account now": MessageLookupByLibrary.simpleMessage("立即创建帐户"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage("无法设置头像"),
        "Could not set displayName":
            MessageLookupByLibrary.simpleMessage("无法设置显示名"),
    "ok": MessageLookupByLibrary.simpleMessage("好的"),
    "Close": MessageLookupByLibrary.simpleMessage("关闭"),
    "Confirm": MessageLookupByLibrary.simpleMessage("确认"),
    "Are you sure?":
    MessageLookupByLibrary.simpleMessage("你确定吗?"),
    "Loading... Please wait":
    MessageLookupByLibrary.simpleMessage("加载中...请稍候"),
        "DefaultConnectedHomeServer": m3,
      };
}
