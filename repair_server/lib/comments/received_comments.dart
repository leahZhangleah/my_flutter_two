import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/http_helper/api_request.dart';
import 'comment.dart';
import 'package:repair_server/http_helper/HttpUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'comment_response.dart';
import 'one_comment.dart';
import 'package:repair_server/http_helper/url_manager.dart';
import 'package:repair_server/register.dart';

class ReceivedComments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReceivedCommentsState();
  }
}

class ReceivedCommentsState extends State<ReceivedComments> with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Comment> comments;

  @override
  void initState() {
    super.initState();
    comments=new List();
    _getReceivedComments(nowPage, limit);
  }

  //待报价订单列表
  Future<void> _getReceivedComments(int nowPage, int limit) async {
    ApiRequest().getReceivedComments(context, nowPage, limit).then((page){
      if(page!=null){
        comments.addAll(page.comments);
        total = page.total;
      }
    });
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        comments.clear();
        _getReceivedComments(nowPage,limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      if(comments.length < total){
        setState(() {
          nowPage+=1;
          _getReceivedComments(nowPage,limit);
        });
      }else{
        Fluttertoast.showToast(msg: "没有更多的评价了");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收到评价"),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Refresh(
              child:
                buildCommentsList(comments),
              onFooterRefresh: onFooterRefresh,
              onHeaderRefresh: onHeaderRefresh,
              )),
    );
  }

  Widget buildCommentsList(List<Comment> comments){
    return ListView.builder(
        itemCount: comments.length==0?1:comments.length,
        itemBuilder: (context, index) {
          if(comments==null||comments.length==0){
            return Center(child:Text("暂无相关数据～"));
          }
          var comment = comments[index];
          return OneComment(comment: comment,);
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}