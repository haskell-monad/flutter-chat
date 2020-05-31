import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/core/common/common_enum.dart';
import 'package:flutterchat/core/viewmodels/chat_list_view_model.dart';
import 'package:flutterchat/ui/shared/adaptive_page_layout.dart';
import 'package:flutterchat/ui/views/base_view.dart';

class ChatListView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BaseView<ChatListViewModel>(
      onModelReady: (model) => model.getChatList("userId"),
      builder: (context, model, child) =>
          Scaffold(
              backgroundColor: Color.fromARGB(255, 255, 241, 159),
              body: model.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Welcome Beckham"}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Here are all your posts'),
                      ),
                ],)
          ),
    );
  }

//  Widget getPostsUi(List<Post> posts) => ListView.builder(
//      itemCount: posts.length,
//      itemBuilder: (context, index) => PostListItem(
//        post: posts[index],
//        onTap: () {
//          Navigator.pushNamed(context, 'post', arguments: posts[index]);
//        },
//      )
//  );
}
