
import 'package:flutterchat/core/viewmodels/sign_up_password_view_model.dart';
import 'package:get_it/get_it.dart';

import 'package:flutterchat/core/viewmodels/login_view_model.dart';

import 'core/services/localstorage_service.dart';
import 'core/services/matrix/matrix_cs_api.dart';
import 'core/viewmodels/sign_up_username_view_model.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {

  locator.registerLazySingleton(() => MatrixApi());

  /// 註冊LocalStorageService
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);

  /// 註冊viewModel
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => SignUpUserNameViewModel());
  locator.registerFactory(() => SignUpPasswordViewModel());
}