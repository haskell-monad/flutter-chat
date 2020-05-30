import 'package:flutterchat/core/common/common_enum.dart';

import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {

  String errorMessage;

  Future<bool> login(String userIdText) async {
    setState(ViewState.Busy);

    var userId = int.tryParse(userIdText);

    // Not a number
    if(userId == null) {
      errorMessage = 'Value entered is not a number';
      setState(ViewState.Idle);
      return false;
    }

//    var success = await _authenticationService.login(userId);
    var success = true;
    // Handle potential error here too.

    setState(ViewState.Idle);
    return success;
  }

}