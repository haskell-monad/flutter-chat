import 'package:flutterchat/core/services/matrix/matrix_cs_api.dart';
import 'package:flutterchat/core/viewmodels/base_view_model.dart';
import 'package:flutterchat/locator.dart';

class ChatListViewModel extends BaseViewModel{

  final api = locator<MatrixApi>();

  List<String> list;
  getChatList(String userId) async {
    list = null;
  }
}