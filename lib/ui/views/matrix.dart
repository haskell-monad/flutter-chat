import 'package:flutter/material.dart';
import 'package:flutterchat/core/common/matrix_client.dart';
import 'package:flutterchat/core/services/localstorage_service.dart';
import 'package:flutterchat/core/viewmodels/base_view_model.dart';
import 'package:flutterchat/ui/views/base_view.dart';

import '../../locator.dart';

class Matrix extends StatefulWidget {

  final String clientName;
  final Widget child;

  Matrix({this.clientName, this.child, Key key}) : super(key: key);

  @override
  MatrixState createState() => MatrixState();

//  /// Returns the (nearest) Client instance of your application.
//  static MatrixState of(BuildContext context) {
//    var newState =
//        (context.dependOnInheritedWidgetOfExactType<_InheritedMatrix>()).data;
//    newState.context = context;
//    return newState;
//  }
}

class MatrixState extends State<Matrix> {

  static const String defaultHomeServer = 'im.indiedeveloper.club';

  final localStorage = locator<LocalStorageService>();


  @override
  BuildContext context;

  @override
  void initState() {
    if (localStorage.user == null) {
      var matrixClient = MatrixClient(widget.clientName);
      matrixClient.homeServer = defaultHomeServer;
      localStorage.user = matrixClient;
      debugPrint('[Matrix] Init matrix client');
    }else{
      debugPrint('[Matrix] connect matrix server');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
//    return _InheritedMatrix(data: this, child: widget.child);
  }
}

///
//class _InheritedMatrix extends InheritedWidget {
//  final MatrixState data;
//
//  _InheritedMatrix({Key key, this.data, Widget child})
//      : super(key: key, child: child);
//
//  @override
//  bool updateShouldNotify(_InheritedMatrix old) {
//    var update = old.data.client.accessToken != data.client.accessToken ||
//        old.data.client.userId != data.client.userId ||
//        old.data.client.deviceId != data.client.deviceId ||
//        old.data.client.deviceName != data.client.deviceName ||
//        old.data.client.homeServer != data.client.homeServer;
//    return update;
//  }
//}
