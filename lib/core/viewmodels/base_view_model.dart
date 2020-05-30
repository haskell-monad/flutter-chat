import 'package:flutter/widgets.dart';
import 'package:flutterchat/core/common/common_enum.dart';


class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  String _errorMsg = "";

  ViewState get state => _state;

  String get errorMsg => _errorMsg;

  void setState(ViewState viewState, {String errorMsg}) {
    _state = viewState;
    _errorMsg = errorMsg;
    notifyListeners();
  }
}